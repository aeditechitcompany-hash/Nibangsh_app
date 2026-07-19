import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/models/application_step_model.dart';
import '../../../common/services/storage.dart';

class HomeController extends GetxController {
  final selectedNavIndex = 0.obs;
  final ImagePicker _picker = ImagePicker();

  final email = ''.obs;
  final country = ''.obs;
  final gpa = ''.obs;
  final passoutYear = ''.obs;
  final degree = ''.obs;

  // Application journey
  final steps = <ApplicationStepModel>[].obs;
  final progressPercent = 0.obs;

  bool _step1Done = false;
  String _step2LanguageTest = '';
  bool _step3Done = false;

  // TODO: replace with the real logged-in user's name once auth exists.
  final userName = ''.obs;

  // Steps 1-3 belong to the student, steps 4-10 belong to the admin.
  List<ApplicationStepModel> get userSteps =>
      steps.where((s) => s.owner == StepOwner.user).toList();

  List<ApplicationStepModel> get adminSteps =>
      steps.where((s) => s.owner == StepOwner.admin).toList();

  int get userStepsDoneCount =>
      userSteps.where((s) => s.status == StepStatus.done).length;

  int get adminStepsDoneCount =>
      adminSteps.where((s) => s.status == StepStatus.done).length;

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String nameFromEmail(String email, {String fallback = 'Student'}) {
    if (email.isEmpty || !email.contains('@')) return fallback;
    final localPart = email.split('@').first;
    return localPart.isEmpty ? fallback : localPart;
  }

  String get initials {
    final name = userName.trim();
    if (name.isEmpty) return '?';
    final parts = name
        .split(RegExp(r'[\s._-]+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args is Map) {
      email.value = args['email']?.toString() ?? '';
      country.value = args['country']?.toString() ?? '';
      gpa.value = args['gpa']?.toString() ?? '';
      passoutYear.value = args['passoutYear']?.toString() ?? '';
      degree.value = args['degree']?.toString() ?? '';
    }

    userName.value = nameFromEmail(email.value);

    _loadUserName();
    _rebuildSteps();
  }

  Future<void> _loadUserName() async {
    final storedName = await StorageService.getUserName();
    if (storedName != null && storedName.trim().isNotEmpty) {
      userName.value = storedName.trim();
    }
  }

  void _rebuildSteps() {
    final doneFlags = <int, bool>{
      1: _step1Done,
      2: _step2LanguageTest.isNotEmpty,
      3: _step3Done,
      for (final def in ApplicationStepsCatalog.definitions.skip(3))
        def['id'] as int: false,
    };

    var activeAssigned = false;
    final built = <ApplicationStepModel>[];

    for (final def in ApplicationStepsCatalog.definitions) {
      final id = def['id'] as int;
      final done = doneFlags[id] ?? false;

      StepStatus status;
      if (done) {
        status = StepStatus.done;
      } else if (!activeAssigned) {
        status = StepStatus.active;
        activeAssigned = true;
      } else {
        status = StepStatus.pending;
      }

      var subtitle = def['subtitle'] as String;
      if (id == 2 && _step2LanguageTest.isNotEmpty) {
        subtitle = '$_step2LanguageTest selected';
      }

      built.add(
        ApplicationStepModel(
          id: id,
          title: def['title'] as String,
          subtitle: subtitle,
          icon: def['icon'],
          owner: def['owner'] as StepOwner,
          status: status,
        ),
      );
    }

    steps.assignAll(built);

    final doneCount = doneFlags.values.where((v) => v).length;
    progressPercent.value =
        ((doneCount / ApplicationStepsCatalog.definitions.length) * 100)
            .round();
  }

  // ── Step 1: document (marksheet/transcript) upload ──
  void markStep1Done() {
    _step1Done = true;
    _rebuildSteps();
  }

  // ── Step 2: language test selection ──
  void selectLanguageTest(String test) {
    _step2LanguageTest = test;
    _rebuildSteps();
  }

  // ── Step 3: all documents upload ──
  void markStep3Done() {
    _step3Done = true;
    _rebuildSteps();
  }

  // Picks a photo (camera or gallery) as the "upload" for a step, then
  // marks that step done once a file is chosen.
  Future<void> pickStepPhoto(int stepId, ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1600,
      );
      if (picked == null) return;
      if (stepId == 1) {
        markStep1Done();
      } else {
        markStep3Done();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        source == ImageSource.camera
            ? 'Could not open camera.'
            : 'Could not open gallery.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void setNavIndex(int index) => selectedNavIndex.value = index;
}
