import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:toastification/toastification.dart';
import 'package:unicorn/core/widget/my_regular_text.dart';
import 'package:unicorn/core/widget/profile_avatar.dart';
import 'package:unicorn/service/session/session_helper.dart';
import 'package:unicorn/widget/app_date_picker_helper.dart';
import 'package:unicorn/widget/common_toastification.dart';

import '../../../../../../../../controller/nursery_module_controller.dart';
import '../../../../../../../../core/ColorUtils.dart';
import 'package:unicorn/core/utils/media_open_helper.dart';
import 'package:unicorn/core/utils/protected_file_downloader.dart';
import 'package:unicorn/core/utils/report_display_utils.dart';
import 'package:unicorn/core/utils/report_time_utils.dart';
import 'package:unicorn/core/widget/empty_state.dart';
import 'package:unicorn/widget/file_action_sheet.dart';
import '../../../../../../teacher/teacher_bottom_tab/view/screens/home/view/report/model/evaluation_forms_list/evaluation_forms_list_response.dart';
import '../../../../../../teacher/teacher_bottom_tab/view/screens/home/view/report/model/report_details_by_student_slug/report_details_by_student_slug_response.dart';
import 'package:unicorn/webpage/in_app_pdf_viewer_screen.dart';
import '../../calendar/view/calendar_screen.dart';
import 'controller/kids_controller.dart';
import 'edit_student_screen.dart';
import 'model/fees_details/fees_details_response.dart';

class KidsScreen extends StatefulWidget {
  const KidsScreen({
    super.key,
    this.galleryOnly = false,
    this.initialTabIndex = 0,
    this.initialStudentSlug,
  });

  final bool galleryOnly;
  final int initialTabIndex;
  final String? initialStudentSlug;

  @override
  State<KidsScreen> createState() => _KidsScreenState();
}

class _KidsScreenState extends State<KidsScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late TabController _galleryTabController;
  int _selectedKidIndex = 0;
  DateTime _selectedDate = ReportTimeUtils.todayDate();
  bool _showEvaluationDateFilter = false;
  bool _showMedicalDateFilter = false;

  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  Color pageBg(BuildContext context) =>
      isLight(context) ? Colors.white : const Color(0xFF0F0F0F);

  Color cardBg(BuildContext context) =>
      isLight(context) ? Colors.white : const Color(0xFF1A1A1A);

  Color softBg(BuildContext context) =>
      isLight(context) ? Colors.grey.shade100 : const Color(0xFF242424);

  Color primaryText(BuildContext context) =>
      isLight(context) ? Colors.black87 : Colors.white;

  Color secondaryText(BuildContext context) =>
      isLight(context) ? Colors.grey.shade600 : Colors.grey.shade400;

  Color borderClr(BuildContext context) =>
      isLight(context) ? Colors.grey.shade300 : Colors.white.withOpacity(0.12);

  Color dividerClr(BuildContext context) =>
      isLight(context) ? Colors.grey.shade200 : Colors.white.withOpacity(0.08);

  final KidsController controller = Get.put(KidsController());
  final DateTime _minDate = DateTime(2020, 1, 1);
  DateTime get _maxDate => ReportTimeUtils.todayDate();
  bool get _showEvaluationTab =>
      ensureNurseryModuleController().evaluationEnabledForParents.value;

  int get _kidTabCount => _showEvaluationTab ? 6 : 5;

  @override
  void initState() {
    super.initState();
    _syncTabController();
    ever(
      ensureNurseryModuleController().evaluationEnabledForParents,
      (_) {
        if (!mounted || widget.galleryOnly) return;
        _syncTabController();
        setState(() {});
      },
    );
    Future.delayed(Duration.zero, () async {
      if (!mounted) return;
      controller.clearKidsScreenData();
      await controller.parentGetBySlug(context);
      if (!mounted) return;
      if (controller.parent.value?.students?.isNotEmpty == true) {
        final students = controller.parent.value!.students!;
        final targetSlug = _resolveInitialStudentSlug(students);
        _selectedKidIndex = _findStudentIndexBySlug(
          students,
          targetSlug,
        ).clamp(0, students.length - 1);
        final slug = students[_selectedKidIndex].studentSlug ?? "";
        await controller.fetchStudentsBySlug(context, slug);
        if (!mounted) return;
        await controller.studentDetailsBySlug(context, slug,
            date: _formatDate(_selectedDate));
        if (_showEvaluationTab) {
          await controller.fetchEvaluationForms(context, studentSlug: slug);
        }
        await controller.fetchMedicalReports(context, studentSlug: slug);
      }
    });
  }

  @override
  void didUpdateWidget(covariant KidsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.galleryOnly != widget.galleryOnly ||
        oldWidget.initialTabIndex != widget.initialTabIndex) {
      _syncTabController();
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _syncTabController() {
    if (widget.galleryOnly) {
      _tabController?.dispose();
      _tabController = null;
      _galleryTabController = TabController(length: 3, vsync: this);
      return;
    }

    final clampedIndex = widget.initialTabIndex.clamp(0, _kidTabCount - 1);
    final needsRebuild =
        _tabController == null || _tabController!.length != _kidTabCount;

    if (needsRebuild) {
      _tabController?.dispose();
      _tabController = TabController(
        length: _kidTabCount,
        vsync: this,
        initialIndex: clampedIndex,
      );
      return;
    }

    if (_tabController!.index != clampedIndex) {
      _tabController!.index = clampedIndex;
    }
  }

  String _formatDate(DateTime date) => ReportTimeUtils.todayIso(date);

  Future<void> _openReportCalendar() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: _minDate,
      lastDate: _maxDate,
      builder: buildAppDatePickerThemeBuilder(
        context,
        primaryColor: primaryColor,
      ),
    );

    if (picked == null) return;
    _applySelectedDate(picked);
  }

  void _applySelectedDate(DateTime date) {
    final next = ReportTimeUtils.dateOnly(date);
    if (ReportTimeUtils.isSameDay(next, _selectedDate)) return;
    setState(() => _selectedDate = next);
    _reloadReportForSelectedStudent();
  }

  String _resolveInitialStudentSlug(List<dynamic> students) {
    final requestedIdentifier = widget.initialStudentSlug?.trim() ?? '';
    if (requestedIdentifier.isEmpty) {
      return students.first.studentSlug ?? '';
    }

    final matchedIndex = _findStudentIndexBySlug(
      students,
      requestedIdentifier,
    );
    if (matchedIndex >= 0 && matchedIndex < students.length) {
      return students[matchedIndex].studentSlug ?? '';
    }

    return requestedIdentifier;
  }

  int _findStudentIndexBySlug(List<dynamic> students, String slug) {
    if (slug.isEmpty) return 0;

    final index = students.indexWhere(
      (student) =>
          (student.studentSlug ?? '').trim() == slug ||
          (student.studentId ?? '').trim() == slug ||
          (student.id ?? '').trim() == slug,
    );
    return index >= 0 ? index : 0;
  }

  String _displayDate(DateTime date) {
    final month = DateFormat.MMMM(Get.locale?.languageCode).format(date);
    return '${date.day}-$month';
  }

  String _monthName(int month) {
    final date = DateTime(2020, month); // dummy year
    return DateFormat.MMM(Get.locale?.languageCode).format(date);
  }

  Future<void> _loadStudentDetails(String slug) async {
    if (slug.isEmpty) return;

    await controller.fetchStudentsBySlug(context, slug);
    if (!mounted) return;

    controller.studentDetailsBySlug(
      context,
      slug,
      date: _formatDate(_selectedDate),
    );
    if (_showEvaluationTab) {
      controller.fetchEvaluationForms(context, studentSlug: slug);
    }
    controller.fetchMedicalReports(context, studentSlug: slug);
  }

  void _reloadReportForSelectedStudent() {
    final students = controller.parent.value?.students ?? [];

    if (students.isEmpty || _selectedKidIndex >= students.length) return;

    final slug = students[_selectedKidIndex].studentSlug ?? '';
    if (slug.isEmpty) return;

    controller.studentDetailsBySlug(
      context,
      slug,
      date: _formatDate(_selectedDate),
    );
  }

  void _reloadEvaluationForSelectedStudent() {
    final students = controller.parent.value?.students ?? [];

    if (students.isEmpty || _selectedKidIndex >= students.length) return;

    final slug = students[_selectedKidIndex].studentSlug ?? '';
    if (slug.isEmpty || !_showEvaluationTab) return;

    controller.fetchEvaluationForms(
      context,
      studentSlug: slug,
    );
  }

  void _reloadMedicalReportsForSelectedStudent() {
    final students = controller.parent.value?.students ?? [];

    if (students.isEmpty || _selectedKidIndex >= students.length) return;

    final slug = students[_selectedKidIndex].studentSlug ?? '';
    if (slug.isEmpty) return;

    controller.fetchMedicalReports(
      context,
      studentSlug: slug,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildKidsHeader(),
              Expanded(
                child: widget.galleryOnly
                    ? _buildGalleryTab()
                    : Column(
                        children: [
                          _buildTabBar(),
                          Expanded(
                            child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: _tabController,
                              children: [
                                _buildActivityTab(),
                                if (_showEvaluationTab) _buildEvaluationTab(),
                                _buildMedicalReportsTab(),
                                _buildInfoTab(),
                                _buildFeeTab(),
                                _buildCalendarTab(),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKidsHeader() {
    return Obx(() {
      final students = controller.parent.value?.students ?? [];
      if (controller.isLoading.value) {
        return const SizedBox(
            height: 80, child: Center(child: CircularProgressIndicator()));
      }
      if (students.isEmpty) {
        return SizedBox(
            height: 80, child: Center(child: Text("No Students Found".tr)));
      }
      return Container(
        color: pageBg(context),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(students.length, (index) {
              final student = students[index];
              final isSelected = index == _selectedKidIndex;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedKidIndex = index);
                  _loadStudentDetails(student.studentSlug ?? "");
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                isSelected ? primaryColor : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                        child: ProfileAvatar(
                          radius: 28,
                          imageUrl: student.profileLink,
                          backgroundColor: Colors.grey.shade300,
                          iconColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      MyRegularText(
                          label: student.name ?? "",
                          fontSize: 12,
                          color: primaryText(context)),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      );
    });
  }

  Widget _buildTabBar() {
    return Container(
      color: pageBg(context),
      child: TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: EdgeInsets.zero,
        labelPadding: const EdgeInsets.symmetric(horizontal: 12),
        controller: _tabController,
        indicatorColor: primaryColor,
        indicatorWeight: 2.5,
        labelColor: primaryColor,
        unselectedLabelColor: secondaryText(context),
        labelStyle: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.5),
        unselectedLabelStyle:
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        dividerColor: Colors.transparent,
        tabs: [
          Tab(text: 'tab_activity'.tr),
          if (_showEvaluationTab) Tab(text: 'tab_evaluation'.tr),
          Tab(text: 'medical_reports'.tr),
          Tab(text: 'tab_info'.tr),
          Tab(text: 'tab_fee'.tr),
          Tab(text: 'kids_tab_calender'.tr),
        ],
      ),
    );
  }

  String getInstallmentText(String? value) {
    if (value == null || value.isEmpty) return '';

    if (value == 'registration_fees') {
      return 'registration_fees'.tr;
    }

    if (value.startsWith('Installment_')) {
      final number = value.split('_').last;
      return '${'installment'.tr} $number';
    }

    return value;
  }

  Widget _buildKidInfoCard(bool isEdit) {
    return Obx(() {
      final student = controller.studentInfoDetails.value;
      if (controller.isStudentDetailsLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (student == null) return const SizedBox();
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: cardBg(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderClr(context)),
        ),
        child: Row(
          children: [
            ProfileAvatar(
              radius: 26,
              imageUrl: student.profileLink,
              backgroundColor: Colors.grey.shade300,
              iconColor: Colors.white,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyRegularText(
                    label:
                        "${student.firstName ?? ""} ${student.lastName ?? ""}",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryText(context),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      MyRegularText(
                          label: "roll_no".tr,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: secondaryText(context)),
                      MyRegularText(
                          label: " : ${student.rollNo ?? ""}",
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: secondaryText(context)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  MyRegularText(
                      label: "${'Class'.tr} : ${student.className ?? ""}",
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: secondaryText(context)),
                ],
              ),
            ),
            if (isEdit)
              GestureDetector(
                onTap: () {
                  Get.to(
                      () => EditStudentScreen(slug: student.studentSlug ?? ''));
                },
                child: SvgPicture.asset('assets/svg/edit.svg',
                    height: 25,
                    colorFilter: ColorFilter.mode(
                        primaryText(context), BlendMode.srcIn)),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildActivityTab() {
    return Obx(() {
      final report = controller.ActiveReportDetails.value;
      final attendance = report?.attendance;
      final hasAttendanceData = (attendance?.checkIn?.isNotEmpty == true) ||
          (attendance?.checkOut?.isNotEmpty == true);
      final hasMood = report?.todaysMood?.mood?.isNotEmpty == true;
      final hasActivity = report?.activity?.isNotEmpty == true;
      final hasNap = report?.nap?.isNotEmpty == true;
      final hasMeal = report?.mealsAndSnacks?.isNotEmpty == true;
      final hasHygiene = report?.hygiene?.isNotEmpty == true;
      final hasNote = report?.note?.isNotEmpty == true;
      final hasAnyActivityData = hasAttendanceData ||
          hasMood ||
          hasActivity ||
          hasNap ||
          hasMeal ||
          hasHygiene ||
          hasNote;

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildKidInfoCard(false),
            const SizedBox(height: 16),
            _buildDateSelector(),
            const SizedBox(height: 16),
            if (!hasAnyActivityData) ...[
              const SizedBox(height: 24),
              Center(child: EmptyState())
            ] else ...[
              _buildAttendanceCard(),
              if (hasMood) ...[
                const SizedBox(height: 16),
                Divider(color: dividerClr(context), height: 1),
                const SizedBox(height: 16),
                _buildMoodCard(report),
              ],
              if (hasActivity) ...[
                const SizedBox(height: 16),
                Divider(color: dividerClr(context), height: 1),
                const SizedBox(height: 16),
                _buildActivitySection(report),
              ],
              if (hasNap) ...[
                const SizedBox(height: 16),
                Divider(color: dividerClr(context), height: 1),
                const SizedBox(height: 16),
                _buildNapSection(report),
              ],
              if (hasMeal) ...[
                const SizedBox(height: 16),
                Divider(color: dividerClr(context), height: 1),
                const SizedBox(height: 16),
                _buildMealSection(report),
              ],
              if (hasHygiene) ...[
                const SizedBox(height: 16),
                Divider(color: dividerClr(context), height: 1),
                const SizedBox(height: 16),
                _buildHygieneSection(report),
              ],
              if (hasNote) ...[
                const SizedBox(height: 16),
                Divider(color: dividerClr(context), height: 1),
                const SizedBox(height: 16),
                _buildNoteSection(report),
              ],
              const SizedBox(height: 24),
              _buildDownloadButton(),
            ],
            const SizedBox(height: 24),
          ],
        ),
      );
    });
  }

  Widget _buildDateSelector() {
    final light = isLight(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              final newDate = DateTime(
                _selectedDate.year,
                _selectedDate.month,
                _selectedDate.day - 1,
              );

              if (newDate.isBefore(_minDate)) return;
              _applySelectedDate(newDate);
            },
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderClr(context), width: 1)),
              child: Icon(Icons.arrow_back_rounded,
                  color: light ? Colors.black : Colors.white, size: 20),
            ),
          ),
          GestureDetector(
            onTap: _openReportCalendar,
            child: Column(
            children: [
              MyRegularText(
                  label: _displayDate(_selectedDate),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: primaryText(context)),
              MyRegularText(
                  label: _selectedDate.year.toString(),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: secondaryText(context)),
            ],
          ),
          ),
          GestureDetector(
            onTap: () {
              final newDate = DateTime(
                _selectedDate.year,
                _selectedDate.month,
                _selectedDate.day + 1,
              );

              if (newDate.isAfter(_maxDate)) return;
              _applySelectedDate(newDate);
            },
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderClr(context), width: 1)),
              child: Icon(Icons.arrow_forward,
                  color: light ? Colors.black : Colors.white, size: 20),
            ),
          ),
          GestureDetector(
            onTap: _openReportCalendar,
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderClr(context), width: 1)),
              child: Icon(Icons.calendar_month_outlined,
                  color: light ? Colors.black : Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard() {
    return Obx(() {
      final report = controller.ActiveReportDetails.value;
      final attendance = report?.attendance;

      final checkIn = attendance?.checkIn ?? '';
      final checkOut = attendance?.checkOut ?? '';

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyRegularText(
              label: 'attendance'.tr,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: primaryText(context),
            ),
            const SizedBox(height: 16),

            /// ✅ Check In
            _buildAttendanceRow(
              'check_in'.tr,
              _formatAttendanceDateTime(checkIn),
              Colors.green,
            ),

            const SizedBox(height: 12),

            /// ✅ Check Out
            _buildAttendanceRow(
              'check_out'.tr,
              _formatAttendanceDateTime(checkOut),
              Colors.red,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAttendanceRow(String label, String time, Color dotColor) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 3),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: dotColor, width: 2.5),
                  ),
                ),
                const SizedBox(width: 8),
                MyRegularText(
                    fontWeight: FontWeight.w500,
                    label: time,
                    fontSize: 12,
                    color: secondaryText(context)),
              ],
            ),
            const SizedBox(height: 4),
            MyRegularText(
                label: label,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: primaryText(context)),
          ],
        ),
      ],
    );
  }

  String _formatAttendanceDateTime(String? value) {
    final time = value?.trim() ?? '';
    if (time.isEmpty) return 'No Data';

    try {
      final local = DateTime.parse(time).toLocal();
      final formattedTime = DateFormat('hh:mm a').format(local);
      return '${DateFormat('dd-MMM-yyyy').format(local)} at $formattedTime';
    } catch (e) {
      return time;
    }
  }

  // Mood — exact same layout as commented _buildMoodCard(), first mood from API
  final Map<String, String> moodImages = {
    'happy': 'assets/png/happy.png',
    'confused': 'assets/png/confused.png',
    'cool': 'assets/png/cool.png',
    'amazed': 'assets/png/amazed.png',
    'stressed': 'assets/png/stressed.png',
    'peaceful': 'assets/png/peaceful.png',
  };

  String _moodImage(String mood) {
    return moodImages[ReportDisplayUtils.moodKey(mood)] ?? moodImages['happy']!;
  }

  Widget _buildMoodCard(StudentReportDetailsData? report) {
    final moods = report?.todaysMood?.mood ?? [];
    if (moods.isEmpty) return const SizedBox();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyRegularText(
            label: 'mood'.tr,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: primaryText(context),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: moods.map((moodLabel) {
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: isLight(context)
                          ? const Color(0xFFCFD7EA)
                          : const Color(0xFF2A3A5A),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        _moodImage(moodLabel),
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  MyRegularText(
                    label: ReportDisplayUtils.moodLabel(moodLabel),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: primaryText(context),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySection(StudentReportDetailsData? report) {
    final activities = report?.activity ?? [];
    if (activities.isEmpty) return const SizedBox();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyRegularText(
              label: 'activity'.tr,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: primaryText(context)),
          const SizedBox(height: 16),
          ...activities.map((a) => _buildActivityItem(
              ReportDisplayUtils.activityLabel(
                a.activityType?.isNotEmpty == true
                    ? a.activityType
                    : a.description,
              ),
              a.startTime ?? '')),
        ],
      ),
    );
  }

  String _formatDateTimeWithAt(String time) {
    final date = DateFormat('dd-MMM-yyyy').format(_selectedDate);
    final trimmed = time.trim();
    if (trimmed.isEmpty) return date;
    return '$date at $trimmed';
  }

  Widget _buildActivityItem(String title, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 2.5),
                ),
              ),
              const SizedBox(width: 8),
              MyRegularText(
                  fontWeight: FontWeight.w500,
                  label: _formatDateTimeWithAt(time),
                  fontSize: 12,
                  color: secondaryText(context)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              SvgPicture.asset(
                'assets/svg/candle.svg',
                colorFilter:
                    ColorFilter.mode(primaryText(context), BlendMode.srcIn),
              ),
              const SizedBox(width: 8),
              MyRegularText(
                  label: title,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: primaryText(context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNapSection(StudentReportDetailsData? report) {
    final naps = report?.nap ?? [];
    if (naps.isEmpty) return const SizedBox();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyRegularText(
              label: 'nap'.tr,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: primaryText(context)),
          const SizedBox(height: 16),
          ...naps.map((n) => _buildNapItem(
              'nap'.tr, "${n.startTime ?? ''} — ${n.endTime ?? ''}")),
        ],
      ),
    );
  }

  Widget _buildNapItem(String title, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 2.5),
                ),
              ),
              const SizedBox(width: 8),
              MyRegularText(
                  fontWeight: FontWeight.w500,
                  label: time,
                  fontSize: 12,
                  color: secondaryText(context)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              SvgPicture.asset(
                'assets/svg/sleep.svg',
                colorFilter:
                    ColorFilter.mode(primaryText(context), BlendMode.srcIn),
              ),
              const SizedBox(width: 8),
              MyRegularText(
                  label: title,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: primaryText(context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMealSection(StudentReportDetailsData? report) {
    final meals = report?.mealsAndSnacks ?? [];
    if (meals.isEmpty) return const SizedBox();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyRegularText(
              label: 'meal'.tr,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: primaryText(context)),
          const SizedBox(height: 16),
          ...meals.map((m) => _buildMealItem(
                ReportDisplayUtils.mealLine(m.mealName, portion: m.portion),
                m.time ?? '',
              )),
        ],
      ),
    );
  }

  Widget _buildMealItem(String title, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 2.5),
                ),
              ),
              const SizedBox(width: 8),
              MyRegularText(
                  fontWeight: FontWeight.w500,
                  label: _formatDateTimeWithAt(time),
                  fontSize: 12,
                  color: secondaryText(context)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              SvgPicture.asset(
                'assets/svg/snoop.svg',
                colorFilter:
                    ColorFilter.mode(primaryText(context), BlendMode.srcIn),
              ),
              const SizedBox(width: 8),
              MyRegularText(
                  label: title,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: primaryText(context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHygieneSection(StudentReportDetailsData? report) {
    final hygieneList = report?.hygiene ?? [];
    if (hygieneList.isEmpty) return const SizedBox();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyRegularText(
              label: 'hygiene'.tr,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: primaryText(context)),
          const SizedBox(height: 16),
          ...hygieneList.map((h) => _buildHygieneItem(
              ReportDisplayUtils.hygieneLabel(h.hygieneType ?? h.description),
              h.time ?? '')),
        ],
      ),
    );
  }

  Widget _buildHygieneItem(String title, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 2.5),
                ),
              ),
              const SizedBox(width: 8),
              MyRegularText(
                  fontWeight: FontWeight.w500,
                  label: _formatDateTimeWithAt(time),
                  fontSize: 12,
                  color: secondaryText(context)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              SvgPicture.asset(
                'assets/svg/handwash.svg',
                colorFilter:
                    ColorFilter.mode(primaryText(context), BlendMode.srcIn),
              ),
              const SizedBox(width: 8),
              MyRegularText(
                  label: title,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: primaryText(context)),
            ],
          ),
        ],
      ),
    );
  }

  // Note — exact same layout as commented _buildNoteSection(), first note from API
  Widget _buildNoteSection(StudentReportDetailsData? report) {
    final notes = report?.note ?? [];
    if (notes.isEmpty) return const SizedBox();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyRegularText(
              label: 'note'.tr,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: primaryText(context)),
          const SizedBox(height: 12),
          ...notes.map(
            (note) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: MyRegularText(
                label: note.content ?? '',
                fontSize: 13,
                color: secondaryText(context),
                maxlines: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _openDailyReportActions,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: MyRegularText(
            label: 'view_report'.tr,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white),
      ),
    );
  }

  Future<void> _openDailyReportActions() async {
    final report = controller.ActiveReportDetails.value;
    final student = controller.studentInfoDetails.value;

    if (report == null || student == null) {
      showAppSnackbar('Error'.tr, 'No data available'.tr);
      return;
    }

    final action = await showViewOrDownloadSheet(title: 'view_report'.tr);
    if (action == null) return;

    if (action == FileOpenAction.view) {
      await _viewDailyReport(report, student);
      return;
    }

    await _downloadDailyReport(report, student);
  }

  Future<void> _viewDailyReport(dynamic report, dynamic student) async {
    final link = (report.reportPdfLink as String?)?.trim() ?? '';
    if (link.isNotEmpty) {
      await openInAppPdf(
        url: link,
        title: 'view_report'.tr,
        fileName: _buildDailyReportFileName(student),
      );
      return;
    }

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    try {
      final bytes = await _buildReportPdfBytes(report, student);
      if (Get.isDialogOpen ?? false) Get.back();
      await openInAppPdf(
        bytes: bytes,
        title: 'view_report'.tr,
        fileName: _buildDailyReportFileName(student),
      );
    } catch (_) {
      if (Get.isDialogOpen ?? false) Get.back();
      showAppSnackbar('Error'.tr, 'failed_to_load_pdf'.tr);
    }
  }

  Future<void> _downloadDailyReport(dynamic report, dynamic student) async {
    final fileName = _buildDailyReportFileName(student);
    final link = (report.reportPdfLink as String?)?.trim() ?? '';
    if (link.isNotEmpty) {
      await ProtectedFileDownloader.savePdf(url: link, fileName: fileName);
      return;
    }

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    try {
      final bytes = await _buildReportPdfBytes(report, student);
      if (Get.isDialogOpen ?? false) Get.back();
      await ProtectedFileDownloader.savePdf(bytes: bytes, fileName: fileName);
    } catch (_) {
      if (Get.isDialogOpen ?? false) Get.back();
      showAppSnackbar('Error'.tr, 'failed_to_load_pdf'.tr);
    }
  }

  String _buildDailyReportFileName(dynamic student) {
    return _buildReportFileName(
      student.firstName,
      student.lastName,
      _selectedDate,
    );
  }

  Future<Uint8List> _buildReportPdfBytes(
    StudentReportDetailsData report,
    dynamic student,
  ) async {
    final pdf = pw.Document();
    final isRtl = Get.locale?.languageCode == 'ar';
    final pw.Font baseFont = await PdfGoogleFonts.notoNaskhArabicRegular();
    final pw.Font boldFont = await PdfGoogleFonts.notoNaskhArabicBold();
    final theme = pw.ThemeData.withFont(base: baseFont, bold: boldFont);
    String _safe(String? v) =>
        (v == null || v.trim().isEmpty) ? 'No Data'.tr : v;
    List<T> _maybeReverse<T>(List<T> list) =>
        isRtl ? list.reversed.toList() : list;
    String _formatHygienePdf(String value) =>
        ReportDisplayUtils.hygieneLabel(value);
    String _formatActivityPdf(String value) =>
        ReportDisplayUtils.activityLabel(value);
    String _formatMoodPdf(String value) => ReportDisplayUtils.moodLabel(value);
    pw.Text _pdfText(String text, {pw.TextStyle? style}) {
      return pw.Text(
        text,
        style: style,
        textDirection: isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
        textAlign: isRtl ? pw.TextAlign.right : pw.TextAlign.left,
      );
    }

    pw.Widget sectionTitle(String title) {
      return pw.Padding(
        padding: const pw.EdgeInsets.only(top: 16, bottom: 8),
        child: pw.Text(
          title,
          textDirection: isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
          textAlign: isRtl ? pw.TextAlign.right : pw.TextAlign.left,
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blueGrey800,
          ),
        ),
      );
    }

    pw.Widget infoRow(String label, String value) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(
          children: _maybeReverse([
            pw.Expanded(
              flex: 2,
              child: pw.Text(
                label,
                textDirection:
                    isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
                textAlign: isRtl ? pw.TextAlign.right : pw.TextAlign.left,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Expanded(
              flex: 3,
              child: pw.Text(
                value,
                textDirection:
                    isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
                textAlign: isRtl ? pw.TextAlign.right : pw.TextAlign.left,
              ),
            ),
          ]),
        ),
      );
    }

    pw.Widget buildTable(List<List<String>> data, List<String> headers) {
      return pw.TableHelper.fromTextArray(
        headers: _maybeReverse(headers),
        data: data.map(_maybeReverse).toList(),
        headerStyle: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
        ),
        headerDirection: isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
        tableDirection: isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
        headerAlignment:
            isRtl ? pw.Alignment.centerRight : pw.Alignment.centerLeft,
        cellAlignment:
            isRtl ? pw.Alignment.centerRight : pw.Alignment.centerLeft,
        headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey600),
        cellPadding: const pw.EdgeInsets.all(6),
        border: pw.TableBorder.all(color: PdfColors.grey300),
      );
    }

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(20),
        theme: theme,
        textDirection: isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
        build: (context) => [
          /// HEADER
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.blueGrey50,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: isRtl
                  ? pw.CrossAxisAlignment.end
                  : pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'student_activity_report'.tr,
                  textDirection:
                      isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
                  textAlign: isRtl ? pw.TextAlign.right : pw.TextAlign.left,
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                infoRow('report_date'.tr,
                    DateFormat('dd-MMM-yyyy').format(_selectedDate)),
                infoRow('Name'.tr,
                    "${student.firstName ?? ''} ${student.lastName ?? ''}"),
                infoRow('roll_no'.tr, _safe(student.rollNo)),
                infoRow('Class'.tr, _safe(student.className)),
              ],
            ),
          ),

          /// ATTENDANCE
          sectionTitle('attendance'.tr),
          buildTable([
            [
              _formatAttendanceDateTime(report.attendance?.checkIn),
              _formatAttendanceDateTime(report.attendance?.checkOut),
            ]
          ], [
            'check_in'.tr,
            'check_out'.tr
          ]),

          /// MOOD
          if (report.todaysMood?.mood?.isNotEmpty == true) ...[
            sectionTitle('mood'.tr),
            _pdfText(
              report.todaysMood!.mood!
                  .map(_formatMoodPdf)
                  .join(isRtl ? '، ' : ', '),
            ),
          ],

          /// ACTIVITIES
          if (report.activity?.isNotEmpty == true) ...[
            sectionTitle('activities'.tr),
            buildTable(
              report.activity!
                  .map((a) => [
                        _formatActivityPdf(_safe(a.activityType)),
                        _safe(a.startTime),
                        _safe(a.endTime),
                        _safe(a.description),
                      ])
                  .toList(),
              ['type'.tr, 'start_time'.tr, 'end_time'.tr, 'description'.tr],
            ),
          ],

          /// NAP
          if (report.nap?.isNotEmpty == true) ...[
            sectionTitle('nap'.tr),
            buildTable(
              report.nap!
                  .map((n) => [
                        _safe(n.startTime),
                        _safe(n.endTime),
                      ])
                  .toList(),
              ['start_time'.tr, 'end_time'.tr],
            ),
          ],

          /// MEALS
          if (report.mealsAndSnacks?.isNotEmpty == true) ...[
            sectionTitle('meal'.tr),
            buildTable(
              report.mealsAndSnacks!
                  .map((m) => [
                        ReportDisplayUtils.mealLine(
                          m.mealName,
                          portion: m.portion,
                        ),
                        _safe(m.time),
                      ])
                  .toList(),
              ['meal'.tr, 'time'.tr],
            ),
          ],

          /// HYGIENE
          if (report.hygiene?.isNotEmpty == true) ...[
            sectionTitle('hygiene'.tr),
            buildTable(
              report.hygiene!
                  .map((h) => [
                        _formatHygienePdf(_safe(h.hygieneType ?? h.description)),
                        _safe(h.time),
                      ])
                  .toList(),
              ['type'.tr, 'time'.tr],
            ),
          ],

          /// NOTES
          if (report.note?.isNotEmpty == true) ...[
            sectionTitle('notes'.tr),
            ...report.note!.map(
              (n) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 4),
                child: pw.Bullet(
                  text: _safe(n.content),
                ),
              ),
            ),
          ],
        ],
      ),
    );

    return pdf.save();
  }

  String _buildReportFileName(
    String? firstName,
    String? lastName,
    DateTime date,
  ) {
    final name = '${firstName ?? ''} ${lastName ?? ''}'.trim();
    final safeName = name.isEmpty
        ? 'student'
        : name.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_');
    final dateStamp = DateFormat('yyyyMMdd').format(date);
    return 'Student_Report_${safeName}_$dateStamp.pdf';
  }

  Future<String?> _savePdfToFile(Uint8List bytes, String fileName) async {
    try {
      final directory = await _resolveDownloadDirectory();
      await directory.create(recursive: true);

      final file = await _buildUniqueFile(directory, fileName);
      await file.writeAsBytes(bytes, flush: true);
      print("SAVED FILE: ${file.path}");
      return file.path;
    } catch (e) {
      print("SAVE ERROR: $e");
      showAppSnackbar("Error".tr, "Failed to save report".tr);
      return null;
    }
  }

  Widget _buildEvaluationTab() {
    return Obx(() {
      if (controller.isEvaluationFormsLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return RefreshIndicator(
        onRefresh: () async => _reloadEvaluationForSelectedStudent(),
        child: ListView(
          padding: const EdgeInsets.only(top: 16, bottom: 24),
          children: [
            _buildKidInfoCard(false),
            const SizedBox(height: 16),
            _buildEvaluationSearchRow(),
            if (_showEvaluationDateFilter) ...[
              const SizedBox(height: 12),
              _buildEvaluationDateFilterCard(),
            ],
            const SizedBox(height: 16),
            if (controller.evaluationForms.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 48),
                child: Column(
                  children: [
                    const Center(child: EmptyState()),
                  ],
                ),
              )
            else
              ...controller.evaluationForms
                  .map((form) => _buildEvaluationFormCard(form)),
          ],
        ),
      );
    });
  }

  Widget _buildEvaluationSearchRow() {
    final light = isLight(context);

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller.evaluationFormsSearchController,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _reloadEvaluationForSelectedStudent(),
            decoration: InputDecoration(
              hintText: 'search_evolution'.tr,
              filled: true,
              fillColor: light ? Colors.white : const Color(0xFF1A1A1A),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: InkWell(
                onTap: _reloadEvaluationForSelectedStudent,
                child: const Icon(Icons.search_rounded),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: borderClr(context)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: borderClr(context)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: primaryColor),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            if (_showEvaluationDateFilter) {
              controller.evaluationFormsStartDate.value = null;
              controller.evaluationFormsEndDate.value = null;
              setState(() => _showEvaluationDateFilter = false);
              _reloadEvaluationForSelectedStudent();
              return;
            }

            setState(() => _showEvaluationDateFilter = true);
          },
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _showEvaluationDateFilter
                  ? primaryColor.withOpacity(light ? 0.10 : 0.20)
                  : (light ? Colors.white : const Color(0xFF1A1A1A)),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _showEvaluationDateFilter
                    ? primaryColor
                    : borderClr(context),
              ),
            ),
            child: Icon(
              Icons.calendar_month_outlined,
              color: _showEvaluationDateFilter
                  ? primaryColor
                  : (light ? Colors.black87 : Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEvaluationDateFilterCard() {
    final light = isLight(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: light ? Colors.white : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderClr(context)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.date_range_outlined, size: 18),
              const SizedBox(width: 8),
              MyRegularText(
                label: 'evaluation_date_range'.tr,
                fontWeight: FontWeight.w600,
                color: primaryText(context),
              ),
              const Spacer(),
              if (controller.evaluationFormsStartDate.value != null ||
                  controller.evaluationFormsEndDate.value != null)
                Text(
                  '${controller.displayDate(controller.evaluationFormsStartDate.value)} - ${controller.displayDate(controller.evaluationFormsEndDate.value)}',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: secondaryText(context),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildEvaluationDateField(
                  label: 'start_date'.tr,
                  value: controller
                      .displayDate(controller.evaluationFormsStartDate.value),
                  onTap: () => _pickEvaluationDate(isStart: true),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildEvaluationDateField(
                  label: 'end_date'.tr,
                  value: controller
                      .displayDate(controller.evaluationFormsEndDate.value),
                  onTap: () => _pickEvaluationDate(isStart: false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEvaluationDateField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    final light = isLight(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: light ? const Color(0xFFF8FAFC) : const Color(0xFF151515),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderClr(context)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 11, color: secondaryText(context)),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: primaryText(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickEvaluationDate({required bool isStart}) async {
    if (!isStart && controller.evaluationFormsStartDate.value == null) {
      showAppSnackbar('Error'.tr, 'please_select_start_date_first'.tr);
      return;
    }

    final initialDate = isStart
        ? (controller.evaluationFormsStartDate.value ?? DateTime.now())
        : (controller.evaluationFormsEndDate.value ??
            controller.evaluationFormsStartDate.value ??
            DateTime.now());
    final firstDate = isStart
        ? DateTime(2020)
        : controller.evaluationFormsStartDate.value ?? DateTime(2020);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now(),
      builder: buildAppDatePickerThemeBuilder(
        context,
        primaryColor: primaryColor,
      ),
    );

    if (picked == null) return;

    if (isStart) {
      controller.evaluationFormsStartDate.value = picked;
      if (controller.evaluationFormsEndDate.value != null &&
          controller.evaluationFormsEndDate.value!.isBefore(picked)) {
        controller.evaluationFormsEndDate.value = picked;
      }
    } else {
      controller.evaluationFormsEndDate.value = picked;
    }

    _reloadEvaluationForSelectedStudent();
  }

  Widget _buildMedicalReportsTab() {
    return Obx(() {
      if (controller.isMedicalReportsLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return RefreshIndicator(
        onRefresh: () async => _reloadMedicalReportsForSelectedStudent(),
        child: ListView(
          padding: const EdgeInsets.only(top: 16, bottom: 24),
          children: [
            _buildKidInfoCard(false),
            const SizedBox(height: 16),
            _buildMedicalReportsSearchRow(),
            if (_showMedicalDateFilter) ...[
              const SizedBox(height: 12),
              _buildMedicalDateFilterCard(),
            ],
            const SizedBox(height: 16),
            if (controller.medicalReports.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 48),
                child: Column(
                  children: const [
                    Center(child: EmptyState()),
                  ],
                ),
              )
            else
              ...controller.medicalReports
                  .map((report) => _buildMedicalReportCard(report)),
          ],
        ),
      );
    });
  }

  Widget _buildMedicalReportsSearchRow() {
    final light = isLight(context);

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller.medicalReportsSearchController,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _reloadMedicalReportsForSelectedStudent(),
            decoration: InputDecoration(
              hintText: 'search_medical_reports'.tr,
              filled: true,
              fillColor: light ? Colors.white : const Color(0xFF1A1A1A),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: InkWell(
                onTap: _reloadMedicalReportsForSelectedStudent,
                child: const Icon(Icons.search_rounded),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: borderClr(context)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: borderClr(context)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: primaryColor),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            if (_showMedicalDateFilter) {
              controller.medicalReportsStartDate.value = null;
              controller.medicalReportsEndDate.value = null;
              setState(() => _showMedicalDateFilter = false);
              _reloadMedicalReportsForSelectedStudent();
              return;
            }

            setState(() => _showMedicalDateFilter = true);
          },
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _showMedicalDateFilter
                  ? primaryColor.withOpacity(light ? 0.10 : 0.20)
                  : (light ? Colors.white : const Color(0xFF1A1A1A)),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color:
                    _showMedicalDateFilter ? primaryColor : borderClr(context),
              ),
            ),
            child: Icon(
              Icons.calendar_month_outlined,
              color: _showMedicalDateFilter
                  ? primaryColor
                  : (light ? Colors.black87 : Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicalDateFilterCard() {
    final light = isLight(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: light ? Colors.white : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderClr(context)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.date_range_outlined, size: 18),
              const SizedBox(width: 8),
              MyRegularText(
                label: 'medical_date_range'.tr,
                fontWeight: FontWeight.w600,
                color: primaryText(context),
              ),
              const Spacer(),
              if (controller.medicalReportsStartDate.value != null ||
                  controller.medicalReportsEndDate.value != null)
                MyRegularText(
                  label:
                      '${controller.displayDate(controller.medicalReportsStartDate.value)} - ${controller.displayDate(controller.medicalReportsEndDate.value)}',
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: secondaryText(context),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildEvaluationDateField(
                  label: 'start_date'.tr,
                  value: controller
                      .displayDate(controller.medicalReportsStartDate.value),
                  onTap: () => _pickMedicalReportDate(isStart: true),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildEvaluationDateField(
                  label: 'end_date'.tr,
                  value: controller
                      .displayDate(controller.medicalReportsEndDate.value),
                  onTap: () => _pickMedicalReportDate(isStart: false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickMedicalReportDate({required bool isStart}) async {
    if (!isStart && controller.medicalReportsStartDate.value == null) {
      showAppSnackbar('Error'.tr, 'please_select_start_date_first'.tr);
      return;
    }

    final initialDate = isStart
        ? (controller.medicalReportsStartDate.value ?? DateTime.now())
        : (controller.medicalReportsEndDate.value ??
            controller.medicalReportsStartDate.value ??
            DateTime.now());
    final firstDate = isStart
        ? DateTime(2020)
        : controller.medicalReportsStartDate.value ?? DateTime(2020);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now(),
      builder: buildAppDatePickerThemeBuilder(
        context,
        primaryColor: primaryColor,
      ),
    );

    if (picked == null) return;

    if (isStart) {
      controller.medicalReportsStartDate.value = picked;
      if (controller.medicalReportsEndDate.value != null &&
          controller.medicalReportsEndDate.value!.isBefore(picked)) {
        controller.medicalReportsEndDate.value = picked;
      }
    } else {
      controller.medicalReportsEndDate.value = picked;
    }

    _reloadMedicalReportsForSelectedStudent();
  }

  Widget _buildMedicalReportCard(report) {
    final light = isLight(context);
    final title = report.title ?? 'medical_report'.tr;
    final reportDate =
        _formatMedicalDateTime(report.reportDate ?? report.createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderClr(context)),
        boxShadow: light
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyRegularText(
                      label: title,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: primaryText(context),
                      align: TextAlign.start,
                    ),
                    if (reportDate != null) ...[
                      const SizedBox(height: 6),
                      MyRegularText(
                        label: reportDate,
                        fontSize: 12,
                        color: secondaryText(context),
                        fontWeight: FontWeight.w500,
                        align: TextAlign.start,
                      ),
                    ],
                  ],
                ),
              ),
              _buildEvaluationMetaChip(
                icon: Icons.local_hospital_outlined,
                label: 'medical_report'.tr,
              ),
            ],
          ),
          const SizedBox(height: 14),
          if ((report.nurseName ?? '').isNotEmpty)
            _buildInfoSection('nurse_name'.tr, report.nurseName),
          if ((report.parentName ?? '').isNotEmpty)
            _buildInfoSection('parent_name'.tr, report.parentName),
          if ((report.className ?? '').isNotEmpty)
            _buildInfoSection('class_name'.tr, report.className),
          if ((report.rollNumber ?? '').isNotEmpty)
            _buildInfoSection('roll_no'.tr, report.rollNumber),
          if ((report.reportText ?? '').isNotEmpty)
            _buildInfoSection(
              'description'.tr,
              report.reportText,
              stacked: true,
            ),
        ],
      ),
    );
  }

  String? _formatMedicalDateTime(DateTime? value) {
    if (value == null) return null;
    return DateFormat('dd/MM/yyyy hh:mm a').format(value.toLocal());
  }

  Widget _buildEvaluationFormCard(Evaluations form) {
    final light = isLight(context);
    final submittedAt = _formatEvaluationDateTime(form.submittedAt);
    final approvedAt = _formatEvaluationDateTime(form.approvedAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: light ? Colors.white : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderClr(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileAvatar(
                radius: 22,
                imageUrl: form.profileLink,
                backgroundColor: Colors.grey.shade300,
                iconColor: Colors.white,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      form.studentName ?? 'evaluation'.tr,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: primaryText(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${'evaluation_date'.tr} : ${form.evaluationDate ?? '-'}',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: secondaryText(context),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${'teacher_name'.tr} : ${form.teacherName ?? '-'}',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: secondaryText(context),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(light ? 0.10 : 0.20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  form.status ?? '-',
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildEvaluationMetaChip(
                icon: Icons.tag_outlined,
                label: '${'roll_no'.tr} : ${form.rollNumber ?? '-'}',
              ),
              _buildEvaluationMetaChip(
                icon: Icons.class_outlined,
                label: form.className ?? '-',
              ),
              _buildEvaluationMetaChip(
                icon: Icons.quiz_outlined,
                label: '${'answers_count'.tr} : ${form.answerCount ?? 0}',
              ),
            ],
          ),
          if ((form.teacherNote ?? '').isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              form.teacherNote ?? '',
              style: TextStyle(
                fontSize: 13,
                color: secondaryText(context),
                height: 1.4,
              ),
            ),
          ],
          if ((form.adminNote ?? '').isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    light ? const Color(0xFFF8FAFC) : const Color(0xFF151515),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'note'.tr,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    form.adminNote ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      color: secondaryText(context),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  submittedAt == null
                      ? ''
                      : '${'submitted_on'.tr} : $submittedAt',
                  style: TextStyle(
                    fontSize: 12,
                    color: secondaryText(context),
                  ),
                ),
              ),
              if (approvedAt != null && approvedAt.isNotEmpty)
                Text(
                  '${'approved_on'.tr} : $approvedAt',
                  style: TextStyle(
                    fontSize: 12,
                    color: secondaryText(context),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openEvaluationReportActions(form),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.visibility_rounded, color: Colors.white),
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
      ),
    );
  }

  Widget _buildEvaluationMetaChip({
    required IconData icon,
    required String label,
  }) {
    final light = isLight(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: light ? const Color(0xFFF8FAFC) : const Color(0xFF151515),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderClr(context)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: primaryColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primaryText(context),
            ),
          ),
        ],
      ),
    );
  }

  String? _formatEvaluationDateTime(String? value) {
    if (value == null || value.isEmpty) return null;
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    final local = parsed.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    final hour = (local.hour % 12 == 0 ? 12 : local.hour % 12)
        .toString()
        .padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';
    return '$day/$month/$year $hour:$minute $period';
  }

  Future<void> _openEvaluationReportActions(Evaluations form) async {
    await openDownloadableMedia(
      url: form.reportPdfLink,
      title: 'view_report'.tr,
      kind: DownloadableKind.pdf,
    );
  }

  Future<void> _openInvoicePdfLink(String? invoicePdfLink, Fee fee) async {
    final uri = Uri.tryParse(invoicePdfLink?.trim() ?? '');
    final fileName = uri == null
        ? 'invoice.pdf'
        : _buildInvoiceFileName(uri, fee);
    await openDownloadableMedia(
      url: invoicePdfLink,
      title: 'download_invoice'.tr,
      fileName: fileName,
      kind: DownloadableKind.pdf,
    );
  }

  String _buildEvaluationReportFileName(Uri uri) {
    final lastSegment =
        uri.pathSegments.isNotEmpty ? uri.pathSegments.last.trim() : '';
    final sanitized = lastSegment.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    if (sanitized.toLowerCase().endsWith('.pdf') && sanitized.isNotEmpty) {
      return sanitized;
    }

    return 'evaluation_report_${DateTime.now().millisecondsSinceEpoch}.pdf';
  }

  String _buildInvoiceFileName(Uri uri, Fee fee) {
    final lastSegment =
        uri.pathSegments.isNotEmpty ? uri.pathSegments.last.trim() : '';
    final sanitized = lastSegment.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    if (sanitized.toLowerCase().endsWith('.pdf') && sanitized.isNotEmpty) {
      return sanitized;
    }

    final installment = (fee.installment ?? 'invoice')
        .replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
    return '${installment}_invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';
  }

  Future<void> _openGalleryDocument(String url) async {
    await openDownloadableMedia(url: url);
  }

  String _buildGalleryDocumentFileName(Uri uri) {
    final fileName = _extractFileNameFromUrl(uri.toString());
    if (fileName.isNotEmpty) {
      return fileName;
    }

    return 'document_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> _downloadProtectedFile({
    required String? fileLink,
    required String Function(Uri uri) fileNameBuilder,
    required String invalidLinkMessage,
    required String successMessage,
    required String failureMessage,
    String acceptHeader = '*/*',
  }) async {
    if (fileLink == null || fileLink.trim().isEmpty) {
      showAppSnackbar('Error'.tr, invalidLinkMessage);
      return;
    }

    final loginResponse = await SessionHelper().getLoginResponse();
    final token = loginResponse?.data?.token;
    if (token == null || token.isEmpty) {
      showAppSnackbar('Error'.tr, invalidLinkMessage);
      return;
    }

    final uri = Uri.tryParse(fileLink.trim());
    if (uri == null) {
      showAppSnackbar('Error'.tr, invalidLinkMessage);
      return;
    }

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final directory = await _resolveDownloadDirectory();
      await directory.create(recursive: true);

      final file = await _buildUniqueFile(directory, fileNameBuilder(uri));

      await Dio().downloadUri(
        uri,
        file.path,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            'authorization': 'Bearer $token',
            'accept': acceptHeader,
          },
        ),
      );

      showToast(
        context,
        'Success',
        successMessage,
        type: ToastificationType.success,
      );
    } catch (e) {
      print('FILE DOWNLOAD ERROR: $e');
      showToast(
        context,
        'Error',
        failureMessage,
        type: ToastificationType.error,
      );
    } finally {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }

  Future<Directory> _resolveDownloadDirectory() async {
    if (Platform.isAndroid) {
      await _requestAndroidStoragePermission();

      final downloadDir = Directory('/storage/emulated/0/Download');
      if (await downloadDir.exists()) {
        return downloadDir;
      }

      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        return externalDir;
      }
    }

    if (Platform.isIOS) {
      return getApplicationDocumentsDirectory();
    }

    return getTemporaryDirectory();
  }

  Future<void> _requestAndroidStoragePermission() async {
    final storageStatus = await Permission.storage.request();
    if (storageStatus.isGranted) return;

    final photosStatus = await Permission.photos.request();
    if (photosStatus.isGranted || photosStatus.isLimited) return;

    final videosStatus = await Permission.videos.request();
    if (videosStatus.isGranted || videosStatus.isLimited) return;
  }

  Future<File> _buildUniqueFile(Directory directory, String fileName) async {
    final extensionIndex = fileName.lastIndexOf('.');
    final hasExtension = extensionIndex > 0;
    final namePart =
        hasExtension ? fileName.substring(0, extensionIndex) : fileName;
    final extension = hasExtension ? fileName.substring(extensionIndex) : '';

    var candidate = File('${directory.path}${Platform.pathSeparator}$fileName');
    var counter = 1;

    while (await candidate.exists()) {
      final nextName = '${namePart}_$counter$extension';
      candidate = File('${directory.path}${Platform.pathSeparator}$nextName');
      counter++;
    }

    return candidate;
  }

  String _extractFileNameFromUrl(String url) {
    final uri = Uri.tryParse(url);
    final lastSegment = uri?.pathSegments.isNotEmpty == true
        ? uri!.pathSegments.last
        : url.split('/').last;
    final decoded = Uri.decodeComponent(lastSegment).trim();
    final sanitized = decoded.replaceAll(RegExp(r'[^A-Za-z0-9._ -]'), '_');
    return sanitized.isEmpty ? 'Document' : sanitized;
  }

  String _fileExtension(String fileName) {
    final extensionIndex = fileName.lastIndexOf('.');
    if (extensionIndex == -1 || extensionIndex == fileName.length - 1) {
      return '';
    }

    return fileName.substring(extensionIndex + 1).toLowerCase();
  }

  IconData _documentIcon(String fileName) {
    switch (_fileExtension(fileName)) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'doc':
      case 'docx':
        return Icons.description_rounded;
      case 'xls':
      case 'xlsx':
      case 'csv':
        return Icons.table_chart_rounded;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow_rounded;
      case 'zip':
      case 'rar':
        return Icons.folder_zip_rounded;
      case 'txt':
        return Icons.text_snippet_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  Color _documentAccent(String fileName) {
    switch (_fileExtension(fileName)) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'xls':
      case 'xlsx':
      case 'csv':
        return Colors.green;
      case 'ppt':
      case 'pptx':
        return Colors.orange;
      case 'zip':
      case 'rar':
        return Colors.amber.shade800;
      case 'txt':
        return Colors.teal;
      default:
        return primaryColor;
    }
  }

  Widget _buildDocumentItem(GalleryMediaItem item) {
    final fileName = _extractFileNameFromUrl(item.url);
    final extension = _fileExtension(fileName);
    final accent = _documentAccent(fileName);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openGalleryDocument(item.url),
        borderRadius: BorderRadius.circular(14),
        child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderClr(context)),
        boxShadow: [
          if (isLight(context))
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_documentIcon(fileName), color: accent, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyRegularText(
                  label: fileName,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: primaryText(context),
                  maxlines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                MyRegularText(
                  label:
                      extension.isEmpty ? 'Document' : extension.toUpperCase(),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: secondaryText(context),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _openGalleryDocument(item.url),
              borderRadius: BorderRadius.circular(12),
              child: Ink(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isPdfUrl(item.url)
                      ? Icons.visibility_rounded
                      : Icons.download_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
        ),
      ),
    );
  }

  // TAB 2: INFO
  Widget _buildInfoTab() {
    return Obx(() {
      final info = controller.studentInfoDetails.value;
      final isLoading = controller.isStudentDetailsLoading.value;

      if (isLoading) return const Center(child: CircularProgressIndicator());
      if (info == null) {
        return Center(child: EmptyState());
      }

      final parent = info.parentProfile;
      final emergency = info.emergencyContact;
      final medical = info.medicalInfo;
      final medicalNote = medical?.note?.trim();
      final hasMedicalData = info.hasAllergies != null ||
          info.takesMedications != null ||
          info.hasMedicalCondition != null ||
          info.pickup != null ||
          info.medicalDecision != null ||
          (medicalNote != null && medicalNote.isNotEmpty);
      return SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildKidInfoCard(true),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                  color: softBg(context),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _buildInfoSection(
                      'date_of_birth'.tr,
                      info.dateOfBirth != null
                          ? '${info.dateOfBirth!.day} ${_monthName(info.dateOfBirth!.month)} ${info.dateOfBirth!.year}'
                          : '—'),
                  _buildInfoSection('gender'.tr, info.gender ?? '—'),
                  _buildInfoSection('class_name'.tr, info.className ?? '—'),
                  _buildInfoSection('roll_no'.tr, info.rollNo ?? '—'),
                  _buildInfoSection(
                      'phone_no'.tr,
                      parent != null
                          ? '${parent.countryCode ?? ''} ${parent.phoneNumber ?? ''}'
                              .trim()
                          : '—',
                      isPhone: true),
                  _buildInfoSection(
                      'father_name'.tr,
                      parent != null
                          ? '${parent.firstName ?? ''} ${parent.lastName ?? ''}'
                              .trim()
                          : '—'),
                  _buildInfoSection('address'.tr, info.address ?? '—'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('parent_information'.tr),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                  color: softBg(context),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _buildInfoSection(
                      'Name'.tr,
                      parent != null
                          ? '${parent.firstName ?? ''} ${parent.lastName ?? ''}'
                              .trim()
                          : '—'),
                  _buildInfoSection(
                      'Phone No'.tr,
                      parent != null
                          ? '${parent.countryCode ?? ''} ${parent.phoneNumber ?? ''}'
                              .trim()
                          : '—',
                      isPhone: true),
                  _buildInfoSection(
                      'Relationship'.tr, parent?.relationship ?? '—'),
                  _buildInfoSection('Occupation'.tr, parent?.occupation ?? '—'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('emergency_contact'.tr),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                  color: softBg(context),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _buildInfoSection(
                      'Name'.tr,
                      emergency != null
                          ? '${emergency.firstName ?? ''} ${emergency.lastName ?? ''}'
                              .trim()
                          : '—'),
                  _buildInfoSection(
                      'Phone No'.tr,
                      emergency != null
                          ? '${emergency.countryCode ?? ''} ${emergency.phoneNumber ?? ''}'
                              .trim()
                          : '—',
                      isPhone: true),
                  _buildInfoSection('Relationship'.tr, emergency?.relation),
                  _buildInfoSection(
                      'Occupation'.tr, emergency?.occupation ?? '—'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (hasMedicalData) ...[
              _buildSectionHeader('medical_info'.tr),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: softBg(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    if (info.hasAllergies != null)
                      _buildInfoSection(
                        'Has Allergies'.tr,
                        _yesNoValue(info.hasAllergies),
                      ),

                    if (info.takesMedications != null)
                      _buildInfoSection(
                        'Takes Medications'.tr,
                        _yesNoValue(info.takesMedications),
                      ),

                    if (info.hasMedicalCondition != null)
                      _buildInfoSection(
                        'Has Medical Condition'.tr,
                        _yesNoValue(info.hasMedicalCondition),
                      ),

                    // 👇 ADD THESE
                    if (info.pickup != null)
                      _buildInfoSection(
                        'Pickup'.tr,
                        _yesNoValue(info.pickup),
                      ),

                    if (info.medicalDecision != null)
                      _buildInfoSection(
                        'Medical Decision'.tr,
                        _yesNoValue(info.medicalDecision),
                      ),

                    if (medicalNote != null && medicalNote.isNotEmpty)
                      _buildInfoSection('Note'.tr, medicalNote),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      );
    });
  }

  Widget _buildInfoSection(
    String label,
    String? value, {
    bool isPhone = false,
    bool stacked = false,
  }) {
    final displayValue = (value == null || value.trim().isEmpty) ? '-' : value;

    if (stacked) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyRegularText(
              label: label,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: secondaryText(context),
            ),
            const SizedBox(height: 6),
            MyRegularText(
              label: displayValue,
              fontSize: 14,
              color: isPhone
                  ? Colors.blue
                  : (displayValue == '-' ? Colors.grey : primaryText(context)),
              fontWeight: FontWeight.w500,
              align: TextAlign.start,
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyRegularText(
            label: label,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: secondaryText(context),
          ),
          Flexible(
            child: MyRegularText(
              label: displayValue,
              fontSize: 14,
              color: isPhone
                  ? Colors.blue
                  : (displayValue == '-'
                      ? Colors.grey // 👈 make it look disabled
                      : primaryText(context)),
              fontWeight: FontWeight.w500,
              maxlines: 2,
              align: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  String _yesNoValue(bool? value) {
    if (value == null) return '-';
    return value ? 'Yes'.tr : 'No'.tr;
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      decoration: BoxDecoration(
          color: pageBg(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyRegularText(
              label: title,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: primaryText(context)),
          // SvgPicture.asset('assets/svg/edit.svg',
          //     height: 25,
          //     colorFilter:
          //         ColorFilter.mode(primaryText(context), BlendMode.srcIn)),
        ],
      ),
    );
  }

  // TAB 3: FEE (UNCHANGED)
  Widget _buildFeeTab() {
    return Obx(() {
      if (controller.isFeesLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final fees = controller.feesList.toList();

      return SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildKidInfoCard(false),
            const SizedBox(height: 16),
            if (fees.isEmpty)
              const Center(child: EmptyState())
            else
              ...fees.map((fee) {
                return _buildFeeItem(fee);
              }).toList(),
          ],
        ),
      );
    });
  }

  Widget _buildFeeItem(Fee fee) {
    final feeAmount = fee.amount ?? 0;
    final formattedAmount = feeAmount % 1 == 0
        ? feeAmount.toInt().toString()
        : feeAmount.toString();
    final currency =
        (fee.symbol?.trim().isNotEmpty ?? false) ? '${fee.symbol} ' : '';
    final amount =
        '$currency$formattedAmount - ${getInstallmentText(fee.installment) ?? ''}';
    final status = fee.status ?? '';
    final normalizedStatus = status.toUpperCase();
    final canDownloadInvoice = normalizedStatus == 'PAID' &&
        fee.invoicePdfLink != null &&
        fee.invoicePdfLink!.trim().isNotEmpty;

    Color bgColor;
    Color textColor;
    String label;

    switch (normalizedStatus) {
      case 'PAID':
        bgColor = secondaryColor;
        textColor = Colors.white;
        label = 'paid'.tr;
        break;

      case 'PENDING':
        bgColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        label = 'pending'.tr;
        break;

      case 'REJECTED':
        bgColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        label = 'rejected'.tr;
        break;

      default:
        bgColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey;
        label = status;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderClr(context)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.green, width: 2.5),
                        ),
                      ),
                      const SizedBox(width: 8),
                      MyRegularText(
                        label: fee.dueDate ?? '',
                        fontSize: 12,
                        color: secondaryText(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  MyRegularText(
                    label: amount,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: primaryText(context),
                  ),
                  if (canDownloadInvoice) ...[
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _openInvoicePdfLink(fee.invoicePdfLink, fee),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.download_rounded, size: 18),
                        label: Text(
                          'download_invoice'.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: textColor, width: 1.5),
              ),
              child: MyRegularText(
                label: label,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 4: GALLERY (UNCHANGED)
  Widget _buildCalendarTab() {
    return const CalendarScreen();
  }

  // TAB 4: GALLERY
  // Widget _buildGalleryTab() {
  //   return Obx(() {
  //     if (controller.isGalleryLoading.value) {
  //       return const Center(child: CircularProgressIndicator());
  //     }
  //
  //     final gallerySections = controller.gallerySections;
  //
  //     return SingleChildScrollView(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const SizedBox(height: 16),
  //           _buildKidInfoCard(false),
  //           const SizedBox(height: 16),
  //           if (gallerySections.isEmpty)
  //             const Center(child: EmptyState())
  //           else
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 12),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: gallerySections
  //                     .map((section) => _buildGallerySection(section))
  //                     .toList(),
  //               ),
  //             ),
  //           const SizedBox(height: 24),
  //         ],
  //       ),
  //     );
  //   });
  // }

  Widget _buildGalleryTab() {
    return Column(
      children: [
        TabBar(
          padding: EdgeInsets.zero,
          labelPadding: const EdgeInsets.symmetric(horizontal: 12),
          controller: _galleryTabController,
          indicatorColor: primaryColor,
          indicatorWeight: 2.5,
          labelColor: primaryColor,
          unselectedLabelColor: secondaryText(context),
          labelStyle: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.5),
          unselectedLabelStyle:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          dividerColor: Colors.transparent,
          tabs: [
            Tab(text: "Images".tr),
            Tab(text: "Videos".tr),
            Tab(text: "Documents".tr),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _galleryTabController,
            children: [
              _buildGalleryByType("image"),
              _buildGalleryByType("video"),
              _buildGalleryByType("document"),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildGalleryByType(String type) {
    return Obx(() {
      if (controller.isGalleryLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final typedSections = controller.gallerySections
          .map(
            (section) => MapEntry(
              section,
              section.items.where((item) => item.type == type).toList(),
            ),
          )
          .where((entry) => entry.value.isNotEmpty)
          .toList();

      if (typedSections.isEmpty) {
        return const Center(child: EmptyState());
      }

      return ListView(
        padding: const EdgeInsets.all(12),
        children: typedSections.map((entry) {
          // 🔥 FILTER BY TYPE
          final section = entry.key;
          final filteredItems = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 📅 DATE
              Text(
                section.displayDate,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 8),

              _buildMediaUI(filteredItems, type),

              const SizedBox(height: 16),
            ],
          );
        }).toList(),
      );
    });
  }

  Widget _buildMediaUI(List<GalleryMediaItem> items, String type) {
    /// 🖼 IMAGES (GRID)
    if (type == "image") {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
        ),
        itemBuilder: (_, i) {
          return _buildGalleryMediaTile(items[i]); // ✅ reuse
        },
      );
    }

    /// 🎥 VIDEOS (GRID - same style)
    else if (type == "video") {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 👈 bigger tiles for videos
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.4,
        ),
        itemBuilder: (_, i) {
          return _buildGalleryMediaTile(items[i]); // ✅ same UI
        },
      );
    }

    /// 📄 DOCUMENTS (LIST)
    else {
      return Column(
        children: items.map((item) {
          return _buildDocumentItem(item);
        }).toList(),
      );
    }
  }

  Widget _buildGallerySection(GallerySection section) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyRegularText(
            label: section.displayDate.isEmpty
                ? (section.rawDate.isEmpty ? 'gallery'.tr : section.rawDate)
                : section.displayDate,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: primaryText(context),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemCount: section.items.length,
            itemBuilder: (context, index) {
              final item = section.items[index];
              return _buildGalleryMediaTile(item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryMediaTile(GalleryMediaItem item) {
    final mediaType = _galleryMediaType(item.url);
    final isVideo = mediaType == 'video';
    final isImage = mediaType == 'image';
    final isPdf = isPdfUrl(item.url);
    final canPreview = isImage || isVideo || isPdf;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GestureDetector(
        onTap: canPreview
            ? () => openDownloadableMedia(url: item.url)
            : null,
        child: Container(
          color: softBg(context),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (isImage)
                Image.network(
                  item.url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                )
              else
                Center(
                  child: Icon(
                    isVideo ? Icons.play_circle_fill : Icons.insert_drive_file,
                    color: isVideo ? Colors.white70 : Colors.grey,
                    size: 32,
                  ),
                ),
              if (isVideo)
                Container(
                  color: Colors.black26,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.play_circle_fill,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _galleryMediaType(String url) {
    final normalizedUrl = url.toLowerCase().split('?').first;

    const imageExtensions = ['.jpg', '.jpeg', '.png', '.webp', '.gif', '.bmp'];
    const videoExtensions = ['.mp4', '.mov', '.m3u8', '.webm', '.mkv', '.avi'];

    if (imageExtensions.any(normalizedUrl.endsWith)) {
      return 'image';
    }
    if (videoExtensions.any(normalizedUrl.endsWith)) {
      return 'video';
    }

    return 'file';
  }
}
