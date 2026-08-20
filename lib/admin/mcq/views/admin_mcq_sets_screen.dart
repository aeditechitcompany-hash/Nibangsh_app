import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';
import 'package:nibangsh_consultancy/common/util/responsive.dart';
import '../controller/mcq_controller.dart';
import 'mcq_screen.dart';

class AdminMcqSetsScreen extends StatefulWidget {
  const AdminMcqSetsScreen({super.key});

  @override
  State<AdminMcqSetsScreen> createState() => _AdminMcqSetsScreenState();
}

class _AdminMcqSetsScreenState extends State<AdminMcqSetsScreen> {
  final controller = Get.put(AdminMcqController());

  // Sets created but not yet holding a question — kept locally so they
  // still show up (with 0 questions) before the first MCQ is saved.
  final List<String> _emptySets = [];

  List<String> get _allSetNames {
    final fromQuestions = controller.questions
        .map((q) => q.setName ?? '')
        .where((s) => s.isNotEmpty)
        .toSet();
    final combined = {...fromQuestions, ..._emptySets}.toList();
    combined.sort();
    return combined;
  }

  int _countFor(String setName) =>
      controller.questions.where((q) => (q.setName ?? '') == setName).length;

  void _openSet(String setName) {
    Get.to(() => AdminMcqScreen(setName: setName))?.then((_) => setState(() {}));
  }

  void _addSetDialog() {
    final nameController = TextEditingController();
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('New Set'),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'e.g. Set 4'),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) return;
              if (_allSetNames.contains(name)) {
                Get.snackbar('Already exists', 'A set named "$name" already exists.',
                    snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(16));
                return;
              }
              Get.back();
              setState(() => _emptySets.add(name));
              _openSet(name);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addSetDialog,
        backgroundColor: AppColors.primaryBlue,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add Set',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            ResponsiveDashboardWrapper(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                child: Obx(() {
                  // Referencing controller.questions here keeps this
                  // reactive to adds/edits/deletes from the set screen.
                  // ignore: unused_local_variable
                  final _ = controller.questions.length;
                  final sets = _allSetNames;
                  if (sets.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.layers_outlined,
                                size: 40, color: AppColors.textGrey.withOpacity(0.4)),
                            const SizedBox(height: 12),
                            const Text('No sets yet',
                                style: TextStyle(
                                    color: AppColors.textGrey, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            const Text('Tap "Add Set" to create your first quiz set',
                                style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
                          ],
                        ),
                      ),
                    );
                  }
                  return Column(children: sets.map(_setCard).toList());
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.navyDark, AppColors.navyLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14), shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 18),
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed(AppRoute.notifications),
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14), shape: BoxShape.circle),
                  child: const Icon(Icons.notifications_none_rounded,
                      color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text('Quiz Sets',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('Organize MCQs into sets for students',
              style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 14.5)),
        ],
      ),
    );
  }

  Widget _setCard(String setName) {
    final count = _countFor(setName);
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _openSet(setName),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.quiz_rounded, color: AppColors.primaryBlue),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(setName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 2),
                  Text('$count Question${count == 1 ? '' : 's'}',
                      style: const TextStyle(fontSize: 13, color: AppColors.textGrey)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }
}