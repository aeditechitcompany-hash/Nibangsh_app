import 'dart:io';

import 'package:file_picker/file_picker.dart';

/// Result of a successful file pick.
class PickedDocument {
  final String name;
  final String? path;
  final int? sizeBytes;

  const PickedDocument({
    required this.name,
    this.path,
    this.sizeBytes,
  });
}

/// Thin wrapper around file_picker.
class DocumentPickerService {
  DocumentPickerService._();

  /// Opens the native file picker and lets the user
  /// select a single PDF or image.
  static Future<PickedDocument?> pickDocument() async {
    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: const [
          'pdf',
          'jpg',
          'jpeg',
          'png',
          'heic',
        ],
      );

      if (file == null) {
        return null;
      }

      return PickedDocument(
        name: file.name,
        path: file.path,
        sizeBytes: file.path != null
            ? await File(file.path!).length()
            : null,      );
    } catch (_) {
      // Fallback to any file if the custom extension filter
      // is not supported on the current platform.
      try {
        final file = await FilePicker.pickFile(
          type: FileType.any,
        );

        if (file == null) {
          return null;
        }

        return PickedDocument(
          name: file.name,
          path: file.path,
          sizeBytes: file.path != null
              ? await File(file.path!).length()
              : null,
        );
      } catch (_) {
        return null;
      }
    }
  }
}