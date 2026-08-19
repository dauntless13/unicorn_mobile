import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:unicorn/core/widget/profile_avatar.dart';
import 'package:unicorn/widget/app_date_picker_helper.dart';

import 'controller/kids_controller.dart';

class EditStudentScreen extends StatefulWidget {
  final String slug;
  const EditStudentScreen({super.key, required this.slug});

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen>
    with SingleTickerProviderStateMixin {
  final KidsController controller = Get.find<KidsController>();

  static const _teal = Color(0xFF0D6E82);

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;
  String formatPackage(String value) {
    if (value.isEmpty) return value;

    return value
        .toLowerCase() // six_month
        .split('_') // [six, month]
        .map((word) => word[0].toUpperCase() + word.substring(1)) // Six Month
        .join(' ');
  }

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.initEditStudentScreen(context);
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
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Profile Image ──────────────────────────────────────
                  _profileImageSection(context, light),
                  const SizedBox(height: 24),

                  // ── Student Info ───────────────────────────────────────
                  _sectionLabel('Student Info'.tr, light),
                  const SizedBox(height: 10),
                  _card(context, light, [
                    _field(context, controller.studentFirstNameCtrl,
                        'first_name'.tr,
                        icon: Icons.person_outline),
                    _divider(light),
                    _field(
                        context, controller.studentLastNameCtrl, 'last_name'.tr,
                        icon: Icons.person_outline),
                    _divider(light),
                    _field(context, controller.studentAddressCtrl, 'address'.tr,
                        icon: Icons.location_on_outlined, maxLength: 100),
                    _divider(light),
                    _field(context, controller.studentZipCtrl, 'zip_code'.tr,
                        icon: Icons.pin_drop_outlined,
                        keyboard: TextInputType.number,
                        maxLength: 8),
                    _divider(light),
                    // Gender Dropdown
                    Obx(() => _dropdownTile(
                          context,
                          light,
                          icon: Icons.wc_outlined,
                          label: 'gender'.tr,
                          value: controller.selectedGender.value,
                          enabled: true,
                          onTap: () => _showGenderPicker(context),
                        )),
                    _divider(light),
                    // Date of Birth
                    Obx(() => _dropdownTile(
                          context,
                          light,
                          icon: Icons.cake_outlined,
                          label: 'date_of_birth'.tr,
                          value: controller.studentDob.value.isNotEmpty
                              ? controller.studentDob.value
                              : null,
                          enabled: true,
                          onTap: () => _pickDob(context),
                        )),
                  ]),
                  const SizedBox(height: 20),

                  // ── Fee & Package ──────────────────────────────────────
                  _sectionLabel('Fee & Package'.tr, light),
                  const SizedBox(height: 10),
                  _card(context, light, [
                    _field(
                      context,
                      controller.studentCurrencyCtrl,
                      'Currency'.tr,
                      readOnly: true,
                      icon: Icons.currency_exchange_outlined,
                    ),
                    _divider(light),
                    _field(context, controller.studentFeeAmountCtrl,
                        'Fee Amount'.tr,
                        icon: Icons.attach_money_outlined,
                        readOnly: true,
                        keyboard: TextInputType.number),
                    _divider(light),
                    Obx(() => _dropdownTile(
                          context,
                          light,
                          icon: Icons.calendar_today_outlined,
                          label: 'Package Duration'.tr,
                          value: formatPackage(
                              controller.selectedPackageDuration.value),
                          enabled: false, // 👈 disable UI
                          onTap: null,
                        )),
                  ]),
                  const SizedBox(height: 20),

                  // ── Location ───────────────────────────────────────────
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
                            _showListPicker(
                              context,
                              title: 'Select Country'.tr,
                              items: controller.countryList
                                  .map((e) => e.name ?? '')
                                  .toList(),
                              onSelect: (name) {
                                final country = controller.countryList
                                    .firstWhereOrNull((c) => c.name == name);
                                if (country != null) {
                                  controller.selectedCountry.value = country;
                                  controller.fetchStates(
                                      context, country.id ?? '');
                                }
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
                              : () {
                                  _showListPicker(
                                    context,
                                    title: 'Select State'.tr,
                                    items: controller.stateList
                                        .map((e) => e.name ?? '')
                                        .toList(),
                                    onSelect: (name) {
                                      final state = controller.stateList
                                          .firstWhereOrNull(
                                              (s) => s.name == name);
                                      if (state != null) {
                                        controller.selectedState.value = state;
                                        controller.fetchCities(
                                            context, state.id ?? '');
                                      }
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
                                  _showListPicker(
                                    context,
                                    title: 'Select City'.tr,
                                    items: controller.cityList
                                        .map((e) => e.name ?? '')
                                        .toList(),
                                    onSelect: (name) {
                                      final city = controller.cityList
                                          .firstWhereOrNull(
                                              (c) => c.name == name);
                                      if (city != null) {
                                        controller.selectedCity.value = city;
                                      }
                                    },
                                  );
                                },
                        )),
                  ]),
                  const SizedBox(height: 20),

                  // ── Class ──────────────────────────────────────────────
                  _sectionLabel('Class'.tr, light),
                  const SizedBox(height: 10),
                  _card(context, light, [
                    Obx(() => _dropdownTile(
                          context,
                          light,
                          icon: Icons.class_outlined,
                          label: 'Select Class'.tr,
                          value: controller.selectedClass.value?.name,
                          // enabled: true,
                          // onTap: () async {
                          //   await controller.fetchClasses(context);
                          //   _showListPicker(
                          //     context,
                          //     title: 'Select Class'.tr,
                          //     items: controller.classList
                          //         .map((e) => e.name ?? '')
                          //         .toList(),
                          //     onSelect: (name) {
                          //       final cls = controller.classList
                          //           .firstWhereOrNull((c) => c.name == name);
                          //       if (cls != null) {
                          //         controller.selectedClass.value = cls;
                          //       }
                          //     },
                          //   );
                          // },
                          enabled: false, // 👈 disable UI
                          onTap: null,
                        )),
                  ]),
                  const SizedBox(height: 20),

                  // ── Medical Info ───────────────────────────────────────
                  _sectionLabel('Medical Info'.tr, light),
                  const SizedBox(height: 10),
                  _card(context, light, [
                    Obx(() => _switchTile(
                          context,
                          light,
                          icon: Icons.healing_outlined,
                          label: 'Has Allergies'.tr,
                          value: controller.hasAllergies.value,
                          onChanged: (v) => controller.hasAllergies.value = v,
                        )),
                    _divider(light),
                    Obx(() => _switchTile(
                          context,
                          light,
                          icon: Icons.medication_outlined,
                          label: 'Takes Medications'.tr,
                          value: controller.takesMedications.value,
                          onChanged: (v) =>
                              controller.takesMedications.value = v,
                        )),
                    _divider(light),
                    Obx(() => _switchTile(
                          context,
                          light,
                          icon: Icons.medical_information_outlined,
                          label: 'Has Medical Condition'.tr,
                          value: controller.hasMedicalCondition.value,
                          onChanged: (v) =>
                              controller.hasMedicalCondition.value = v,
                        )),
                    _divider(light),
                    Obx(() => _switchTile(
                          context,
                          light,
                          icon: Icons.directions_car_outlined,
                          label: 'Pickup'.tr,
                          value: controller.pickup.value,
                          onChanged: (v) => controller.pickup.value = v,
                        )),
                    _divider(light),
                    Obx(() => _switchTile(
                          context,
                          light,
                          icon: Icons.gavel_outlined,
                          label: 'Medical Decision'.tr,
                          value: controller.medicalDecision.value,
                          onChanged: (v) =>
                              controller.medicalDecision.value = v,
                        )),
                  ]),
                  const SizedBox(height: 20),

                  // ── Parent Info ────────────────────────────────────────
                  _sectionLabel('Parent Information'.tr, light),
                  const SizedBox(height: 10),
                  _card(context, light, [
                    _field(context, controller.parentFirstNameCtrl,
                        'First Name'.tr,
                        icon: Icons.person_outline),
                    _divider(light),
                    _field(
                        context, controller.parentLastNameCtrl, 'Last Name'.tr,
                        icon: Icons.person_outline),
                    _divider(light),
                    _phoneWithCountryCodeRow(
                      context,
                      phoneController: controller.parentPhoneCtrl,
                      codeController: controller.parentCountryCodeCtrl,
                      phoneLabel: 'Phone Number'.tr,
                    ),
                    _divider(light),
                    _field(context, controller.parentAddressCtrl, 'Address'.tr,
                        icon: Icons.location_on_outlined),
                    _divider(light),
                    _field(
                        context, controller.parentEducationCtrl, 'Education'.tr,
                        icon: Icons.school_outlined, maxLength: 50),
                    _divider(light),
                    _field(context, controller.parentOccupationCtrl,
                        'Occupation'.tr,
                        icon: Icons.work_outline),
                    _divider(light),
                    Obx(() => _dropdownTile(
                          context,
                          light,
                          icon: Icons.people_outline,
                          label: 'Relationship'.tr,
                          value: controller.isParentOther.value
                              ? (controller.parentCustomRelationshipCtrl.text
                                      .trim()
                                      .isNotEmpty
                                  ? controller.parentCustomRelationshipCtrl.text
                                      .trim()
                                  : 'Other'.tr)
                              : controller.parentRelationship.value,
                          enabled: true,
                          onTap: () =>
                              _showRelationshipPicker(context, isParent: true),
                        )),
                    Obx(() {
                      if (!controller.isParentOther.value) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        children: [
                          _divider(light),
                          _field(
                            context,
                            controller.parentCustomRelationshipCtrl,
                            'Enter Relationship'.tr,
                            icon: Icons.edit_outlined,
                          ),
                        ],
                      );
                    }),
                  ]),
                  const SizedBox(height: 20),

                  // ── Emergency Contact ──────────────────────────────────
                  _sectionLabel('Emergency Contact'.tr, light),
                  const SizedBox(height: 10),
                  _card(context, light, [
                    _field(context, controller.emergencyFirstNameCtrl,
                        'first_name'.tr,
                        icon: Icons.person_outline),
                    _divider(light),
                    _field(context, controller.emergencyLastNameCtrl,
                        'last_name'.tr,
                        icon: Icons.person_outline),
                    _divider(light),
                    _field(context, controller.emergencyEmailCtrl,
                        'Email Address'.tr,
                        icon: Icons.email_outlined,
                        keyboard: TextInputType.emailAddress,
                        readOnly: true),
                    _divider(light),
                    _phoneWithCountryCodeRow(
                      context,
                      phoneController: controller.emergencyPhoneCtrl,
                      codeController: controller.emergencyCountryCodeCtrl,
                      phoneLabel: 'Phone Number'.tr,
                    ),
                    _divider(light),
                    _phoneWithCountryCodeRow(
                      context,
                      phoneController: controller.emergencySecondaryPhoneCtrl,
                      codeController: controller.emergencySecondaryCodeCtrl,
                      phoneLabel: 'Secondary Phone'.tr,
                    ),
                    _divider(light),
                    _field(context, controller.emergencyEducationCtrl,
                        'Education'.tr,
                        icon: Icons.school_outlined),
                    _divider(light),
                    _field(context, controller.emergencyOccupationCtrl,
                        'Occupation'.tr,
                        icon: Icons.work_outline),
                    _divider(light),
                    Obx(() => _dropdownTile(
                          context,
                          light,
                          icon: Icons.people_outline,
                          label: 'Relationship'.tr,
                          // value: controller.isEmergencyOther.value
                          //     ? (controller.emergencyCustomRelationshipCtrl.text
                          //                 .trim()
                          //                 .isNotEmpty
                          //             ? controller.emergencyCustomRelationshipCtrl.text
                          //                 .trim()
                          //             : 'Other'.tr)
                          //     : controller.emergencyRelationship.value,
                          value: controller.isEmergencyOther.value
                              ? 'Other'.tr
                              : controller.emergencyRelationship.value,
                          enabled: true,
                          onTap: () =>
                              _showRelationshipPicker(context, isParent: false),
                        )),
                    Obx(() {
                      if (!controller.isEmergencyOther.value) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        children: [
                          _divider(light),
                          _field(
                            context,
                            controller.emergencyCustomRelationshipCtrl,
                            'Enter Relationship'.tr,
                            icon: Icons.edit_outlined,
                          ),
                        ],
                      );
                    }),
                  ]),
                  const SizedBox(height: 32),

                  // ── Save Button ────────────────────────────────────────
                  Obx(() => _saveButton(context, light)),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── APP BAR ──────────────────────────────────────────────────────────────
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
        'Edit Student'.tr,
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
            final imageUrl = controller.studentUploadedImageUrl.value.isNotEmpty
                ? controller.studentUploadedImageUrl.value
                : controller.studentInfoDetails.value?.profileLink;
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
                  child: ProfileAvatar(
                    radius: 52,
                    imageUrl: imageUrl,
                    backgroundColor: light
                        ? const Color(0xFFE8F3F6)
                        : const Color(0xFF1E1E1E),
                    iconColor: _teal.withOpacity(0.6),
                    iconSize: 48,
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: GestureDetector(
                    onTap: controller.isStudentImageUploading.value
                        ? null
                        : () => controller.pickAndUploadStudentImage(context),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: controller.isStudentImageUploading.value
                            ? _teal.withOpacity(0.45)
                            : _teal,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                              color: _teal.withOpacity(0.4), blurRadius: 8)
                        ],
                      ),
                      child: Icon(
                        controller.isStudentImageUploading.value
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
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
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
        color: light ? Colors.white : const Color(0xFF1E1E1E),
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
      child: Column(children: children),
    );
  }

  Widget _divider(bool light) => Divider(
        height: 1,
        indent: 52,
        color: light ? Colors.grey.shade100 : Colors.white10,
      );

  // ─── TEXT FIELD ───────────────────────────────────────────────────────────
  Widget _phoneWithCountryCodeRow(
    BuildContext context, {
    required TextEditingController phoneController,
    required TextEditingController codeController,
    required String phoneLabel,
  }) {
    final light = isLight(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: _countryCodeSelector(
              context,
              codeController: codeController,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
              ],
              style: TextStyle(
                fontSize: 14.5,
                color: light ? Colors.black87 : Colors.white,
              ),
              decoration: InputDecoration(
                labelText: phoneLabel,
                labelStyle: TextStyle(
                  fontSize: 13,
                  color: light ? Colors.grey.shade500 : Colors.grey.shade400,
                ),
                prefixIcon: Icon(
                  Icons.phone_outlined,
                  size: 20,
                  color: _teal.withOpacity(0.7),
                ),
                filled: true,
                fillColor: light ? Colors.white : const Color(0xFF1E1E1E),
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
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _teal),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _countryCodeSelector(
    BuildContext context, {
    required TextEditingController codeController,
  }) {
    final light = isLight(context);
    return InkWell(
      onTap: () {
        showCountryPicker(
          context: context,
          showPhoneCode: true,
          countryListTheme: CountryListThemeData(
            backgroundColor: light ? Colors.white : const Color(0xFF1E1E1E),
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
                color: light ? Colors.grey.shade500 : Colors.grey.shade400,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: light ? Colors.grey.shade600 : Colors.grey.shade400,
              ),
              filled: true,
              fillColor: light ? Colors.grey.shade100 : const Color(0xFF2A2A2A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          onSelect: (Country country) {
            setState(() {
              codeController.text = '+${country.phoneCode}';
            });
          },
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        decoration: BoxDecoration(
          color: light ? Colors.white : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: light ? Colors.grey.shade200 : Colors.white10,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.flag_outlined, size: 20, color: _teal.withOpacity(0.7)),
            const SizedBox(width: 10),
            Expanded(
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: codeController,
                builder: (_, value, __) {
                  final hasValue = value.text.isNotEmpty;
                  return Text(
                    hasValue ? value.text : 'Code'.tr,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.5,
                      color: hasValue
                          ? (light ? Colors.black87 : Colors.white)
                          : Colors.grey.shade400,
                    ),
                  );
                },
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    BuildContext context,
    TextEditingController ctrl,
    String label, {
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    bool readOnly = false, // 👈 add this
    int maxLength = 20,
  }) {
    final light = isLight(context);
    return TextField(
      controller: ctrl,
      keyboardType: keyboard,
      readOnly: readOnly, // 👈 apply here
      enableInteractiveSelection: !readOnly, // optional (disable copy/paste)
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxLength), // 👈 HARD LIMIT
      ],
      style: TextStyle(
        fontSize: 14.5,
        color: light ? Colors.black87 : Colors.white,
      ),

      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 13,
          color: light ? Colors.grey.shade500 : Colors.grey.shade400,
        ),
        prefixIcon: Icon(icon, size: 20, color: _teal.withOpacity(0.7)),
        filled: true,
        fillColor: (light ? Colors.white : const Color(0xFF1E1E1E)),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
    VoidCallback? onTap,
  }) {
    final hasValue = value != null && value.isNotEmpty;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon,
                size: 20,
                color: enabled ? _teal.withOpacity(0.7) : Colors.grey.shade400),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          fontSize: 12.5,
                          color: light
                              ? Colors.grey.shade500
                              : Colors.grey.shade400)),
                  if (hasValue) const SizedBox(height: 2),
                  Text(
                    hasValue ? value : 'Tap to select'.tr,
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
            if (enabled)
              Icon(Icons.keyboard_arrow_down_rounded,
                  color: enabled ? Colors.grey.shade400 : Colors.grey.shade300),
          ],
        ),
      ),
    );
  }

  // ─── SWITCH TILE ──────────────────────────────────────────────────────────
  Widget _switchTile(
    BuildContext context,
    bool light, {
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: _teal.withOpacity(0.7)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 14.5, color: light ? Colors.black87 : Colors.white),
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: _teal,
          ),
        ],
      ),
    );
  }

  // ─── SAVE BUTTON ──────────────────────────────────────────────────────────
  Widget _saveButton(BuildContext context, bool light) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: controller.isStudentUpdating.value
            ? null
            : () => controller.updateStudentDetails(context, widget.slug),
        style: ElevatedButton.styleFrom(
          backgroundColor: _teal,
          disabledBackgroundColor: _teal.withOpacity(0.5),
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (controller.isStudentUpdating.value)
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
                controller.isStudentUpdating.value
                    ? 'Processing'.tr
                    : 'Save'.tr,
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

  // ─── PICKERS ──────────────────────────────────────────────────────────────
  void _showGenderPicker(BuildContext context) {
    final genderOptions = {
      'Male'.tr: 'MALE',
      'Female'.tr: 'FEMALE',
      'Other'.tr: 'OTHER',
    };

    _showListPicker(
      context,
      title: 'Select Gender'.tr,
      items: genderOptions.keys.toList(), // what user sees
      onSelect: (selectedLabel) {
        controller.selectedGender.value =
            genderOptions[selectedLabel]!; // what you send
      },
    );
  }

  void _showPackagePicker(BuildContext context) {
    _showListPicker(
      context,
      title: 'Package Duration',
      items: const [
        'ONE_MONTH',
        'THREE_MONTH',
        'SIX_MONTH',
        'ONE_YEAR',
      ],
      onSelect: (v) => controller.selectedPackageDuration.value = v,
    );
  }

  void _showRelationshipPicker(BuildContext context, {required bool isParent}) {
    final relationshipOptions = isParent
        ? {
            // ✅ Parent → ONLY 3 options
            'Father'.tr: 'FATHER',
            'Mother'.tr: 'MOTHER',
            'Guardian'.tr: 'GUARDIAN',
          }
        : {
            // ✅ Emergency → KEEP SAME (with Other)
            'Father'.tr: 'FATHER',
            'Mother'.tr: 'MOTHER',
            'Guardian'.tr: 'GUARDIAN',
            'Other'.tr: 'OTHER',
          };

    _showListPicker(
      context,
      title: 'Select Relationship'.tr,
      items: relationshipOptions.keys.toList(),
      onSelect: (selectedLabel) {
        final value = relationshipOptions[selectedLabel]!;

        if (isParent) {
          // ✅ Parent logic (NO Other handling)
          controller.parentRelationship.value = value;
          controller.isParentOther.value = false;
          controller.parentCustomRelationshipCtrl.clear();
        } else {
          // ✅ Emergency logic (UNCHANGED)
          controller.emergencyRelationship.value = value;

          if (value == "OTHER") {
            controller.isEmergencyOther.value = true;
          } else {
            controller.isEmergencyOther.value = false;
            controller.emergencyCustomRelationshipCtrl.clear();
          }
        }
      },
    );
  }

  Future<void> _pickDob(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2020),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: buildAppDatePickerThemeBuilder(
        context,
        primaryColor: _teal,
      ),
    );
    if (picked != null) {
      controller.studentDob.value = '${picked.year.toString().padLeft(4, '0')}-'
          '${picked.month.toString().padLeft(2, '0')}-'
          '${picked.day.toString().padLeft(2, '0')}';
    }
  }

  void _showListPicker(
    BuildContext context, {
    required String title,
    required List<String> items,
    required ValueChanged<String> onSelect,
  }) {
    final light = isLight(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          maxChildSize: 0.85,
          minChildSize: 0.3,
          builder: (_, sc) => Container(
            decoration: BoxDecoration(
              color: light ? Colors.white : const Color(0xFF1E1E1E),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 24,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                // ── Handle ───────────────────────────────────────
                const SizedBox(height: 12),
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: light ? Colors.grey.shade300 : Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Title ─────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _teal,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: light ? Colors.black87 : Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ── Divider ───────────────────────────────────────
                Divider(
                  height: 1,
                  color: light ? Colors.grey.shade100 : Colors.white10,
                ),

                // ── List ──────────────────────────────────────────
                Expanded(
                  child: ListView.separated(
                    controller: sc,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      indent: 56,
                      endIndent: 20,
                      color: light ? Colors.grey.shade100 : Colors.white10,
                    ),
                    itemBuilder: (_, i) {
                      return InkWell(
                        onTap: () {
                          onSelect(items[i]);
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: _teal.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    items[i][0],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: _teal,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  items[i],
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        light ? Colors.black87 : Colors.white,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                size: 18,
                                color: light
                                    ? Colors.grey.shade300
                                    : Colors.white24,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ── Cancel Button ────────────────────────────────
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      20, 8, 20, MediaQuery.of(context).padding.bottom + 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor:
                            light ? Colors.grey.shade100 : Colors.white10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Cancel'.tr,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: light ? Colors.black54 : Colors.white54,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
