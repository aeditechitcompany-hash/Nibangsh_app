import 'package:get/get.dart';
import '../../../common/models/required_document.dart';

class DocsController extends GetxController {
  final documents = <RequiredDocument>[].obs;

  @override
  void onInit() {
    super.onInit();
    documents.assignAll(RequiredDocumentsCatalog.seed);
  }

  List<RequiredDocument> get uploadedFiles =>
      documents.where((d) => d.uploaded).toList();

  int get uploadedCount => documents.where((d) => d.uploaded).length;
  int get pendingCount => documents.where((d) => !d.uploaded).length;
  int get totalCount => documents.length;

  void markUploaded(String id) {
    final index = documents.indexWhere((d) => d.id == id);
    if (index == -1) return;
    documents[index] = documents[index].copyWith(uploaded: true);
  }

  void removeUpload(String id) {
    final index = documents.indexWhere((d) => d.id == id);
    if (index == -1) return;
    documents[index] = documents[index].copyWith(uploaded: false);
  }

  void browseAndUploadNextPending() {
    for (final doc in documents) {
      if (!doc.uploaded) {
        markUploaded(doc.id);
        break;
      }
    }
  }
}