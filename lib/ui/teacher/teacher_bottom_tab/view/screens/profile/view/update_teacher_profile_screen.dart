import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller/teacher_profile_controller.dart';
import '../model/city/city_response.dart';
import '../model/country/country_response.dart';
import '../model/state/state_response.dart';
import 'common_selection_bottomsheet.dart';

class EditTeacherProfileScreen extends StatefulWidget {
  final String slug;
  const EditTeacherProfileScreen({super.key, required this.slug});

  @override
  State<EditTeacherProfileScreen> createState() =>
      _EditTeacherProfileScreenState();
}

class _EditTeacherProfileScreenState extends State<EditTeacherProfileScreen>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(TeacherProfileController());

  static const _teal = Color(0xFF0D6E82);
  static const _tealLight = Color(0xFFE8F3F6);

  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.teacherGetBySlug(context);
      await controller.initEditScreen(context);
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  Color backgroundColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF5F5F5)
          : const Color(0xFF0F0F0F);

  Color cardColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : const Color(0xFF1A1A1A);

  Color borderColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? Colors.grey.shade300
          : Colors.grey.shade700;

  Color primaryText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? Colors.black87
          : Colors.white;

  Color secondaryText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? Colors.grey.shade600
          : Colors.grey.shade400;
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
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _profileImageSection(context, light),
                  const SizedBox(height: 24),
                  _sectionLabel('Personal Info'.tr, light),
                  const SizedBox(height: 10),
                  _card(context, light, [
                    _field(context, controller.firstNameCtrl, 'first_name'.tr,
                        icon: Icons.person_outline),
                    _divider(light),
                    _field(context, controller.lastNameCtrl, 'last_name'.tr,
                        icon: Icons.person_outline),
                    _divider(light),
                    _countryCodePicker(light),
                    _divider(light),
                    _field(context, controller.addressCtrl, 'address'.tr,
                        icon: Icons.location_on_outlined, maxLength: 100),
                    _divider(light),
                    _field(context, controller.zipCtrl, 'zip_code'.tr,
                        icon: Icons.pin_drop_outlined,
                        keyboard: TextInputType.number,
                        maxLength: 8),
                  ]),
                  const SizedBox(height: 20),
                  _sectionLabel('Academic Info'.tr, light),
                  const SizedBox(height: 10),
                  _card(context, light, [
                    _field(context, controller.educationCtrl, 'education'.tr,
                        icon: Icons.school_outlined, maxLength: 50),
                    _divider(light),
                    _field(context, controller.subjectCtrl, 'subject'.tr,
                        icon: Icons.book_outlined, maxLength: 50),
                    _divider(light),
                    _field(context, controller.experienceCtrl, 'experience'.tr,
                        icon: Icons.workspace_premium_outlined,
                        keyboard: TextInputType.number,
                        maxLength: 2),
                  ]),
                  const SizedBox(height: 20),
                  _sectionLabel('Location'.tr, light),
                  const SizedBox(height: 10),
                  _card(context, light, [
                    Obx(() => _dropdownTile(
                          context,
                          light,
                          icon: Icons.public_outlined,
                          label: 'Country'.tr,
                          value: controller.selectedCountry.value?.name,
                          enabled: true,
                          onTap: () async {
                            await controller.fetchCountries(context);
                            showSelectionBottomSheet<CountryData>(
                              context: context,
                              title: "Select Country".tr,
                              items: controller.countryList,
                              itemLabel: (e) => e.name ?? "",
                              onSelect: (country) {
                                controller.selectedCountry.value = country;
                                controller.fetchStates(context, country.id!);
                              },
                            );
                          },
                        )),
                    _divider(light),
                    Obx(() => _dropdownTile(
                          context,
                          light,
                          icon: Icons.map_outlined,
                          label: 'State'.tr,
                          value: controller.selectedState.value?.name,
                          enabled: controller.selectedCountry.value != null,
                          onTap: controller.selectedCountry.value == null
                              ? null
                              : () async {
                                  showSelectionBottomSheet<StateData>(
                                    context: context,
                                    title: "Select State".tr,
                                    items: controller.stateList,
                                    itemLabel: (e) => e.name ?? "",
                                    onSelect: (state) {
                                      controller.selectedState.value = state;
                                      controller.fetchCities(
                                          context, state.id!);
                                    },
                                  );
                                },
                        )),
                    _divider(light),
                    Obx(() => _dropdownTile(
                          context,
                          light,
                          icon: Icons.location_city_outlined,
                          label: 'City'.tr,
                          value: controller.selectedCity.value?.name,
                          enabled: controller.selectedState.value != null,
                          onTap: controller.selectedState.value == null
                              ? null
                              : () {
                                  showSelectionBottomSheet<City>(
                                    context: context,
                                    title: "Select City".tr,
                                    items: controller.cityList,
                                    itemLabel: (e) => e.name ?? "",
                                    onSelect: (city) {
                                      controller.selectedCity.value = city;
                                    },
                                  );
                                },
                        )),
                  ]),
                  const SizedBox(height: 20),
                  _sectionLabel('class_name'.tr, light),
                  const SizedBox(height: 10),
                  _card(context, light, [
                    // Obx(() => _dropdownTile(
                    //   context,
                    //   light,
                    //   icon: Icons.class_outlined,
                    //   label: 'Select Classes',
                    //   value: controller.selectedClasses.isEmpty
                    //       ? null
                    //       : controller.selectedClasses
                    //       .map((e) => e.name)
                    //       .join(", "),
                    //   enabled: true,
                    //   isMultiline: true,
                    //   onTap: () async {
                    //     await controller.fetchClasses(context);
                    //     showSelectionBottomSheet<Class>(
                    //       context: context,
                    //       title: "Select Classes",
                    //       items: controller.classList,
                    //       itemLabel: (e) => e.name ?? "",
                    //       isMultiSelect: true,
                    //       selectedItems: controller.selectedClasses,
                    //       onSelect: controller.toggleClassSelection,
                    //     );
                    //   },
                    // )),
                    Obx(() => _dropdownTile(
                          context,
                          light,
                          icon: Icons.class_outlined,
                          label: 'class_name'.tr,
                          value: controller.selectedClasses.isEmpty
                              ? null
                              : controller.selectedClasses
                                  .map((e) => e.name)
                                  .join(", "),
                          enabled: false, // ❌ disable click
                          isMultiline: true,
                          onTap: null, // ❌ no bottom sheet
                        )),
                  ]),
                  const SizedBox(height: 32),
                  Obx(() => _saveButton(context, light)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── APPBAR ───────────────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context, bool light) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 0,
      backgroundColor: light ? Colors.white : const Color(0xFF1E1E1E),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded,
            size: 18, color: light ? Colors.black87 : Colors.white),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'edit_profile'.tr,
        style: TextStyle(
          color: light ? Colors.black87 : Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
            height: 1, color: light ? Colors.grey.shade200 : Colors.white12),
      ),
    );
  }

  // ─── PROFILE IMAGE ────────────────────────────────────────────────────────
  Widget _profileImageSection(BuildContext context, bool light) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 24),
          Obx(() {
            // Current user profile image should be shown here.
            final imageUrl = controller.uploadedImageUrl.value.isNotEmpty
                ? controller.uploadedImageUrl.value
                : controller.teacher.value?.profileLink;
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _teal, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: _teal.withOpacity(0.25),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 52,
                    backgroundColor: backgroundColor(context),
                    backgroundImage: imageUrl != null && imageUrl.isNotEmpty
                        ? NetworkImage(imageUrl)
                        : null,
                    child: imageUrl == null || imageUrl.isEmpty
                        ? Icon(Icons.person,
                            size: 48, color: _teal.withOpacity(0.6))
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: GestureDetector(
                    onTap: controller.isImageUploading.value
                        ? null
                        : () => controller.pickAndUploadImage(context),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: controller.isImageUploading.value
                            ? _teal.withOpacity(0.45)
                            : _teal,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: _teal.withOpacity(0.4),
                            blurRadius: 8,
                          )
                        ],
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
                ),
              ],
            );
          }),
          const SizedBox(height: 10),
          Text(
            'Tap the camera to change photo'.tr,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  // ─── SECTION LABEL ────────────────────────────────────────────────────────
  Widget _sectionLabel(String label, bool light) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: light ? Colors.black54 : Colors.white54,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  // ─── CARD ─────────────────────────────────────────────────────────────────
  Widget _card(BuildContext context, bool light, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor(context),
        border: Border.all(color: borderColor(context)),
        borderRadius: BorderRadius.circular(14),
        boxShadow: light
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                )
              ]
            : [],
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
        color: light ? Colors.grey.shade100 : Colors.white10,
      );

  // ─── TEXT FIELD ──────────────────────────────────────────────────────────
  Widget _field(
    BuildContext context,
    TextEditingController ctrl,
    String label, {
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    int maxLength = 20,
  }) {
    final light = isLight(context);
    return TextField(
      controller: ctrl,
      keyboardType: keyboard,
      style: TextStyle(
        fontSize: 14.5,
        color: light ? Colors.black87 : Colors.white,
      ),
      maxLength: maxLength,
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxLength), // 👈 HARD LIMIT
      ],
      decoration: InputDecoration(
        counterText: "",
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 13,
          color: light ? Colors.grey.shade500 : Colors.grey.shade400,
        ),
        fillColor: cardColor(context),
        prefixIcon: Icon(icon, size: 20, color: _teal.withOpacity(0.7)),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _countryCodePicker(bool light) {
    final subColor = light ? Colors.grey.shade500 : Colors.grey.shade400;

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
                      Icon(Icons.flag_outlined,
                          size: 20, color: _teal.withOpacity(0.7)),
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
                                color: controller
                                        .countryCodeCtrl.text.isNotEmpty
                                    ? (light ? Colors.black87 : Colors.white)
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
                style: TextStyle(
                  fontSize: 14.5,
                  color: light ? Colors.black87 : Colors.white,
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(20),
                ],
                decoration: InputDecoration(
                  counterText: "",
                  labelText: 'phone_no'.tr,
                  labelStyle: TextStyle(
                    fontSize: 13,
                    color: subColor,
                  ),
                  fillColor: cardColor(context),
                  prefixIcon: Icon(Icons.phone_outlined,
                      size: 20, color: _teal.withOpacity(0.7)),
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

  // ─── DROPDOWN TILE ────────────────────────────────────────────────────────
  Widget _dropdownTile(
    BuildContext context,
    bool light, {
    required IconData icon,
    required String label,
    String? value,
    bool enabled = true,
    bool isMultiline = false,
    VoidCallback? onTap,
  }) {
    final hasValue = value != null && value.isNotEmpty;

    return InkWell(
      onTap: enabled ? onTap : null, // ✅ disable click
      borderRadius: BorderRadius.circular(14),
      child: Opacity(
        opacity: enabled ? 1 : 0.6, // ✅ faded look when disabled
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: enabled ? _teal.withOpacity(0.7) : Colors.grey.shade400,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12.5,
                        color:
                            light ? Colors.grey.shade500 : Colors.grey.shade400,
                      ),
                    ),
                    if (hasValue) const SizedBox(height: 2),
                    Text(
                      hasValue
                          ? value
                          : enabled
                              ? 'Tap to select'.tr
                              : '-', // ✅ no message when disabled
                      maxLines: isMultiline ? 2 : 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.5,
                        color: hasValue
                            ? (light ? Colors.black87 : Colors.white)
                            : Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),

              // ✅ Hide arrow when disabled
              if (enabled)
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey.shade400,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── SAVE BUTTON ─────────────────────────────────────────────────────────
  Widget _saveButton(BuildContext context, bool light) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: controller.isLoading.value
            ? null
            : () => controller.updateProfile(context, widget.slug),
        style: ElevatedButton.styleFrom(
          backgroundColor: _teal,
          disabledBackgroundColor: _teal.withOpacity(0.5),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (controller.isLoading.value)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              )
            else
              const Icon(
                Icons.check_rounded,
                size: 20,
              ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                controller.isLoading.value ? 'Processing'.tr : 'save'.tr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
