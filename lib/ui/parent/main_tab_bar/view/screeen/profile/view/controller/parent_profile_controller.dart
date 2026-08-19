import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';

import '../../../../../../../../service/api_service/api_worker.dart';
import '../../../../../../../../service/session/session_helper.dart';
import '../../../../../../../../translation/language_controller.dart';
import '../../../../../../../../widget/common_toastification.dart';
import '../../../../../../../teacher/teacher_bottom_tab/view/screens/home/view/add_post/mode/upload_images/upload_images_request.dart';
import '../../../../../../../teacher/teacher_bottom_tab/view/screens/profile/model/update_parent_profile/update_parent_profile_request.dart';
import '../model/parent_data_by_slug/parent_data_by_slug_response.dart';

class ParentProfileController extends GetxController {
  final ApiWorker apiWorker = Get.put(ApiWorker());

  // ================= STATE =================
  RxBool isLoading = false.obs;
  RxBool isUpdating = false.obs;
  RxBool isImageUploading = false.obs;

  Rxn<ParentData> parent = Rxn<ParentData>();
  RxString uploadedImageUrl = "".obs;

  // ================= TEXT CONTROLLERS =================
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final countryCodeCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final educationCtrl = TextEditingController();
  final occupationCtrl = TextEditingController();
  final zipCtrl = TextEditingController();
  RxString selectedCountryIso = "".obs;

  // ================= DROPDOWN VALUES =================
  RxString selectedRelationship = "".obs; // FATHER/MOTHER/GUARDIAN
  RxString selectedLang = "EN".obs;

  // =========================================================
  // ✅ GET PARENT PROFILE
  // =========================================================

  Future<void> parentGetBySlug(BuildContext context) async {
    try {
      isLoading.value = true;

      final loginResponse = await SessionHelper().getLoginResponse();
      final String? slug = loginResponse?.data?.user?.slug;

      if (slug == null || slug.isEmpty) {
        throw Exception("Slug not found");
      }

      final response = await apiWorker.parentBySlug(slug, context);

      if (response?.success == true) {
        parent.value = response?.data;

        // 🔥 Fill Controllers
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

  // =========================================================
  // ✅ FILL CONTROLLERS
  // =========================================================

  void _fillControllers(ParentData data) {
    firstNameCtrl.text = data.firstName ?? "";
    lastNameCtrl.text = data.lastName ?? "";
    countryCodeCtrl.text = data.countryCode ?? "";
    phoneCtrl.text = data.phoneNumber ?? "";
    addressCtrl.text = data.address ?? "";
    zipCtrl.text = data.zipcode ?? "";
    selectedRelationship.value = ""; // If API gives relationship, set here
    selectedLang.value = Get.locale?.languageCode.toUpperCase() ?? "EN";
    educationCtrl.text = data.education ?? "";
    occupationCtrl.text = data.occupation ?? "";

    // Important: set the observable for dropdown
    selectedRelationship.value =
        (data.relationship?.isNotEmpty == true) ? data.relationship! : "";

    final rawCode = countryCodeCtrl.text.trim();
    final codeDigits = rawCode.replaceAll(RegExp(r'[^0-9]'), '');
    final parsed = CountryParser.tryParsePhoneCode(codeDigits);
    selectedCountryIso.value = parsed?.countryCode ?? "";
  }

  // =========================================================
  // ✅ UPDATE PROFILE
  // =========================================================

  Future<void> updateParent(
    BuildContext context,
  ) async {
    try {
      final loginResponse = await SessionHelper().getLoginResponse();
      final String? slug = loginResponse?.data?.user?.slug;
      if (parent.value == null) {
        throw Exception("Parent data not loaded");
      }

      if (firstNameCtrl.text.trim().isEmpty ||
          lastNameCtrl.text.trim().isEmpty) {
        showToast(
          context,
          "Error",
          "First Name & Last Name are required",
          type: ToastificationType.error,
        );
        return;
      }

      final rawPhone = phoneCtrl.text.trim();
      String phoneNumber = rawPhone.replaceAll(RegExp(r'\D'), '');
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

      if (occupationCtrl.text.trim().isEmpty) {
        showToast(
          context,
          "Error",
          "Occupation is required",
          type: ToastificationType.error,
        );
        return;
      }

      if (selectedRelationship.value.trim().isEmpty) {
        showToast(
          context,
          "Error",
          "Relationship is required",
          type: ToastificationType.error,
        );
        return;
      }

      isUpdating.value = true;

      final request = UpdateParentProfileRequest(
        firstName: firstNameCtrl.text.trim(),
        lastName: lastNameCtrl.text.trim(),
        address: addressCtrl.text.trim(),
        countryCode: countryCodeCtrl.text.trim().isNotEmpty
            ? countryCodeCtrl.text.trim()
            : (parent.value?.countryCode ?? ""),
        phoneNumber: phoneNumber,
        profileLink: uploadedImageUrl.value.isNotEmpty
            ? uploadedImageUrl.value
            : parent.value?.profileLink ?? "",
        relationship: selectedRelationship.value,
        education: educationCtrl.text.trim(),
        occupation: occupationCtrl.text.trim(),
        lang: LanguageController.to.apiLanguage,
      );

      final response =
          await apiWorker.updateParentProfile(request, context, slug ?? "");

      if (response?.success == true) {
        showToast(
          context,
          "Success",
          response?.message ?? "Profile Updated Successfully",
          type: ToastificationType.success,
        );

        await parentGetBySlug(context);
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

  // =========================================================
  // ✅ IMAGE UPLOAD
  // =========================================================

  Future<void> pickAndUploadImage(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? file = await picker.pickImage(source: ImageSource.gallery);

      if (file == null) return;

      isImageUploading.value = true;

      final request = UploadImagesRequest(
        images: [File(file.path)],
        lang: LanguageController.to.apiLanguage,
      );

      final response = await apiWorker.uploadFileApi(request, context);

      if (response?.success == true &&
          response?.data?.images?.isNotEmpty == true) {
        uploadedImageUrl.value = response!.data!.images!.first.imageUrl ?? "";

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

  // =========================================================
  // ✅ RELATIONSHIP SELECTOR
  // =========================================================

  void selectRelationship(BuildContext context) {
    bool isLight(BuildContext context) =>
        Theme.of(context).brightness == Brightness.light;

    final light = isLight(context);

    final relationships = {
      "Father".tr: "FATHER",
      "Mother".tr: "MOTHER",
      "Guardian".tr: "GUARDIAN",
    };

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: light ? Colors.white : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: relationships.entries
              .map(
                (e) => ListTile(
                  title: Text(e.key), // 👈 shows "Father"
                  onTap: () {
                    selectedRelationship.value = e.value; // 👈 stores "FATHER"
                    Get.back();
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  // =========================================================
  // ✅ LANGUAGE SELECTOR
  // =========================================================

  void selectLanguage(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;
    final textColor = light ? Colors.black87 : Colors.white;
    final borderColor = light ? Colors.grey.shade300 : Colors.grey.shade700;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: light ? Colors.white : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ["EN", "AR"]
              .map(
                (e) => ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: borderColor),
                  ),
                  title: Text(
                    e,
                    style: TextStyle(color: textColor),
                  ),
                  onTap: () {
                    selectedLang.value = e;
                    Get.back();
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  void onClose() {
    firstNameCtrl.clear();
    lastNameCtrl.clear();
    phoneCtrl.clear();
    countryCodeCtrl.clear();
    addressCtrl.clear();
    educationCtrl.clear();
    occupationCtrl.clear();
    zipCtrl.clear();
    super.onClose();
  }
}
