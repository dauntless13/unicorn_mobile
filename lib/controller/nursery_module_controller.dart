import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../service/api_service/api_worker.dart';
import '../service/session/session_helper.dart';

class NurseryModuleController extends GetxController {
  final evaluationEnabledForTeachers = true.obs;
  final evaluationEnabledForParents = true.obs;
  final chatEnabled = true.obs;
  final allowTeachersViewPersonalInfo = true.obs;

  void apply({
    required bool teachers,
    required bool parents,
    bool? chat,
    bool? personalInfo,
  }) {
    evaluationEnabledForTeachers.value = teachers;
    evaluationEnabledForParents.value = parents;
    if (chat != null) chatEnabled.value = chat;
    if (personalInfo != null) allowTeachersViewPersonalInfo.value = personalInfo;
  }

  Future<void> hydrateFromSession() async {
    final session = await SessionHelper().getLoginResponse();
    final user = session?.data?.user;
    apply(
      teachers: user?.evaluationEnabledForTeachers ?? true,
      parents: user?.evaluationEnabledForParents ?? true,
      chat: user?.chatEnabled ?? true,
      personalInfo: user?.allowTeachersViewPersonalInfo ?? true,
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
      apply(
        teachers: module.teachers,
        parents: module.parents,
        chat: module.chatEnabled,
        personalInfo: module.allowTeachersViewPersonalInfo,
      );
      await _persistToSession(module);
    } catch (error) {
      debugPrint('Nursery module load error: $error');
    }
  }

  Future<void> _persistToSession(
    ({
      bool teachers,
      bool parents,
      bool chatEnabled,
      bool allowTeachersViewPersonalInfo,
    }) module,
  ) async {
    final session = await SessionHelper().getLoginResponse();
    final user = session?.data?.user;
    if (session == null || user == null) return;
    session.data = session.data?.copyWith(
      user: user.copyWith(
        evaluationEnabledForTeachers: module.teachers,
        evaluationEnabledForParents: module.parents,
        chatEnabled: module.chatEnabled,
        allowTeachersViewPersonalInfo: module.allowTeachersViewPersonalInfo,
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

bool isMobileChatEnabled() =>
    ensureNurseryModuleController().chatEnabled.value;

bool canTeachersViewPersonalInfo() =>
    ensureNurseryModuleController().allowTeachersViewPersonalInfo.value;

void leaveIfTeacherEvaluationDisabled() {
  if (!isTeacherEvaluationEnabled()) {
    Get.back();
  }
}
