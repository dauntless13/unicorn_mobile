import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../../../../../../service/api_service/api_worker.dart';
import '../../../../../../../../service/session/session_helper.dart';
import '../../../../../../../../core/utils/report_time_utils.dart';
import '../../../../../../../../translation/language_controller.dart';
import '../../../../../../../../widget/common_toastification.dart';
import '../../../../../../../teacher/teacher_bottom_tab/view/screens/home/view/add_post/mode/upload_images/upload_images_request.dart';
import '../../../../../../../teacher/teacher_bottom_tab/view/screens/home/view/report/model/evaluation_forms_list/evaluation_forms_list_request.dart';
import '../../../../../../../teacher/teacher_bottom_tab/view/screens/home/view/report/model/evaluation_forms_list/evaluation_forms_list_response.dart';
import '../../../../../../../teacher/teacher_bottom_tab/view/screens/home/view/report/model/report_details_by_student_slug/report_details_by_student_slug_request.dart';
import '../../../../../../../teacher/teacher_bottom_tab/view/screens/home/view/report/model/report_details_by_student_slug/report_details_by_student_slug_response.dart';
import '../../../../../../../teacher/teacher_bottom_tab/view/screens/kids/model/student_by_slug/student_by_slug_request.dart';
import '../../../../../../../teacher/teacher_bottom_tab/view/screens/kids/model/student_by_slug/student_by_slug_response.dart';
import '../../../../../../../teacher/teacher_bottom_tab/view/screens/profile/model/city/city_request.dart';
import '../../../../../../../teacher/teacher_bottom_tab/view/screens/profile/model/city/city_response.dart';
import '../../../../../../../teacher/teacher_bottom_tab/view/screens/profile/model/country/country_request.dart';
import '../../../../../../../teacher/teacher_bottom_tab/view/screens/profile/model/country/country_response.dart';
import '../../../../../../../teacher/teacher_bottom_tab/view/screens/profile/model/get_all_class/get_all_class_request.dart';
import '../../../../../../../teacher/teacher_bottom_tab/view/screens/profile/model/get_all_class/get_all_class_response.dart';
import '../../../../../../../teacher/teacher_bottom_tab/view/screens/profile/model/state/state_request.dart';
import '../../../../../../../teacher/teacher_bottom_tab/view/screens/profile/model/state/state_response.dart';
import '../../../profile/view/model/parent_data_by_slug/parent_data_by_slug_response.dart';
import '../model/fees_details/fees_details_request.dart';
import '../model/fees_details/fees_details_response.dart';
import '../model/gallery_details/gallery_details_response.dart';
import '../model/medical_reports/student_nurse_reports_request.dart';
import '../model/medical_reports/student_nurse_reports_response.dart';
import '../model/update_student_details/update_student_details_request.dart';

class KidsController extends GetxController {
  final ApiWorker apiWorker = Get.put(ApiWorker());

  void clearKidsScreenData() {
    ActiveReportDetails.value = null;
    evaluationForms.clear();
    medicalReports.clear();
    studentInfoDetails.value = null;
    studentId = null;
    feesList.clear();
    galleryList.clear();
    gallerySections.clear();
    selectedClass.value = null;
    evaluationFormsStartDate.value = null;
    evaluationFormsEndDate.value = null;
    evaluationFormsSearchController.clear();
    medicalReportsStartDate.value = null;
    medicalReportsEndDate.value = null;
    medicalReportsSearchController.clear();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // REPORT / ACTIVITY
  // ══════════════════════════════════════════════════════════════════════════
  RxBool isReportDetailsLoading = false.obs;
  Rxn<StudentReportDetailsData> ActiveReportDetails =
      Rxn<StudentReportDetailsData>();
  String? studentId;
  final RxBool isEvaluationFormsLoading = false.obs;
  final RxList<Evaluations> evaluationForms = <Evaluations>[].obs;
  final Rxn<DateTime> evaluationFormsStartDate = Rxn<DateTime>();
  final Rxn<DateTime> evaluationFormsEndDate = Rxn<DateTime>();
  final TextEditingController evaluationFormsSearchController =
      TextEditingController();
  final RxBool isMedicalReportsLoading = false.obs;
  final RxList<Datum> medicalReports = <Datum>[].obs;
  final Rxn<DateTime> medicalReportsStartDate = Rxn<DateTime>();
  final Rxn<DateTime> medicalReportsEndDate = Rxn<DateTime>();
  final TextEditingController medicalReportsSearchController =
      TextEditingController();

  // Custom relationship text
  final parentCustomRelationshipCtrl = TextEditingController();
  final emergencyCustomRelationshipCtrl = TextEditingController();

  // Track if "Other" is selected
  RxBool isParentOther = false.obs;
  RxBool isEmergencyOther = false.obs;

  Future<void> studentDetailsBySlug(
    BuildContext context,
    String slug, {
    String date = "",
  }) async {
    try {
      isReportDetailsLoading.value = true;

      final response = await apiWorker.reportStudentDetails(
        ReportDetailsByStudentSlugRequest(
            lang: LanguageController.to.apiLanguage,
            date: ReportTimeUtils.resolveIsoDate(date)),
        context,
        slug,
      );

      if (response?.success == true) {
        ActiveReportDetails.value = response?.data;
        // studentId = response?.data?.;
      } else {
        showToast(
            context, "Error", response?.message ?? "Failed to load report",
            type: ToastificationType.error);
      }
    } catch (e) {
      debugPrint("Student Details Error: $e");
    } finally {
      isReportDetailsLoading.value = false;
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  String displayDate(DateTime? date) {
    if (date == null) return '-';
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} '
        '${monthNames[date.month - 1]} ${date.year}';
  }

  Future<void> fetchEvaluationForms(
    BuildContext context, {
    required String studentSlug,
    String? classSlug,
  }) async {
    try {
      isEvaluationFormsLoading.value = true;

      final response = await apiWorker.evaluationFormsList(
        EvaluationFormsListRequest(
          lang: LanguageController.to.apiLanguage,
          status: 'SUBMITTED',
          classSlug: '',
          studentSlug: studentSlug,
          startDate: formatDate(evaluationFormsStartDate.value),
          endDate: formatDate(evaluationFormsEndDate.value),
          search: evaluationFormsSearchController.text.trim(),
          page: 1,
          limit: 10,
        ),
        context,
      );

      if (response?.success == true) {
        evaluationForms.assignAll(response?.data?.evaluations ?? []);
      } else {
        evaluationForms.clear();
        showToast(
          context,
          "Error",
          response?.message ?? "Failed to load evaluation forms",
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      debugPrint("Evaluation forms error: $e");
      evaluationForms.clear();
      showToast(
        context,
        "Error",
        "Failed to load evaluation forms",
        type: ToastificationType.error,
      );
    } finally {
      isEvaluationFormsLoading.value = false;
    }
  }

  Future<void> fetchMedicalReports(
    BuildContext context, {
    required String studentSlug,
  }) async {
    try {
      isMedicalReportsLoading.value = true;

      final response = await apiWorker.studentNurseReportsList(
        StudentNurseReportsRequest(
          lang: LanguageController.to.apiLanguage,
          search: medicalReportsSearchController.text.trim(),
          startDate: formatDate(medicalReportsStartDate.value),
          endDate: formatDate(medicalReportsEndDate.value),
          page: 1,
          limit: 10,
        ),
        context,
        studentSlug,
      );

      if (response?.success == true) {
        medicalReports.assignAll(response?.data?.data ?? []);
      } else {
        medicalReports.clear();
        showToast(
          context,
          "Error",
          response?.message ?? "Failed to load medical reports",
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      debugPrint("Medical reports error: $e");
      medicalReports.clear();
      showToast(
        context,
        "Error",
        "Failed to load medical reports",
        type: ToastificationType.error,
      );
    } finally {
      isMedicalReportsLoading.value = false;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PARENT
  // ══════════════════════════════════════════════════════════════════════════
  Rxn<ParentData> parent = Rxn<ParentData>();
  RxBool isLoading = false.obs;

  Future<void> parentGetBySlug(BuildContext context) async {
    try {
      isLoading.value = true;

      final loginResponse = await SessionHelper().getLoginResponse();
      final String? slug = loginResponse?.data?.user?.slug;
      if (slug == null || slug.isEmpty) throw Exception("Slug not found");

      final response = await apiWorker.parentBySlug(slug, context);

      if (response?.success == true) {
        parent.value = response?.data;
      } else {
        showToast(context, "Error", response?.message ?? "Something went wrong",
            type: ToastificationType.error);
      }
    } catch (e) {
      showToast(context, "Error", e.toString(), type: ToastificationType.error);
    } finally {
      isLoading.value = false;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STUDENT INFO (READ)
  // ══════════════════════════════════════════════════════════════════════════
  RxBool isStudentDetailsLoading = false.obs;
  Rxn<StudentDataGetBySlug> studentInfoDetails = Rxn<StudentDataGetBySlug>();

  Future<void> fetchStudentsBySlug(BuildContext context, String slug) async {
    try {
      isStudentDetailsLoading.value = true;
      studentInfoDetails.value = null;
      studentId = null;
      feesList.clear();
      galleryList.clear();
      gallerySections.clear();

      final response = await apiWorker.studentBySlug(
        StudentBySlugRequest(lang: LanguageController.to.apiLanguage),
        context,
        slug,
      );

      if (response?.success == true) {
        studentInfoDetails.value = response?.data;
        studentId = response?.data?.studentId;
        // ✅ CALL HERE (AFTER ID IS READY)
        await fetchFeesDetails(context);
        await fetchGallery(context);
      } else {
        debugPrint(response?.message);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isStudentDetailsLoading.value = false;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // EDIT STUDENT — TEXT CONTROLLERS
  // ══════════════════════════════════════════════════════════════════════════

  // Student
  final studentFirstNameCtrl = TextEditingController();
  final studentLastNameCtrl = TextEditingController();
  final studentAddressCtrl = TextEditingController();
  final studentZipCtrl = TextEditingController();
  final studentCurrencyCtrl = TextEditingController();
  final studentFeeAmountCtrl = TextEditingController();

  // Parent
  final parentFirstNameCtrl = TextEditingController();
  final parentLastNameCtrl = TextEditingController();
  final parentPhoneCtrl = TextEditingController();
  final parentCountryCodeCtrl = TextEditingController();
  final parentAddressCtrl = TextEditingController();
  final parentEducationCtrl = TextEditingController();
  final parentOccupationCtrl = TextEditingController();

  // Emergency
  final emergencyFirstNameCtrl = TextEditingController();
  final emergencyLastNameCtrl = TextEditingController();
  final emergencyEmailCtrl = TextEditingController();
  final emergencyPhoneCtrl = TextEditingController();
  final emergencyCountryCodeCtrl = TextEditingController();
  final emergencySecondaryPhoneCtrl = TextEditingController();
  final emergencySecondaryCodeCtrl = TextEditingController();
  final emergencyEducationCtrl = TextEditingController();
  final emergencyOccupationCtrl = TextEditingController();

  // ══════════════════════════════════════════════════════════════════════════
  // EDIT STUDENT — OBSERVABLES
  // ══════════════════════════════════════════════════════════════════════════
  RxString selectedGender = "".obs;
  RxString studentDob = "".obs;
  RxString selectedPackageDuration = "".obs;
  RxString parentRelationship = "".obs;
  RxString emergencyRelationship = "".obs;

  // Medical toggles
  RxBool hasAllergies = false.obs;
  RxBool takesMedications = false.obs;
  RxBool hasMedicalCondition = false.obs;
  RxBool pickup = false.obs;
  RxBool medicalDecision = false.obs;

  // Image upload
  RxString studentUploadedImageUrl = "".obs;
  RxBool isStudentImageUploading = false.obs;

  // Update loading
  RxBool isStudentUpdating = false.obs;

  // ══════════════════════════════════════════════════════════════════════════
  // LOCATION & CLASS DROPDOWNS
  // ══════════════════════════════════════════════════════════════════════════
  RxList<CountryData> countryList = <CountryData>[].obs;
  RxList<StateData> stateList = <StateData>[].obs;
  RxList<City> cityList = <City>[].obs;
  RxList<Class> classList = <Class>[].obs;

  Rxn<CountryData> selectedCountry = Rxn<CountryData>();
  Rxn<StateData> selectedState = Rxn<StateData>();
  Rxn<City> selectedCity = Rxn<City>();
  Rxn<Class> selectedClass = Rxn<Class>();

  Future<void> fetchCountries(BuildContext context) async {
    final response = await apiWorker.countryListing(
      countryRequest(page: 1, limit: 300),
      context,
    );
    if (response?.success == true) {
      countryList.assignAll(response?.data?.countries ?? []);
    }
  }

  Future<void> fetchStates(BuildContext context, String countryId) async {
    selectedState.value = null;
    selectedCity.value = null;
    stateList.clear();
    cityList.clear();

    final response = await apiWorker.stateListing(
      StateRequest(page: 1, limit: 300, countryId: countryId),
      context,
    );
    if (response?.success == true) {
      stateList.assignAll(response?.data?.states ?? []);
    }
  }

  Future<void> fetchCities(BuildContext context, String stateId) async {
    selectedCity.value = null;
    cityList.clear();

    final response = await apiWorker.cityListing(
      CityRequest(page: 1, limit: 300, stateId: stateId),
      context,
    );
    if (response?.success == true) {
      cityList.assignAll(response?.data?.cities ?? []);
    }
  }

  Future<void> fetchClasses(BuildContext context) async {
    final response = await apiWorker.getAllClassApi(
      GetAllClassRequest(
          page: 1, limit: 100, lang: LanguageController.to.apiLanguage),
      context,
    );
    if (response?.success == true) {
      classList.assignAll(response?.data?.classes ?? []);
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // INIT EDIT SCREEN — pre-fill all fields from loaded student data
  // ══════════════════════════════════════════════════════════════════════════
  Future<void> initEditStudentScreen(BuildContext context) async {
    final info = studentInfoDetails.value;
    if (info == null) return;

    // ── Student fields ──────────────────────────────────────────────────────
    studentFirstNameCtrl.text = info.firstName ?? "";
    studentLastNameCtrl.text = info.lastName ?? "";
    studentAddressCtrl.text = info.address ?? "";
    studentZipCtrl.text = info.zipcode ?? "";
    studentCurrencyCtrl.text = info.currency ?? "";
    studentFeeAmountCtrl.text = info.feeAmount?.toString() ?? "";
    selectedGender.value = info.gender ?? "";
    selectedPackageDuration.value = info.packageDuration ?? "";

    if (info.dateOfBirth != null) {
      final dob = info.dateOfBirth!;
      studentDob.value = '${dob.year.toString().padLeft(4, '0')}-'
          '${dob.month.toString().padLeft(2, '0')}-'
          '${dob.day.toString().padLeft(2, '0')}';
    }

    // ── Medical ─────────────────────────────────────────────────────────────
    hasAllergies.value = info.hasAllergies ?? false;
    takesMedications.value = info.takesMedications ?? false;
    hasMedicalCondition.value = info.hasMedicalCondition ?? false;
    pickup.value = info.pickup ?? false;
    medicalDecision.value = info.medicalDecision ?? false;

    // ── Parent ──────────────────────────────────────────────────────────────
    final p = info.parentProfile;
    parentFirstNameCtrl.text = p?.firstName ?? "";
    parentLastNameCtrl.text = p?.lastName ?? "";
    parentPhoneCtrl.text = p?.phoneNumber ?? "";
    parentCountryCodeCtrl.text = p?.countryCode ?? "";
    parentAddressCtrl.text = p?.address ?? "";
    parentEducationCtrl.text = p?.education ?? "";
    parentOccupationCtrl.text = p?.occupation ?? "";
    final parentRelRaw = (p?.relationship ?? "").trim();
    final parentRel = parentRelRaw.toUpperCase();
    const parentKnown = ["FATHER", "MOTHER", "GUARDIAN", "OTHER"];
    if (parentRel.isEmpty) {
      parentRelationship.value = "";
      isParentOther.value = false;
      parentCustomRelationshipCtrl.clear();
    } else if (parentKnown.contains(parentRel) && parentRel != "OTHER") {
      parentRelationship.value = parentRel;
      isParentOther.value = false;
      parentCustomRelationshipCtrl.clear();
    } else {
      parentRelationship.value = "OTHER";
      isParentOther.value = true;
      if (parentRel == "OTHER") {
        parentCustomRelationshipCtrl.clear();
      } else {
        parentCustomRelationshipCtrl.text = parentRelRaw;
      }
    }

    // ── Emergency ───────────────────────────────────────────────────────────
    // final e = info.emergencyContact;
    // emergencyFirstNameCtrl.text = e?.firstName ?? "";
    // emergencyLastNameCtrl.text = e?.lastName ?? "";
    // emergencyEmailCtrl.text = e?.email ?? "";
    // emergencyPhoneCtrl.text = e?.phoneNumber ?? "";
    // emergencyCountryCodeCtrl.text = e?.countryCode ?? "";
    // emergencySecondaryPhoneCtrl.text = e?.secondaryPhoneNumber ?? "";
    // emergencySecondaryCodeCtrl.text = e?.secondaryCountryCode ?? "";
    // emergencyEducationCtrl.text = e?.education ?? "";
    // emergencyOccupationCtrl.text = e?.occupation ?? "";
    // const emergencyKnown = ["FATHER", "MOTHER", "GUARDIAN", "OTHER"];
    // final emergencyRelRaw = (e?.relation ?? "").trim();
    // final emergencyRel = emergencyRelRaw.toUpperCase();
    // final emergencyCustomRaw = (e?.customRelationship ?? "").trim();
    // final emergencyCustom = emergencyCustomRaw.toUpperCase();
    //
    // if (emergencyCustomRaw.isNotEmpty &&
    //     !emergencyKnown.contains(emergencyCustom)) {
    //   emergencyRelationship.value = "OTHER";
    //   isEmergencyOther.value = true;
    //   emergencyCustomRelationshipCtrl.text = emergencyCustomRaw;
    // } else if (emergencyRelRaw.isNotEmpty &&
    //     !emergencyKnown.contains(emergencyRel)) {
    //   emergencyRelationship.value = "OTHER";
    //   isEmergencyOther.value = true;
    //   emergencyCustomRelationshipCtrl.text = emergencyRelRaw;
    // } else if (emergencyRel == "OTHER" || emergencyCustom == "OTHER") {
    //   emergencyRelationship.value = "OTHER";
    //   isEmergencyOther.value = true;
    //   emergencyCustomRelationshipCtrl.text =
    //       emergencyCustom == "OTHER" ? "" : emergencyCustomRaw;
    // } else if (emergencyKnown.contains(emergencyRel)) {
    //   emergencyRelationship.value = emergencyRel;
    //   isEmergencyOther.value = false;
    //   emergencyCustomRelationshipCtrl.clear();
    // } else if (emergencyKnown.contains(emergencyCustom)) {
    //   emergencyRelationship.value = emergencyCustom;
    //   isEmergencyOther.value = false;
    //   emergencyCustomRelationshipCtrl.clear();
    // } else {
    //   emergencyRelationship.value = "";
    //   isEmergencyOther.value = false;
    //   emergencyCustomRelationshipCtrl.clear();
    // }
    // ── Emergency ───────────────────────────────────────────────────────────
    final e = info.emergencyContact;

    emergencyFirstNameCtrl.text = e?.firstName ?? "";
    emergencyLastNameCtrl.text = e?.lastName ?? "";
    emergencyEmailCtrl.text = e?.email ?? "";
    emergencyPhoneCtrl.text = e?.phoneNumber ?? "";
    emergencyCountryCodeCtrl.text = e?.countryCode ?? "";
    emergencySecondaryPhoneCtrl.text = e?.secondaryPhoneNumber ?? "";
    emergencySecondaryCodeCtrl.text = e?.secondaryCountryCode ?? "";
    emergencyEducationCtrl.text = e?.education ?? "";
    emergencyOccupationCtrl.text = e?.occupation ?? "";

    const knownRelations = ["FATHER", "MOTHER", "GUARDIAN", "OTHER"];

    final relationRaw = (e?.relation ?? "").trim();
    final relationUpper = relationRaw.toUpperCase();

    final customRaw = (e?.customRelationship ?? "").trim();

// ✅ PRIORITY: customRelationship (like "Auntry")
    if (customRaw.isNotEmpty) {
      emergencyRelationship.value = "OTHER";
      isEmergencyOther.value = true;
      emergencyCustomRelationshipCtrl.text = customRaw;
    }

// ✅ If only relation exists
    else if (relationRaw.isNotEmpty) {
      if (knownRelations.contains(relationUpper) && relationUpper != "OTHER") {
        emergencyRelationship.value = relationUpper;
        isEmergencyOther.value = false;
        emergencyCustomRelationshipCtrl.clear();
      } else {
        // e.g. relation = "Auntry"
        emergencyRelationship.value = "OTHER";
        isEmergencyOther.value = true;
        emergencyCustomRelationshipCtrl.text = relationRaw;
      }
    }

// ✅ Default
    else {
      emergencyRelationship.value = "";
      isEmergencyOther.value = false;
      emergencyCustomRelationshipCtrl.clear();
    }
    // ── Location ────────────────────────────────────────────────────────────
    await fetchCountries(context);

    final country = countryList.firstWhereOrNull(
      (c) => c.name == info.country || c.name == info.country,
    );
    if (country != null) {
      selectedCountry.value = country;
      await fetchStates(context, country.id ?? '');

      final state = stateList.firstWhereOrNull(
        (s) => s.name == info.state || s.name == info.state,
      );
      if (state != null) {
        selectedState.value = state;
        await fetchCities(context, state.id ?? '');

        final city = cityList.firstWhereOrNull(
          (c) => c.name == info.city || c.name == info.city,
        );
        if (city != null) selectedCity.value = city;
      }
    }

    // ── Class ────────────────────────────────────────────────────────────────
    await fetchClasses(context);
    if (info.className != null) {
      selectedClass.value = classList.firstWhereOrNull(
        (c) => c.name == info.className,
      );
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // UPDATE STUDENT DETAILS
  // ══════════════════════════════════════════════════════════════════════════
  Future<void> updateStudentDetails(BuildContext context, String slug) async {
    try {
      // ── Validation ─────────────────────────────────────────────────────
      if (studentFirstNameCtrl.text.trim().isEmpty ||
          studentLastNameCtrl.text.trim().isEmpty) {
        showToast(context, "Error", "First name & Last name are required",
            type: ToastificationType.error);
        return;
      }
      final rawParentPhone = parentPhoneCtrl.text.trim();
      final parentPhoneNumber = rawParentPhone.replaceAll(RegExp(r'\D'), '');
      if (parentPhoneNumber.isEmpty) {
        showToast(
          context,
          "Error",
          "Phone number is required",
          type: ToastificationType.error,
        );
        return;
      }
      if (parentPhoneNumber.length < 7 || parentPhoneNumber.length > 12) {
        showToast(
          context,
          "Error",
          "Invalid phone number",
          type: ToastificationType.error,
        );
        return;
      }

      final rawEmergencyPhone = emergencyPhoneCtrl.text.trim();
      final emergencyPhoneNumber =
          rawEmergencyPhone.replaceAll(RegExp(r'\D'), '');
      if (rawEmergencyPhone.isNotEmpty &&
          (emergencyPhoneNumber.length < 7 ||
              emergencyPhoneNumber.length > 12)) {
        showToast(
          context,
          "Error",
          "Invalid emergency phone number",
          type: ToastificationType.error,
        );
        return;
      }

      final rawEmergencySecondaryPhone =
          emergencySecondaryPhoneCtrl.text.trim();
      final emergencySecondaryNumber =
          rawEmergencySecondaryPhone.replaceAll(RegExp(r'\D'), '');
      if (rawEmergencySecondaryPhone.isNotEmpty &&
          (emergencySecondaryNumber.length < 7 ||
              emergencySecondaryNumber.length > 12)) {
        showToast(
          context,
          "Error",
          "Invalid secondary phone number",
          type: ToastificationType.error,
        );
        return;
      }
      if (isParentOther.value &&
          parentCustomRelationshipCtrl.text.trim().isEmpty) {
        showToast(
          context,
          "Error",
          "Please enter parent relationship",
          type: ToastificationType.error,
        );
        return;
      }
      if (isEmergencyOther.value &&
          emergencyCustomRelationshipCtrl.text.trim().isEmpty) {
        showToast(
          context,
          "Error",
          "Please enter emergency relationship",
          type: ToastificationType.error,
        );
        return;
      }
      if (selectedCity.value == null ||
          (selectedCity.value?.id ?? '').isEmpty) {
        showToast(
          context,
          "Error",
          "Please select city",
          type: ToastificationType.error,
        );
        return;
      }

      isStudentUpdating.value = true;
      final parentRelationshipValue = isParentOther.value
          ? (parentCustomRelationshipCtrl.text.trim().isNotEmpty
              ? parentCustomRelationshipCtrl.text.trim()
              : "OTHER")
          : parentRelationship.value;
      final emergencyRelationshipValue =
          isEmergencyOther.value ? "OTHER" : emergencyRelationship.value;
      final emergencyCustomValue = isEmergencyOther.value
          ? emergencyCustomRelationshipCtrl.text.trim()
          : "";

      print('Emergency Relationship: ${emergencyRelationship.value}');
      final request = UpdateStudentDetailsRequest(
        lang: "EN",
        firstName: studentFirstNameCtrl.text.trim(),
        lastName: studentLastNameCtrl.text.trim(),
        profileLink: studentUploadedImageUrl.value.isNotEmpty
            ? studentUploadedImageUrl.value
            : studentInfoDetails.value?.profileLink ?? "",
        address: studentAddressCtrl.text.trim(),
        gender: selectedGender.value.isNotEmpty ? selectedGender.value : null,
        dateOfBirth: studentDob.value.isNotEmpty ? studentDob.value : null,
        countryId: selectedCountry.value?.id,
        stateId: selectedState.value?.id,
        cityId: selectedCity.value?.id,
        zipCode: studentZipCtrl.text.trim(),
        classId: selectedClass.value?.id,
        currency: studentCurrencyCtrl.text.trim().isNotEmpty
            ? studentCurrencyCtrl.text.trim()
            : null,
        feeAmount: num.tryParse(studentFeeAmountCtrl.text.trim()),
        packageDuration: selectedPackageDuration.value.isNotEmpty
            ? selectedPackageDuration.value
            : null,
        hasAllergies: hasAllergies.value,
        takesMedications: takesMedications.value,
        hasMedicalCondition: hasMedicalCondition.value,
        pickup: pickup.value,
        medicalDecision: medicalDecision.value,
        parent: ParentRequest(
          relationship: parentRelationshipValue.isNotEmpty
              ? parentRelationshipValue
              : null,
          firstName: parentFirstNameCtrl.text.trim(),
          lastName: parentLastNameCtrl.text.trim(),
          profileLink:
              studentInfoDetails.value?.parentProfile?.profileLink ?? "",
          address: parentAddressCtrl.text.trim(),
          phoneNumber: parentPhoneNumber,
          countryCode: parentCountryCodeCtrl.text.trim(),
          education: parentEducationCtrl.text.trim(),
          occupation: parentOccupationCtrl.text.trim(),
        ),
        emergency: EmergencyRequest(
          firstName: emergencyFirstNameCtrl.text.trim(),
          lastName: emergencyLastNameCtrl.text.trim(),
          emailAddress: emergencyEmailCtrl.text.trim(),
          phoneNumber: emergencyPhoneNumber,
          countryCode: emergencyCountryCodeCtrl.text.trim(),
          secondaryPhoneNumber: emergencySecondaryNumber,
          secondaryCountryCode: emergencySecondaryCodeCtrl.text.trim(),
          relationship: emergencyRelationshipValue.isNotEmpty
              ? emergencyRelationshipValue.toUpperCase()
              : null,
          customRelationship: emergencyCustomValue,
          education: emergencyEducationCtrl.text.trim(),
          occupation: emergencyOccupationCtrl.text.trim(),
        ),
      );
      print(request.toJson());
      final response =
          await apiWorker.updateStudentDetails(request, context, slug);

      if (response?.success == true) {
        showToast(context, "Success",
            response?.message ?? "Student updated successfully",
            type: ToastificationType.success);

        // Refresh student data
        await fetchStudentsBySlug(context, slug);
        Get.back();
      } else {
        showToast(context, "Error", response?.message ?? "Update failed",
            type: ToastificationType.error);
      }
    } catch (e) {
      showToast(context, "Error", e.toString(), type: ToastificationType.error);
    } finally {
      isStudentUpdating.value = false;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // IMAGE UPLOAD
  // ══════════════════════════════════════════════════════════════════════════
  Future<void> pickAndUploadStudentImage(BuildContext context) async {
    try {
      final XFile? file =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file == null) return;

      isStudentImageUploading.value = true;

      final response = await apiWorker.uploadFileApi(
        UploadImagesRequest(
            images: [File(file.path)], lang: LanguageController.to.apiLanguage),
        context,
      );

      if (response?.success == true &&
          response?.data?.images?.isNotEmpty == true) {
        studentUploadedImageUrl.value =
            response!.data!.images!.first.imageUrl ?? "";
        showToast(context, "Success", "Image uploaded",
            type: ToastificationType.success);
      }
    } catch (e) {
      showToast(context, "Error", e.toString(), type: ToastificationType.error);
    } finally {
      isStudentImageUploading.value = false;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // DISPOSE
  // ══════════════════════════════════════════════════════════════════════════
  @override
  void onClose() {
    evaluationFormsSearchController.dispose();
    studentFirstNameCtrl.clear();
    studentLastNameCtrl.clear();
    studentAddressCtrl.clear();
    studentZipCtrl.clear();
    studentCurrencyCtrl.clear();
    studentFeeAmountCtrl.clear();
    parentFirstNameCtrl.clear();
    parentLastNameCtrl.clear();
    parentPhoneCtrl.clear();
    parentCountryCodeCtrl.clear();
    parentAddressCtrl.clear();
    parentEducationCtrl.clear();
    parentOccupationCtrl.clear();
    emergencyFirstNameCtrl.clear();
    emergencyLastNameCtrl.clear();
    emergencyEmailCtrl.clear();
    emergencyPhoneCtrl.clear();
    emergencyCountryCodeCtrl.clear();
    emergencySecondaryPhoneCtrl.clear();
    emergencySecondaryCodeCtrl.clear();
    emergencyEducationCtrl.clear();
    emergencyOccupationCtrl.clear();
    parentCustomRelationshipCtrl.clear();
    emergencyCustomRelationshipCtrl.clear();
    super.onClose();
  }

  //══════════════════════════════════════════════════════════
// FEES
//══════════════════════════════════════════════════════════
  RxBool isFeesLoading = false.obs;
  RxList<Fee> feesList = <Fee>[].obs;

  Future<void> fetchFeesDetails(BuildContext context) async {
    try {
      isFeesLoading.value = true;
      if (studentId == null) {
        feesList.clear();
        debugPrint("studentId is null, skipping fees fetch");
        return;
      }
      final response = await apiWorker.feesDetails(
        FeesDetailsRequest(lang: LanguageController.to.apiLanguage),
        context,
        studentId ?? '',
      );

      if (response?.success == true) {
        feesList.assignAll(response?.data?.fees ?? []);
      } else {
        feesList.clear();
      }
    } catch (e) {
      debugPrint("Fees Error: $e");
    } finally {
      isFeesLoading.value = false;
    }
  }

  //══════════════════════════════════════════════════════════
// GALLERY
//══════════════════════════════════════════════════════════
  RxBool isGalleryLoading = false.obs;
  RxList<String> galleryList = <String>[].obs;
  RxList<GallerySection> gallerySections = <GallerySection>[].obs;

  Future<void> fetchGallery(BuildContext context) async {
    try {
      isGalleryLoading.value = true;

      final response = await apiWorker.galleryDetails(
          FeesDetailsRequest(lang: LanguageController.to.apiLanguage),
          context,
          studentId ?? '');

      if (response?.success == true) {
        final sections = _buildGallerySections(response?.data?.post ?? []);
        gallerySections.assignAll(sections);
        galleryList.assignAll(
          sections.expand((section) => section.items).map((item) => item.url),
        );
      } else {
        galleryList.clear();
        gallerySections.clear();
      }
    } catch (e) {
      debugPrint("Gallery Error: $e");
    } finally {
      isGalleryLoading.value = false;
    }
  }

  List<GallerySection> _buildGallerySections(List<Post> groupedPosts) {
    final sections = <GallerySection>[];

    for (final groupedPost in groupedPosts) {
      final items = <GalleryMediaItem>[];

      for (final post in groupedPost.posts ?? <Posts>[]) {
        for (final mediaUrl in post.media ?? <String>[]) {
          final trimmedUrl = mediaUrl.trim();
          if (trimmedUrl.isEmpty) continue;

          items.add(
            GalleryMediaItem(
              url: trimmedUrl,
              date: post.date ?? groupedPost.date ?? '',
              type: _getMediaType(trimmedUrl), // 👈 ADD THIS
            ),
          );
        }
      }

      if (items.isEmpty) continue;

      final rawDate = (groupedPost.date ?? items.first.date).trim();
      sections.add(
        GallerySection(
          rawDate: rawDate,
          displayDate: _formatGalleryDate(rawDate),
          items: items,
        ),
      );
    }

    return sections;
  }

  String _formatGalleryDate(String rawDate) {
    if (rawDate.isEmpty) return '';

    try {
      final parsedDate = DateTime.parse(rawDate);
      return DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (_) {
      try {
        final parts = rawDate.split('-');
        if (parts.length == 3) {
          final parsedDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
          return DateFormat('dd MMM yyyy').format(parsedDate);
        }
      } catch (_) {}
    }

    return rawDate;
  }

  String _getMediaType(String url) {
    final lower = url.toLowerCase();

    if (lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.webp')) {
      return "image";
    } else if (lower.endsWith('.mp4') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.avi')) {
      return "video";
    } else {
      return "document";
    }
  }
}

class GallerySection {
  final String rawDate;
  final String displayDate;
  final List<GalleryMediaItem> items;

  const GallerySection({
    required this.rawDate,
    required this.displayDate,
    required this.items,
  });
}

class GalleryMediaItem {
  final String url;
  final String date;
  final String type; // 👈 NEW

  const GalleryMediaItem({
    required this.url,
    required this.date,
    required this.type,
  });
}
