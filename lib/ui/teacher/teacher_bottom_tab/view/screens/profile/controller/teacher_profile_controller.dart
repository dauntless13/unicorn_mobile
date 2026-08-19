import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';
import 'package:unicorn/service/session/session_helper.dart';

import '../../../../../../../service/api_service/api_worker.dart';
import '../../../../../../../translation/language_controller.dart';
import '../../../../../../../widget/common_toastification.dart';
import '../../home/view/add_post/mode/upload_images/upload_images_request.dart';
import '../model/city/city_request.dart';
import '../model/city/city_response.dart';
import '../model/country/country_request.dart';
import '../model/country/country_response.dart';
import '../model/get_all_class/get_all_class_request.dart';
import '../model/get_all_class/get_all_class_response.dart';
import '../model/state/state_request.dart';
import '../model/state/state_response.dart';
import '../model/teacher_profile_response.dart';
import '../model/update_teacher_profile/update_teacher_profile_request.dart';

class TeacherProfileController extends GetxController {
  final ApiWorker apiWorker = Get.put(ApiWorker());

  Rxn<TeacherProfileData> teacher = Rxn<TeacherProfileData>();
  RxBool isLoading = false.obs;
  RxBool isUpdating = false.obs;

  // ================= CONTROLLERS =================
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final educationCtrl = TextEditingController();
  final subjectCtrl = TextEditingController();
  final experienceCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final countryCodeCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final zipCtrl = TextEditingController();

  // ================= GET PROFILE =================
  Future<void> teacherGetBySlug(BuildContext context) async {
    try {
      isLoading.value = true;

      final loginResponse = await SessionHelper().getLoginResponse();
      final String? slug = loginResponse?.data?.user?.slug;

      if (slug == null || slug.isEmpty) {
        throw Exception("Slug not found");
      }

      final response =
      await apiWorker.teacherGetBySlug(slug, context);

      if (response?.success == true) {
        teacher.value = response?.data;
        countryCodeCtrl.text = "";
        // 🔥 VERY IMPORTANT → Fill Controllers AFTER API
        _fillControllers(response!.data!);
      } else {
        showToast(
          context,
          "Error",
          response?.message ?? "Something went wrong",
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      showToast(
        context,
        "Error",
        e.toString(),
        type: ToastificationType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ================= FILL FORM =================
  void _fillControllers(TeacherProfileData data) {
    firstNameCtrl.text = data.firstName ?? "";
    lastNameCtrl.text = data.lastName ?? "";
    educationCtrl.text = data.education ?? "";
    subjectCtrl.text = data.subject ?? "";
    experienceCtrl.text = data.experience?.toString() ?? "";
    countryCodeCtrl.text = data.countryCode ?? "";
    phoneCtrl.text = data.phoneNumber ?? "";
    addressCtrl.text = data.address ?? "";
    zipCtrl.text = data.zipCode ?? "";
  }

  // ================= UPDATE PROFILE =================
  Future<void> updateProfile(BuildContext context ,String slug) async {
    try {
      if (teacher.value == null) {
        throw Exception("Teacher data not loaded");
      }

      // ✅ BASIC VALIDATION
      if (firstNameCtrl.text.trim().isEmpty ||
          lastNameCtrl.text.trim().isEmpty) {
        showToast(
          context,
          "Error",
          "First name & Last name are required",
          type: ToastificationType.error,
        );
        return;
      }

      final rawPhone = phoneCtrl.text.trim();
      final phoneNumber = rawPhone.replaceAll(RegExp(r'\D'), '');
      if (phoneNumber.isEmpty) {
        showToast(
          context,
          "Error",
          "Phone number is required",
          type: ToastificationType.error,
        );
        return;
      }

      if (phoneNumber.length < 7 || phoneNumber.length > 12) {
        showToast(
          context,
          "Error",
          "Invalid phone number",
          type: ToastificationType.error,
        );
        return;
      }

      if (addressCtrl.text.trim().isEmpty) {
        showToast(
          context,
          "Error",
          "Address is required",
          type: ToastificationType.error,
        );
        return;
      }

      if (zipCtrl.text.trim().isEmpty) {
        showToast(
          context,
          "Error",
          "Zip code is required",
          type: ToastificationType.error,
        );
        return;
      }

      if (educationCtrl.text.trim().isEmpty) {
        showToast(
          context,
          "Error",
          "Education is required",
          type: ToastificationType.error,
        );
        return;
      }

      if (subjectCtrl.text.trim().isEmpty) {
        showToast(
          context,
          "Error",
          "Subject is required",
          type: ToastificationType.error,
        );
        return;
      }

      if (experienceCtrl.text.trim().isEmpty) {
        showToast(
          context,
          "Error",
          "Experience is required",
          type: ToastificationType.error,
        );
        return;
      }

      if (selectedCountry.value == null ||
          selectedState.value == null ||
          selectedCity.value == null) {
        showToast(
          context,
          "Error",
          "Country, State and City are required",
          type: ToastificationType.error,
        );
        return;
      }

      if (selectedClasses.isEmpty) {
        showToast(
          context,
          "Error",
          "At least one class is required",
          type: ToastificationType.error,
        );
        return;
      }

      isUpdating.value = true;

      final loginResponse = await SessionHelper().getLoginResponse();
      final slug = loginResponse?.data?.user?.slug;

      if (slug == null || slug.isEmpty) {
        throw Exception("Slug not found");
      }


      final request = UpdateTeacherProfileRequest(
        firstName: firstNameCtrl.text.trim(),
        lastName: lastNameCtrl.text.trim(),
        education: educationCtrl.text.trim(),
        subject: subjectCtrl.text.trim(),
        experience: int.tryParse(experienceCtrl.text.trim()) ?? 0,
        countryCode: countryCodeCtrl.text.trim().isNotEmpty
            ? countryCodeCtrl.text.trim()
            : (teacher.value?.countryCode ?? ""),
        phoneNumber: phoneNumber,
        address: addressCtrl.text.trim(),
        countryId: selectedCountry.value?.id ?? "",
        stateId: selectedState.value?.id ?? "",
        cityId: selectedCity.value?.id ?? "",
        zipCode: zipCtrl.text.trim(),
        profileLink: uploadedImageUrl.value.isNotEmpty
            ? uploadedImageUrl.value
            : teacher.value?.profileLink ?? "",
        classIds: selectedClasses
            .map((e) => e.id!)
            .toList(),
        lang: Get.locale?.languageCode.toUpperCase() ?? LanguageController.to.apiLanguage,
      );

      final response =
      await apiWorker.updateTeacherProfile(request, context, slug);

      if (response?.success == true) {
        showToast(
          context,
          "Success",
          response?.message ?? "Profile Updated Successfully",
          type: ToastificationType.success,
        );

        // 🔥 Refresh Updated Profile
        await teacherGetBySlug(context);

        Get.back();
      } else {
        showToast(
          context,
          "Error",
          response?.message ?? "Update Failed",
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      showToast(
        context,
        "Error",
        e.toString(),
        type: ToastificationType.error,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  @override
  void onClose() {
    firstNameCtrl.clear();
    lastNameCtrl.clear();
    educationCtrl.clear();
    subjectCtrl.clear();
    experienceCtrl.clear();
    phoneCtrl.clear();
    countryCodeCtrl.clear();
    addressCtrl.clear();
    zipCtrl.clear();
    super.onClose();
  }
  // ================= LISTS =================
  RxList<CountryData> countryList = <CountryData>[].obs;
  RxList<StateData> stateList = <StateData>[].obs;
  RxList<City> cityList = <City>[].obs;
  RxList<Class> classList = <Class>[].obs;

  // ================= SELECTED =================
  Rxn<CountryData> selectedCountry = Rxn<CountryData>();
  Rxn<StateData> selectedState = Rxn<StateData>();
  Rxn<City> selectedCity = Rxn<City>();
  RxList<Class> selectedClasses = <Class>[].obs;

  // ================= LOADING =================
  RxBool isCountryLoading = false.obs;
  RxBool isStateLoading = false.obs;
  RxBool isCityLoading = false.obs;
  RxBool isClassLoading = false.obs;

  // ================= COUNTRY =================
  Future<void> fetchCountries(BuildContext context) async {
    try {
      isCountryLoading.value = true;

      final response = await apiWorker.countryListing(
        countryRequest(page: 1, limit: 100),
        context,
      );

      if (response?.success == true) {
        countryList.assignAll(response?.data?.countries ?? []);
      }
    } finally {
      isCountryLoading.value = false;
    }
  }

  // ================= STATE =================
  Future<void> fetchStates(BuildContext context, String countryId) async {
    try {
      isStateLoading.value = true;

      selectedState.value = null;
      selectedCity.value = null;
      stateList.clear();
      cityList.clear();

      final response = await apiWorker.stateListing(
        StateRequest(page: 1, limit: 100, countryId: countryId),
        context,
      );

      if (response?.success == true) {
        stateList.assignAll(response?.data?.states ?? []);
      }
    } finally {
      isStateLoading.value = false;
    }
  }

  // ================= CITY =================
  Future<void> fetchCities(BuildContext context, String stateId) async {
    try {
      isCityLoading.value = true;

      selectedCity.value = null;
      cityList.clear();

      final response = await apiWorker.cityListing(
        CityRequest(page: 1, limit: 100, stateId: stateId),
        context,
      );

      if (response?.success == true) {
        cityList.assignAll(response?.data?.cities ?? []);
      }
    } finally {
      isCityLoading.value = false;
    }
  }

  // ================= CLASS =================
  Future<void> fetchClasses(BuildContext context) async {
    try {
      isClassLoading.value = true;

      final response = await apiWorker.getAllClassApi(
        GetAllClassRequest(page: 1, limit: 100, lang: LanguageController.to.apiLanguage),
        context,
      );

      if (response?.success == true) {
        classList.assignAll(response?.data?.classes ?? []);
      }
    } finally {
      isClassLoading.value = false;
    }
  }

  // ================= MULTI SELECT =================
  void toggleClassSelection(Class item) {
    if (selectedClasses.contains(item)) {
      selectedClasses.remove(item);
    } else {
      selectedClasses.add(item);
    }
  }
  RxString uploadedImageUrl = "".obs;
  RxBool isImageUploading = false.obs;
  Future<void> pickAndUploadImage(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? file =
      await picker.pickImage(source: ImageSource.gallery);

      if (file == null) return;

      isImageUploading.value = true;

      final request = UploadImagesRequest(
        images: [File(file.path)],
        lang: LanguageController.to.apiLanguage,
      );

      final response =
      await apiWorker.uploadFileApi(request, context);

      if (response?.success == true &&
          response?.data?.images?.isNotEmpty == true) {

        uploadedImageUrl.value =
            response!.data!.images!.first.imageUrl ?? "";

        showToast(
          context,
          "Success",
          "Image Uploaded",
          type: ToastificationType.success,
        );
      }
    } catch (e) {
      showToast(
        context,
        "Error",
        e.toString(),
        type: ToastificationType.error,
      );
    } finally {
      isImageUploading.value = false;
    }
  }
  Future<void> initEditScreen(BuildContext context) async {
    if (teacher.value == null) return;

    await fetchCountries(context);

    // 1️⃣ Select Country
    final country = countryList.firstWhereOrNull(
          (c) => c.name == teacher.value?.country,
    );

    if (country != null) {
      selectedCountry.value = country;
      await fetchStates(context, country.id!);

      // 2️⃣ Select State
      final state = stateList.firstWhereOrNull(
            (s) => s.name == teacher.value?.state,
      );

      if (state != null) {
        selectedState.value = state;
        await fetchCities(context, state.id ?? '');

        // 3️⃣ Select City
        final city = cityList.firstWhereOrNull(
              (c) => c.name == teacher.value?.city,
        );

        if (city != null) {
          selectedCity.value = city;
        }
      }
    }

    // 4️⃣ Fetch Classes
    await fetchClasses(context);

    if (teacher.value?.classes != null) {
      selectedClasses.assignAll(
        classList.where(
              (c) => teacher.value!.classes!.contains(c.name),
        ),
      );
    }
  }
}

