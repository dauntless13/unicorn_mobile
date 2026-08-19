import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../service/api_service/api_worker.dart';
import '../service/session/session_helper.dart';
import '../ui/auth/view/model/login/login_response.dart';

class NurseryModuleController extends GetxController {
  final evaluationEnabledForTeachers = true.obs;
  final evaluationEnabledForParents = true.obs;

  void apply({required bool teachers, required bool parents}) {
    evaluationEnabledForTeachers.value = teachers;
    evaluationEnabledForParents.value = parents;
  }

  Future<void> hydrateFromSession() async {
    final session = await SessionHelper().getLoginResponse();
    final user = session?.data?.user;
    apply(
      teachers: user?.evaluationEnabledForTeachers ?? true,
      parents: user?.evaluationEnabledForParents ?? true,
    );
  }

  Future<void> load(BuildContext context) async {
    await hydrateFromSession();
    try {
      final apiWorker = Get.isRegistered<ApiWorker>()
          ? Get.find<ApiWorker>()
          : Get.put(ApiWorker());
      final module = await apiWorker.getEvaluationModule(context);
      if (module == null) return;
      apply(teachers: module.teachers, parents: module.parents);
      await _persistToSession(module.teachers, module.parents);
    } catch (error) {
      debugPrint('Nursery module load error: $error');
    }
  }

  Future<void> _persistToSession(bool teachers, bool parents) async {
    final session = await SessionHelper().getLoginResponse();
    final user = session?.data?.user;
    if (session == null || user == null) return;
    session.data = session.data?.copyWith(
      user: user.copyWith(
        evaluationEnabledForTeachers: teachers,
        evaluationEnabledForParents: parents,
      ),
    );
    await SessionHelper().setLoginResponse(session);
  }
}

NurseryModuleController ensureNurseryModuleController() {
  if (Get.isRegistered<NurseryModuleController>()) {
    return Get.find<NurseryModuleController>();
  }
  return Get.put(NurseryModuleController(), permanent: true);
}

bool isTeacherEvaluationEnabled() =>
    ensureNurseryModuleController().evaluationEnabledForTeachers.value;

void leaveIfTeacherEvaluationDisabled() {
  if (!isTeacherEvaluationEnabled()) {
    Get.back();
  }
}
