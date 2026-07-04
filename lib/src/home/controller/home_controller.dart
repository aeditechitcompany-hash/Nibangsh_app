import 'package:get/get.dart';
import '../../../common/models/application_step_model.dart';

class HomeController extends GetxController {
  final selectedNavIndex = 0.obs;

  // Academic profile
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
  final userName = 'Student'.obs;

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String get initials {
    final parts = userName.value.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      country.value = args['country']?.toString() ?? '';
      gpa.value = args['gpa']?.toString() ?? '';
      passoutYear.value = args['passoutYear']?.toString() ?? '';
      degree.value = args['degree']?.toString() ?? '';
    }
    _rebuildSteps();
  }

  void _rebuildSteps() {
    final doneFlags = <int, bool>{
      1: _step1Done,
      2: _step2LanguageTest.isNotEmpty,
      3: _step3Done,
      for (final def in ApplicationStepsCatalog.definitions.skip(3)) def['id'] as int: false,
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

      built.add(ApplicationStepModel(
        id: id,
        title: def['title'] as String,
        subtitle: subtitle,
        icon: def['icon'],
        owner: def['owner'] as StepOwner,
        status: status,
      ));
    }

    steps.assignAll(built);

    final doneCount = doneFlags.values.where((v) => v).length;
    progressPercent.value = ((doneCount / ApplicationStepsCatalog.definitions.length) * 100).round();
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

  void setNavIndex(int index) => selectedNavIndex.value = index;
}