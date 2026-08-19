import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../../../../core/utils/report_time_utils.dart';
import '../../../../../../../../../../../core/widget/back_button.dart';
import '../../../../../../../../../../../core/widget/empty_state.dart';
import '../../../../../../../../../../../core/widget/my_regular_text.dart';
import '../controller/report_controller.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final ReportController controller = Get.put(ReportController());

  String? slug;
  String? selectedDate;

  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is Map) {
      slug = args["slug"];
      selectedDate = ReportTimeUtils.resolveIsoDate(args["date"]?.toString());
    } else {
      slug = args;
      selectedDate = ReportTimeUtils.todayIso();
    }
    Future.delayed(const Duration(seconds: 0), () {
      controller.fetchNotes(context, slug!, date: selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    return Scaffold(
      backgroundColor:
          light ? const Color(0xFFF6F7FB) : const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(
          children: [
            /// ───────── HEADER ─────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  appBackButton(context),
                  const SizedBox(width: 14),
                  MyRegularText(
                    label: 'notes'.tr,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: primaryText(context),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      showNotesDialog(context);
                    },
                    child: Container(
                      width: 44,
                      height: 44,
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
                      child: Icon(
                        Icons.add,
                        size: 22,
                        color: light ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () {
                  //     showNotesDialog(context);
                  //   },
                  //   icon: const Icon(
                  //     Icons.add_circle_outline,
                  //     size: 28,
                  //   ),
                  // ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            /// ───────── LIST ─────────
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.notesList.isEmpty) {
                  return const Center(child: EmptyState());
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.notesList.length,
                  itemBuilder: (_, i) {
                    final note = controller.notesList[i];

                    return _noteCard(context, note.content ?? "", note.date);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void showNotesDialog(BuildContext context) {
    _notesController.clear();
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: _notesCard(context),
      ),
      barrierDismissible: false, // outside click close disable
    );
  }

  TextEditingController _notesController = TextEditingController();

  Widget _notesCard(BuildContext context) {
    final light = isLight(context);
    return Material(
      borderRadius: BorderRadius.circular(20),
      color: light ? const Color(0xFFE9EEF5) : const Color(0xFF1A1A1A),
      child: Container(
        decoration: BoxDecoration(
          color: light ? const Color(0xFFE9EEF5) : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color:
                    light ? const Color(0xFFF2F4F7) : const Color(0xFF222222),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  MyRegularText(
                    label: "Add Notes".tr,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: light ? Colors.black87 : Colors.white,
                  ),
                  const SizedBox(height: 6),
                  MyRegularText(
                    label:
                        "Add notes for kids to notify their Parents for any updates!"
                            .tr,
                    fontSize: 13,
                    color: light ? Colors.grey : Colors.grey.shade400,
                    align: TextAlign.center,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Notes Label
                  MyRegularText(
                    label: "Notes".tr,
                    fontWeight: FontWeight.w500,
                    color: light ? Colors.black87 : Colors.white,
                  ),

                  const SizedBox(height: 8),

                  /// TEXT FIELD
                  Container(
                    decoration: BoxDecoration(
                      color: light ? Colors.white : const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: light ? Colors.grey.shade300 : Colors.white12,
                      ),
                    ),
                    child: TextField(
                      controller: _notesController,
                      maxLines: 5,
                      style: TextStyle(
                        color: light ? Colors.black87 : Colors.white,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  /// BUTTONS
                  Row(
                    children: [
                      /// CANCEL BUTTON
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color:
                                light ? Colors.white : const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(light ? 0.08 : 0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => Get.back(),
                            child: Center(
                              child: MyRegularText(
                                label: "Cancel".tr,
                                fontWeight: FontWeight.w500,
                                color: light ? Colors.black87 : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      /// CONFIRM BUTTON
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C7C8C),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              controller
                                  .addNotes(
                                context,
                                slug ?? '',
                                _notesController.text,
                              )
                                  .then((value) {
                                controller.fetchNotes(
                                  context,
                                  slug!,
                                  date: selectedDate,
                                );
                              });
                            },
                            child: Center(
                              child: Text(
                                "confirm".tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ───────── NOTE CARD ─────────
  Widget _noteCard(
    BuildContext context,
    String content,
    DateTime? date,
  ) {
    final light = isLight(context);

    final locale = Get.locale?.languageCode ?? 'en';

    final formattedDate =
        date != null ? DateFormat("dd MMM yyyy", locale).format(date) : "";
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: light ? Colors.white : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: light ? Colors.grey.shade200 : Colors.grey.shade800,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// DATE
          MyRegularText(
            label: formattedDate,
            fontSize: 12,
            color: Colors.grey,
            align: TextAlign.start,
          ),

          const SizedBox(height: 8),

          /// CONTENT
          MyRegularText(
            label: content,
            fontSize: 14,
            align: TextAlign.start,
            fontWeight: FontWeight.w500,
            color: light ? Colors.black : Colors.white,
          ),
        ],
      ),
    );
  }
}
