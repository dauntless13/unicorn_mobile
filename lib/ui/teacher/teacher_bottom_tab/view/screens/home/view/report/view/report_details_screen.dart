import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../../core/utils/media_open_helper.dart';
import '../../../../../../../../../core/utils/report_time_utils.dart';
import '../../../../../../../../../core/widget/back_button.dart';
import '../../../../../../../../../core/widget/my_form_field.dart';
import '../../../../../../../../../core/widget/my_regular_text.dart';
import '../../../../../../../../../core/widget/profile_avatar.dart';
import '../../../../../../../../../routes/app_routs.dart';
import '../../../../../../../../../widget/app_date_picker_helper.dart';
import '../controller/report_controller.dart';

class ReportDetailsScreen extends StatefulWidget {
  final String slug;

  const ReportDetailsScreen({super.key, required this.slug});

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;
  final ReportController controller = Get.put(ReportController());

  /// Mood map: API key → emoji
  static const Map<String, String> _moodEmojiMap = {
    'happy': 'assets/png/happy.png',
    'confused': 'assets/png/confused.png',
    'cool': 'assets/png/cool.png',
    'amazed': 'assets/png/amazed.png',
    'stressed': 'assets/png/stressed.png',
    'peaceful': 'assets/png/peaceful.png',
  };

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final today = ReportTimeUtils.todayDate();
      controller.selectedDate.value = today;
      if (!mounted) return;
      await controller.studentDetailsBySlug(
        context,
        widget.slug,
        date: ReportTimeUtils.todayIso(today),
      );

      controller.setInitialMoods(
        controller.studentDetails.value?.todaysMood?.mood ?? [],
      );
    });
  }

  Future<void> _pickReportDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: ReportTimeUtils.todayDate(),
      builder: buildAppDatePickerThemeBuilder(
        context,
        primaryColor: primaryColor,
      ),
    );

    if (pickedDate == null) return;
    final next = ReportTimeUtils.dateOnly(pickedDate);
    if (ReportTimeUtils.isSameDay(next, controller.selectedDate.value)) return;
    controller.selectedDate.value = next;
    if (!mounted) return;
    await controller.studentDetailsBySlug(
      context,
      widget.slug,
      date: ReportTimeUtils.todayIso(next),
    );
  }

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    return Scaffold(
      backgroundColor:
          light ? const Color(0xFFF6F7FB) : const Color(0xFF0F0F0F),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ── Header ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      appBackButton(context),
                      const SizedBox(width: 14),
                      MyRegularText(
                        label: 'report'.tr,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: primaryText(context),
                      ),
                    ],
                  ),
                  Obx(() {
                    final selected = controller.selectedDate.value;
                    return GestureDetector(
                    onTap: () => _pickReportDate(),
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: light
                            ? Colors.white
                            : Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: light
                              ? Colors.grey.shade300
                              : Colors.white.withOpacity(0.15),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            size: 20,
                            color: light ? Colors.black : Colors.white,
                          ),
                          const SizedBox(width: 8),
                          MyRegularText(
                            label: DateFormat(
                              'EEE d MMM',
                              Get.locale?.languageCode,
                            ).format(selected),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: light ? Colors.black : Colors.white,
                          ),
                        ],
                      ),
                    ),
                  );
                  }),
                ],
              ),

              const SizedBox(height: 14),

              // ── Loading / Content ──
              Obx(() {
                if (controller.isReportDetailsLoading.value) {
                  return const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final data = controller.studentDetails.value;

                return Column(
                  children: [
                    _studentCard(context, data),
                    const SizedBox(height: 14),
                    _moodSection(context),
                    const SizedBox(height: 14),
                    _activityGrid(context),
                    if ((data?.reportPdfLink ?? '').trim().isNotEmpty) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => openDownloadableMedia(
                            url: data!.reportPdfLink,
                            title: 'view_report'.tr,
                            kind: DownloadableKind.pdf,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(
                            Icons.visibility_rounded,
                            color: Colors.white,
                          ),
                          label: Text(
                            'view_report'.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════
  //  STUDENT CARD
  // ═══════════════════════════════════════════════
  Widget _studentCard(BuildContext context, studentData) {
    final light = isLight(context);

    final String name = studentData?.name ?? '-';
    final String roll = studentData?.roll ?? '-';
    final String className = studentData?.className ?? '-';
    final String? photoUrl = studentData?.profileLink;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: light ? Colors.white : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: light ? Colors.grey.shade300 : Colors.grey.shade700,
        ),
      ),
      child: Row(
        children: [
          ProfileAvatar(
            radius: 26,
            imageUrl: photoUrl,
            backgroundColor: Colors.grey.shade300,
            iconColor: Colors.white,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyRegularText(
                label: name,
                fontWeight: FontWeight.w600,
                fontSize: 15,
                align: TextAlign.start,
                color: light ? Colors.black : Colors.white,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  MyRegularText(
                    label: 'roll_no'.tr,
                    fontSize: 12,
                    color: Colors.grey,
                    align: TextAlign.start,
                  ),
                  MyRegularText(
                    label: ' : $roll',
                    fontSize: 12,
                    color: Colors.grey,
                    align: TextAlign.start,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  MyRegularText(
                    label: 'class'.tr,
                    fontSize: 12,
                    color: Colors.grey,
                    align: TextAlign.start,
                  ),
                  MyRegularText(
                    label: ' : $className',
                    fontSize: 12,
                    color: Colors.grey,
                    align: TextAlign.start,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════
  //  MOOD SECTION
  // ═══════════════════════════════════════════════
  // Widget _moodSection(BuildContext context, List<String> selectedMoods) {
  //   final light = isLight(context);
  //
  //   // Normalise to lowercase for safe comparison
  //   final selected = selectedMoods.map((e) => e.toLowerCase()).toSet();
  //
  //   final moods = _moodEmojiMap.entries
  //       .map((e) => {'key': e.key, 'emoji': e.value})
  //       .toList();
  //
  //   return Container(
  //     padding: const EdgeInsets.all(14),
  //     decoration: BoxDecoration(
  //       color: light ? Colors.white : const Color(0xFF1A1A1A),
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(
  //         color: light ? Colors.grey.shade200 : Colors.grey.shade800,
  //       ),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             MyRegularText(
  //               label: 'today_mood'.tr,
  //               fontWeight: FontWeight.w600,
  //               align: TextAlign.start,
  //               color: light ? Colors.black : Colors.white,
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 14),
  //         GridView.builder(
  //           shrinkWrap: true,
  //           physics: const NeverScrollableScrollPhysics(),
  //           itemCount: moods.length,
  //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 3,
  //             mainAxisSpacing: 14,
  //             crossAxisSpacing: 14,
  //             childAspectRatio: .9,
  //           ),
  //           itemBuilder: (_, i) {
  //             final mood       = moods[i];
  //             final moodKey    = mood['key']!;
  //             final isSelected = selected.contains(moodKey);
  //
  //             return Column(
  //               children: [
  //                 // ── Emoji bubble ──
  //                 AnimatedContainer(
  //                   duration: const Duration(milliseconds: 200),
  //                   width: 54,
  //                   height: 54,
  //                   decoration: BoxDecoration(
  //                     shape: BoxShape.circle,
  //                     color: isSelected
  //                         ? const Color(0xFF6C63FF).withOpacity(0.15)
  //                         : const Color(0xFFE3E7F0),
  //                     border: isSelected
  //                         ? Border.all(
  //                       color: const Color(0xFF6C63FF),
  //                       width: 2,
  //                     )
  //                         : null,
  //                   ),
  //                   child: Center(
  //                     child: Text(
  //                       mood['emoji']!,
  //                       style: TextStyle(
  //                         fontSize: isSelected ? 28 : 26,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 6),
  //                 MyRegularText(
  //                   label: moodKey.tr,
  //                   fontSize: 12,
  //                   color: isSelected
  //                       ? const Color(0xFF6C63FF)
  //                       : (light ? Colors.black : Colors.white),
  //                   fontWeight: isSelected
  //                       ? FontWeight.w600
  //                       : FontWeight.normal,
  //                 ),
  //               ],
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
  // Widget _moodSection(BuildContext context) {
  //   final light = isLight(context);
  //
  //   final moods = _moodEmojiMap.entries
  //       .map((e) => {'key': e.key, 'emoji': e.value})
  //       .toList();
  //
  //   return Container(
  //     padding: const EdgeInsets.all(14),
  //     decoration: BoxDecoration(
  //       color: light ? Colors.white : const Color(0xFF1A1A1A),
  //       borderRadius: BorderRadius.circular(16),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         MyRegularText(
  //           label: 'today_mood'.tr,
  //           fontWeight: FontWeight.w600,
  //           color: light ? Colors.black : Colors.white,
  //         ),
  //
  //         const SizedBox(height: 14),
  //
  //         GridView.builder(
  //             shrinkWrap: true,
  //             physics: const NeverScrollableScrollPhysics(),
  //             itemCount: moods.length,
  //             gridDelegate:
  //             const SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: 3,
  //               mainAxisSpacing: 14,
  //               crossAxisSpacing: 14,
  //               childAspectRatio: .9,
  //             ),
  //             itemBuilder: (_, i) {
  //               final mood = moods[i];
  //               final moodKey = mood['key']!;
  //
  //               final isSelected =
  //               controller.selectedMoods.contains(moodKey);
  //
  //               return GestureDetector(
  //                 onTap: () {
  //                   controller.toggleMood(
  //                     context,
  //                     widget.slug,
  //                     moodKey,
  //                   );
  //                 },
  //                 child: Column(
  //                     children: [
  //                 AnimatedContainer(
  //                 duration: const Duration(milliseconds: 200),
  //                 width: 54,
  //                 height: 54,
  //                 decoration: BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   color: isSelected
  //                       ? const Color(0xFF6C63FF).withOpacity(0.15)
  //                       : const Color(0xFFE3E7F0),
  //                   border: isSelected
  //                       ? Border.all(
  //                     color: const Color(0xFF6C63FF),
  //                     width: 2,
  //                   )
  //                       : null,
  //                 ),
  //                 child: Center(
  //                   child: Text(
  //                     mood['emoji']!,
  //                     style: TextStyle(
  //                       fontSize: isSelected ? 28 : 26,
  //                     ),
  //                   ),
  //                 ))]),
  //               );
  //             },
  //           ),
  //       ],
  //     ),
  //   );
  // }
  Widget _moodSection(BuildContext context) {
    final light = isLight(context);

    final moods = _moodEmojiMap.entries
        .map((e) => {'key': e.key, 'emoji': e.value})
        .toList();

    return Obx(() {
      /// 🔥 Explicitly read Rx value
      final moodsSelected = controller.selectedMoods.value;

      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: light ? Colors.white : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: light ? Colors.grey.shade300 : Colors.grey.shade700,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyRegularText(
              label: 'today_mood'.tr,
              fontWeight: FontWeight.w600,
              color: light ? Colors.black : Colors.white,
            ),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: moods.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: .9,
              ),
              itemBuilder: (_, i) {
                final mood = moods[i];
                final moodKey = mood['key']!;

                final isSelected = moodsSelected.contains(moodKey);

                return GestureDetector(
                  onTap: () {
                    controller.toggleMood(
                      context,
                      widget.slug,
                      moodKey,
                    );
                  },
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? const Color(0xFF6C63FF).withOpacity(.15)
                              : const Color(0xFFE3E7F0),
                          border: isSelected
                              ? Border.all(
                                  color: const Color(0xFF6C63FF),
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Center(
                          child: Image.asset(
                            mood['emoji']!,
                            width: isSelected ? 30 : 26,
                            height: isSelected ? 30 : 26,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      MyRegularText(
                        label: moodKey.tr,
                        fontSize: 12,
                        color: isSelected
                            ? const Color(0xFF6C63FF)
                            : (light ? Colors.black : Colors.white),
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.bold,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  // ═══════════════════════════════════════════════
  //  ACTIVITY GRID  (unchanged logic, same UI)
  // ═══════════════════════════════════════════════
  Widget _activityGrid(BuildContext context) {
    final light = isLight(context);

    final items = [
      {
        'image': 'assets/svg/snoop.svg',
        'label': 'meal_snacks'.tr,
        'route': Routes.MEAL_SNACKS_LIST,
      },
      {
        'image': 'assets/svg/sleep.svg',
        'label': 'nap_time'.tr,
        'route': Routes.NAP_LIST,
      },
      {
        'image': 'assets/svg/candle.svg',
        'label': 'activities'.tr,
        'route': Routes.ACTIVITY_LIST,
      },
      {
        'image': 'assets/svg/handwash.svg',
        'label': 'hygiene'.tr,
        'route': Routes.HYGIENE_LIST,
      },
      {
        'image': 'assets/svg/note.svg',
        'label': 'notes'.tr,
        'route': Routes.NOTES_SCREEN,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 2.6,
      ),
      itemBuilder: (_, i) {
        final item = items[i] as Map<String, dynamic>;
        final selectedDate = controller.selectedDateIso;

        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () =>
              Get.toNamed(
                item['route'] as String,
                arguments: {
                  "slug": widget.slug,
                  "date": selectedDate,
                },
              ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: light ? Colors.white : const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: light ? Colors.grey.shade300 : Colors.grey.shade700,
              ),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  item['image'],
                  width: 22,
                  height: 22,
                  fit: BoxFit.contain,
                  colorFilter: ColorFilter.mode(
                    light ? Colors.black : Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: MyRegularText(
                    label: item['label'],
                    align: TextAlign.start,
                    fontWeight: FontWeight.bold,
                    color: light ? Colors.black : Colors.white,

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
