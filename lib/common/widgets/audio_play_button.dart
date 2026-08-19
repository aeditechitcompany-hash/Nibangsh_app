import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../util/app_colors.dart';

/// Small pill button that plays/pauses an mp3 file.
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

  const AudioPlayButton({
    super.key,
    required this.filePath,
    this.label = 'Play audio',
    this.isAsset = false,
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
    if (_activeButton == this) {
      _activeButton = null;
    }
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: _toggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isLoading
                  ? Icons.hourglass_top_rounded
                  : _isPlaying
                  ? Icons.pause_circle_filled_rounded
                  : Icons.play_circle_fill_rounded,
              color: AppColors.primaryBlue,
              size: 18,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                _isLoading
                    ? 'Loading...'
                    : _isPlaying
                        ? 'Playing...'
                        : widget.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
