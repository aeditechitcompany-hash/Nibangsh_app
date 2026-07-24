import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../util/app_colors.dart';

/// Small pill button that plays/pauses a local mp3 file.
/// Used to preview MCQ audio clips on both the admin and student screens.
///
/// Requires the `audioplayers` package:
///   dependencies:
///     audioplayers: ^6.0.0
class AudioPlayButton extends StatefulWidget {
  final String filePath;
  final String label;

  const AudioPlayButton({
    super.key,
    required this.filePath,
    this.label = 'Play audio',
  });

  @override
  State<AudioPlayButton> createState() => _AudioPlayButtonState();
}

class _AudioPlayButtonState extends State<AudioPlayButton> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  Future<void> _toggle() async {
    try {
      if (_isPlaying) {
        await _player.pause();
        setState(() => _isPlaying = false);
      } else {
        await _player.play(DeviceFileSource(widget.filePath));
        setState(() => _isPlaying = true);
      }
    } catch (e) {
      debugPrint('Audio playback failed: $e');
    }
  }

  @override
  void dispose() {
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
              _isPlaying
                  ? Icons.pause_circle_filled_rounded
                  : Icons.play_circle_fill_rounded,
              color: AppColors.primaryBlue,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              _isPlaying ? 'Playing...' : widget.label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
