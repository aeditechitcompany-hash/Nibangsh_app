import 'package:file_picker/file_picker.dart';

/// Result of a successful file pick.
class PickedDocument {
  final String name;
  final String? path;
  final int? sizeBytes;

  const PickedDocument({required this.name, this.path, this.sizeBytes});
}

/// Thin wrapper around `file_picker` so every "Browse" button in the app
/// opens the same native picker (Files / Gallery / Photos / Drive, etc.)
/// and returns a consistent result.
///
/// Requires the `file_picker` package:
///   dependencies:
///     file_picker: ^8.1.2
class DocumentPickerService {
  DocumentPickerService._();

  /// Opens the native file/photo browser and lets the user pick a single
  /// document (PDF) or image (jpg/jpeg/png). Returns `null` if the user
  /// cancels the picker.
  static Future<PickedDocument?> pickDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png', 'heic'],
        withData: false,
      );

      if (result == null || result.files.isEmpty) return null;

      final file = result.files.single;
      return PickedDocument(name: file.name, path: file.path, sizeBytes: file.size);
    } catch (_) {
      // FileType.custom can throw on some platforms/configs if the
      // allowedExtensions filter isn't supported — fall back to FileType.any.
      final result = await FilePicker.platform.pickFiles(type: FileType.any);
      if (result == null || result.files.isEmpty) return null;
      final file = result.files.single;
      return PickedDocument(name: file.name, path: file.path, sizeBytes: file.size);
    }
  }
}