import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:unicorn/ui/parent/main_tab_bar/view/screeen/profile/view/controller/parent_profile_controller.dart';

class EditParentProfileScreen extends StatefulWidget {
  const EditParentProfileScreen({super.key});

  @override
  State<EditParentProfileScreen> createState() =>
      _EditParentProfileScreenState();
}

class _EditParentProfileScreenState extends State<EditParentProfileScreen>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(ParentProfileController());

  static const _teal = Color(0xFF0D6E82);

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  @override
  void initState() {
    super.initState();

    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);

    _animCtrl.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.parentGetBySlug(context);
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    return Scaffold(
      backgroundColor:
          light ? const Color(0xFFF4F6F8) : const Color(0xFF121212),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context, light),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _profileImageSection(context, light),
                  const SizedBox(height: 24),

                  /// PERSONAL INFO
                  _sectionLabel("Personal Info".tr, light),
                  const SizedBox(height: 10),
                  _card(light, [
                    _field(controller.firstNameCtrl, "First Name".tr,
                        Icons.person_outline,
                        light: light),
                    _divider(light),
                    _field(controller.lastNameCtrl, "Last Name".tr,
                        Icons.person_outline,
                        light: light),
                    _divider(light),
                    _countryCodePicker(light),
                    _divider(light),
                    _field(controller.addressCtrl, "Address".tr,
                        Icons.location_on_outlined,
                        light: light),
                  ]),

                  const SizedBox(height: 20),

                  /// ADDITIONAL INFO
                  _sectionLabel("Additional Info".tr, light),
                  const SizedBox(height: 10),
                  _card(light, [
                    _dropdownRelationship(light),
                    _divider(light),
                    _field(controller.educationCtrl, "Education".tr,
                        Icons.school_outlined,
                        light: light),
                    _divider(light),
                    _field(controller.occupationCtrl, "Occupation".tr,
                        Icons.work_outline,
                        light: light),
                    _divider(light),
                    // _dropdownLanguage(),
                  ]),

                  const SizedBox(height: 30),
                  Obx(() => _saveButton(context)),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  // ───────────────── APP BAR ─────────────────

  Widget _buildAppBar(BuildContext context, bool light) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: light ? Colors.white : const Color(0xFF1E1E1E),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded,
            size: 18, color: light ? Colors.black87 : Colors.white),
        onPressed: () => Get.back(),
      ),
      title: Text(
        "Edit Parent".tr,
        style: TextStyle(
          color: light ? Colors.black87 : Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ───────────────── PROFILE IMAGE ─────────────────

  Widget _profileImageSection(BuildContext context, bool light) {
    return Center(
      child: Obx(() {
        // Current user profile image should be shown here.
        final imageUrl = controller.uploadedImageUrl.value.isNotEmpty
            ? controller.uploadedImageUrl.value
            : controller.parent.value?.profileLink;

        return Stack(
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor:
                  light ? Colors.grey.shade200 : Colors.grey.shade800,
              backgroundImage: imageUrl != null && imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : null,
              child: imageUrl == null || imageUrl.isEmpty
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: controller.isImageUploading.value
                    ? null
                    : () => controller.pickAndUploadImage(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: controller.isImageUploading.value
                        ? _teal.withOpacity(0.45)
                        : _teal,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    controller.isImageUploading.value
                        ? Icons.hourglass_top_rounded
                        : Icons.camera_alt,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }

  // ───────────────── COMMON UI ─────────────────

  Widget _sectionLabel(String label, bool light) {
    return Text(
      label,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: light ? Colors.black54 : Colors.white54,
      ),
    );
  }

  Widget _card(bool light, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: light ? Colors.white : const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(children: children),
      ),
    );
  }

  Widget _divider(bool light) => Divider(
        height: 1,
        indent: 52,
        color: light ? Colors.grey.shade200 : Colors.white12,
      );

  Widget _field(TextEditingController ctrl, String label, IconData icon,
      {TextInputType keyboard = TextInputType.text, required bool light}) {
    final labelColor = light ? Colors.grey.shade600 : Colors.grey.shade400;
    final textColor = light ? Colors.black87 : Colors.white;
    return TextField(
      controller: ctrl,
      keyboardType: keyboard,
      style: TextStyle(color: textColor),
      inputFormatters: [
        LengthLimitingTextInputFormatter(20), // ✅ HARD LIMIT
      ],
      decoration: InputDecoration(
        filled: true,
        fillColor: light ? Colors.white : const Color(0xFF1E1E1E),
        labelText: label,
        labelStyle: TextStyle(color: labelColor),
        prefixIcon: Icon(icon, size: 20, color: labelColor),
        border: InputBorder.none,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _countryCodePicker(bool light) {
    final subColor = light ? Colors.grey.shade600 : Colors.grey.shade400;
    final textColor = light ? Colors.black87 : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 50,
              child: GestureDetector(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode: true,
                    countryListTheme: CountryListThemeData(
                      backgroundColor:
                          light ? Colors.white : const Color(0xFF1E1E1E),
                      textStyle: TextStyle(
                        color: light ? Colors.black87 : Colors.white,
                        fontSize: 14,
                      ),
                      searchTextStyle: TextStyle(
                        color: light ? Colors.black87 : Colors.white,
                        fontSize: 14,
                      ),
                      inputDecoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: light
                              ? Colors.grey.shade500
                              : Colors.grey.shade400,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: light
                              ? Colors.grey.shade600
                              : Colors.grey.shade400,
                        ),
                        filled: true,
                        fillColor: light
                            ? Colors.grey.shade100
                            : const Color(0xFF2A2A2A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    onSelect: (Country country) {
                      setState(() {
                        controller.countryCodeCtrl.text =
                            '+${country.phoneCode}';
                        controller.selectedCountryIso.value =
                            country.countryCode;
                      });
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: light ? Colors.white : const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: light ? Colors.grey.shade200 : Colors.white10,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.flag_outlined, size: 20, color: subColor),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //   Text(
                            //     'Code'.tr,
                            //     style: TextStyle(
                            //       fontSize: 12.5,
                            //       color: subColor,
                            //   ),
                            // ),
                            // const SizedBox(height: 2),
                            Text(
                              controller.countryCodeCtrl.text.isNotEmpty
                                  ? controller.countryCodeCtrl.text
                                  : 'Select'.tr,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.5,
                                color:
                                    controller.countryCodeCtrl.text.isNotEmpty
                                        ? textColor
                                        : Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey.shade400),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 50,
              child: TextField(
                controller: controller.phoneCtrl,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: textColor),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(20),
                ],
                decoration: InputDecoration(
                  filled: true,
                  fillColor: light ? Colors.white : const Color(0xFF1E1E1E),
                  labelText: "Phone Number".tr,
                  labelStyle: TextStyle(color: subColor),
                  prefixIcon:
                      Icon(Icons.phone_outlined, size: 20, color: subColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: light ? Colors.grey.shade200 : Colors.white10,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: light ? Colors.grey.shade200 : Colors.white10,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: _teal),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────── RELATIONSHIP ─────────────────

  Widget _dropdownRelationship(bool light) {
    final subColor = light ? Colors.grey.shade600 : Colors.grey.shade400;
    final textColor = light ? Colors.black87 : Colors.white;
    final relationshipLabels = {
      'FATHER': 'Father'.tr,
      'MOTHER': 'Mother'.tr,
      'GUARDIAN': 'Guardian'.tr,
    };
    return Obx(() => ListTile(
          leading: Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Icon(Icons.family_restroom_outlined, color: subColor),
          ),
          title: Text(
            "Relationship".tr,
            style: TextStyle(color: textColor),
          ),
          subtitle: Text(
            controller.selectedRelationship.value.isEmpty
                ? "Select".tr
                : (relationshipLabels[
                        controller.selectedRelationship.value.toUpperCase()] ??
                    controller.selectedRelationship.value),
            style: TextStyle(color: subColor),
          ),
          trailing: Icon(Icons.keyboard_arrow_down, color: subColor),
          onTap: () => controller.selectRelationship(context),
        ));
  }

  Widget _saveButton(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.isUpdating.value
            ? null
            : () => controller.updateParent(
                  context,
                ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (controller.isUpdating.value)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              )
            else
              const Icon(
                Icons.check_rounded,
                size: 20,
                color: Colors.white,
              ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                controller.isUpdating.value ? 'Processing'.tr : 'save'.tr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
