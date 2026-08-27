import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

/// Lets an external tap (e.g. tapping the whole answer box, not just the
/// audio icon) trigger playback on a specific [AudioPlayButton] without
/// needing a GlobalKey. Create one per audio clip and pass it to both the
/// button and the surrounding tap handler.
class AudioPlayButtonController {
  VoidCallback? _playCallback;

  void _bind(VoidCallback callback) {
    _playCallback = callback;
  }

  void _unbind(VoidCallback callback) {
    if (_playCallback == callback) {
      _playCallback = null;
    }
  }

  /// Starts playback if the clip is idle. Safe to call repeatedly — it
  /// will never pause a clip that's already playing, so tapping the
  /// answer box again mid-playback won't cut the audio off.
  void play() {
    _playCallback?.call();
  }
}

/// Large circular icon button that plays/pauses an mp3 file.
/// Used to preview MCQ audio clips on both the admin and student screens,
/// and listening clips on the quiz screen.
///
/// Requires the `audioplayers` package:
///   dependencies:
///     audioplayers: ^6.0.0
class AudioPlayButton extends StatefulWidget {
  final String filePath;
  final String label;

  // false (default): filePath is a device file path, e.g. one picked via
  //   file_picker and stored on disk — used by the MCQ admin/student screens.
  // true: filePath is a Flutter asset path declared in pubspec.yaml, e.g.
  //   'assets/quiz/set1/q21.mp3' — used by the quiz listening questions.
  final bool isAsset;

  // Diameter of the circular button. Bump this up for the main
  // question-level "Listen" button; smaller values suit inline/overlay
  // uses (e.g. on top of an image option tile).
  final double size;

  // Optional external trigger — pass the same controller into the
  // surrounding GestureDetector's onTap so tapping anywhere on the
  // answer box also starts this clip playing.
  final AudioPlayButtonController? controller;

  const AudioPlayButton({
    super.key,
    required this.filePath,
    this.label = 'Play audio',
    this.isAsset = false,
    this.size = 60,
    this.controller,
  });

  @override
  State<AudioPlayButton> createState() => _AudioPlayButtonState();
}

class _AudioPlayButtonState extends State<AudioPlayButton> {
  static _AudioPlayButtonState? _activeButton;

  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      _resetToIdle();
    });
    widget.controller?._bind(_playOnly);
  }

  @override
  void didUpdateWidget(covariant AudioPlayButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._unbind(_playOnly);
      widget.controller?._bind(_playOnly);
    }
  }

  void _resetToIdle() {
    if (_activeButton == this) {
      _activeButton = null;
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isPlaying = false;
      });
    }
  }

  Future<void> _stopForNextAudio() async {
    await _player.stop();
    _resetToIdle();
  }

  /// Starts playback only if idle — used when the surrounding answer box
  /// is tapped, so it never pauses a clip that's already playing.
  Future<void> _playOnly() async {
    if (_isPlaying || _isLoading) return;
    await _toggle();
  }

  Future<void> _toggle() async {
    try {
      if (_isPlaying) {
        await _player.pause();
        _resetToIdle();
      } else {
        final previousButton = _activeButton;
        if (previousButton != null && previousButton != this) {
          await previousButton._stopForNextAudio();
        }

        _activeButton = this;
        if (mounted) setState(() => _isLoading = true);
        final path = widget.filePath;
        final source = widget.isAsset
            // AssetSource expects the path without the leading 'assets/'
            // segment.
            ? AssetSource(_stripAssetsPrefix(path))
            : path.startsWith('http://') || path.startsWith('https://')
                ? UrlSource(path)
                : DeviceFileSource(path);
        await _player.play(source);
        if (mounted) {
          setState(() {
            _isLoading = false;
            _isPlaying = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Audio playback failed: $e');
      if (_activeButton == this) {
        _activeButton = null;
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isPlaying = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Audio could not be played.')),
        );
      }
    }
  }

  String _stripAssetsPrefix(String path) {
    return path.startsWith('assets/') ? path.substring('assets/'.length) : path;
  }

  @override
  void dispose() {
    widget.controller?._unbind(_playOnly);
    if (_activeButton == this) {
      _activeButton = null;
    }
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = widget.size * 0.62;
    final loaderSize = widget.size * 0.5;

    return Tooltip(
      message: widget.label,
      child: InkWell(
        borderRadius: BorderRadius.circular(widget.size / 2),
        onTap: _toggle,
        child: Container(
          width: widget.size,
          height: widget.size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _isPlaying
                ? const Color.fromARGB(255, 0, 0, 0)
                : const Color.fromARGB(255, 63, 67, 70).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: _isLoading
              ? SizedBox(
                  width: loaderSize,
                  height: loaderSize,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.4,
                    color: _isPlaying ? Colors.white : const Color.fromARGB(255, 20, 23, 27),
                  ),
                )
              : Icon(
                  _isPlaying
                      ? Icons.pause_rounded
                      : Icons.headphones_rounded,
                  color: _isPlaying ? Colors.white : const Color.fromARGB(255, 27, 30, 34),
                  size: iconSize,
                ),
        ),
      ),
    );
  }
}