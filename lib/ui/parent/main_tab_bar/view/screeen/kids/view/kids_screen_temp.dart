// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:unicorn/core/widget/my_regular_text.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/services.dart';
// import 'dart:typed_data';
//
// import '../../../../../../../core/ColorUtils.dart';
// import '../../../../../../../core/widget/empty_state.dart';
// import '../../../../../../teacher/teacher_bottom_tab/view/screens/home/view/report/model/report_details_by_student_slug/report_details_by_student_slug_response.dart';
// import 'controller/kids_controller.dart';
// import 'edit_student_screen.dart';
//
// class KidsScreen extends StatefulWidget {
//   const KidsScreen({super.key});
//
//   @override
//   State<KidsScreen> createState() => _KidsScreenState();
// }
//
// class _KidsScreenState extends State<KidsScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   int _selectedKidIndex = 0;
//   DateTime _selectedDate = DateTime.now();
//
//   bool isLight(BuildContext context) =>
//       Theme.of(context).brightness == Brightness.light;
//
//   Color pageBg(BuildContext context) =>
//       isLight(context) ? Colors.white : const Color(0xFF0F0F0F);
//
//   Color cardBg(BuildContext context) =>
//       isLight(context) ? Colors.white : const Color(0xFF1A1A1A);
//
//   Color softBg(BuildContext context) =>
//       isLight(context) ? Colors.grey.shade100 : const Color(0xFF242424);
//
//   Color primaryText(BuildContext context) =>
//       isLight(context) ? Colors.black87 : Colors.white;
//
//   Color secondaryText(BuildContext context) =>
//       isLight(context) ? Colors.grey.shade600 : Colors.grey.shade400;
//
//   Color borderClr(BuildContext context) =>
//       isLight(context) ? Colors.grey.shade300 : Colors.white.withOpacity(0.12);
//
//   Color dividerClr(BuildContext context) =>
//       isLight(context) ? Colors.grey.shade200 : Colors.white.withOpacity(0.08);
//
//   final KidsController controller = Get.put(KidsController());
//   final DateTime _minDate = DateTime(2020, 1, 1);
//   DateTime get _maxDate => DateTime.now();
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//     Future.delayed(Duration.zero, () async {
//       await controller.parentGetBySlug(context);
//       if (controller.parent.value?.students?.isNotEmpty == true) {
//         final slug = controller.parent.value!.students!.first.studentSlug ?? "";
//         final id = controller.parent.value!.students!.first.studentSlug ?? "";
//         await controller.fetchStudentsBySlug(context, slug);
//         await controller.studentDetailsBySlug(context, slug,
//             date: _formatDate(_selectedDate));
//       }
//     });
//   }
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   String _formatDate(DateTime date) =>
//       '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
//
//   String _displayDate(DateTime date) {
//     final month = DateFormat.MMMM(Get.locale?.languageCode).format(date);
//     return '${date.day}-$month';
//   }
//
//   String _monthName(int month) {
//     final date = DateTime(2020, month); // dummy year
//     return DateFormat.MMM(Get.locale?.languageCode).format(date);
//   }
//   void _loadStudentDetails(String slug) {
//     controller.fetchStudentsBySlug(context, slug);
//     controller.studentDetailsBySlug(context, slug,
//         date: _formatDate(_selectedDate));
//   }
//
//   void _reloadReportForSelectedStudent() {
//     final students = controller.parent.value?.students ?? [];
//
//     if (students.isEmpty || _selectedKidIndex >= students.length) return;
//
//     final slug = students[_selectedKidIndex].studentSlug ?? '';
//     if (slug.isEmpty) return;
//
//     controller.studentDetailsBySlug(
//       context,
//       slug,
//       date: _formatDate(_selectedDate),
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: pageBg(context),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12.0),
//           child: Column(
//             children: [
//               _buildKidsHeader(),
//               _buildTabBar(),
//               Expanded(
//                 child: TabBarView(
//                   physics: const NeverScrollableScrollPhysics(),
//                   controller: _tabController,
//                   children: [
//                     _buildActivityTab(),
//                     _buildInfoTab(),
//                     _buildFeeTab(),
//                     _buildGalleryTab(),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildKidsHeader() {
//     return Obx(() {
//       final students = controller.parent.value?.students ?? [];
//       if (controller.isLoading.value) {
//         return const SizedBox(
//             height: 80, child: Center(child: CircularProgressIndicator()));
//       }
//       if (students.isEmpty) {
//         return   SizedBox(
//             height: 80, child: Center(child: Text("No Students Found".tr)));
//       }
//       return Container(
//         color: pageBg(context),
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         child: Row(
//           children: List.generate(students.length, (index) {
//             final student = students[index];
//             final isSelected = index == _selectedKidIndex;
//             return GestureDetector(
//               onTap: () {
//                 setState(() => _selectedKidIndex = index);
//                 _loadStudentDetails(student.studentSlug ?? "");
//               },
//               child: Container(
//                 margin: const EdgeInsets.only(right: 20),
//                 child: Column(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(3),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: isSelected ? primaryColor : Colors.transparent,
//                           width: 2.5,
//                         ),
//                       ),
//                       child: CircleAvatar(
//                         radius: 28,
//                         backgroundImage: student.profileLink != null
//                             ? NetworkImage(student.profileLink!)
//                             : null,
//                         child: student.profileLink == null
//                             ? const Icon(Icons.person)
//                             : null,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     MyRegularText(
//                         label: student.name ?? "",
//                         fontSize: 12,
//                         color: primaryText(context)),
//                   ],
//                 ),
//               ),
//             );
//           }),
//         ),
//       );
//     });
//   }
//
//   Widget _buildTabBar() {
//     return Container(
//       color: pageBg(context),
//       child: TabBar(
//
//         isScrollable: false,
//         labelPadding: const EdgeInsets.symmetric(horizontal: 8),
//         controller: _tabController,
//         indicatorColor: primaryColor,
//         indicatorWeight: 2.5,
//         labelColor: primaryColor,
//         unselectedLabelColor: secondaryText(context),
//         labelStyle: const TextStyle(
//             fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.5),
//         unselectedLabelStyle:
//         const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
//         dividerColor: Colors.transparent,
//         tabs: [
//           Tab(text: 'tab_activity'.tr),
//           Tab(text: 'tab_info'.tr),
//           Tab(text: 'tab_fee'.tr),
//           Tab(text: 'tab_gallery'.tr),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildKidInfoCard(bool isEdit) {
//     return Obx(() {
//       final student = controller.studentInfoDetails.value;
//       if (controller.isStudentDetailsLoading.value) {
//         return const Center(child: CircularProgressIndicator());
//       }
//       if (student == null) return const SizedBox();
//       return Container(
//         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
//         decoration: BoxDecoration(
//           color: cardBg(context),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: borderClr(context)),
//         ),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 26,
//               backgroundImage: student.profileLink != null
//                   ? NetworkImage(student.profileLink!)
//                   : null,
//               child:
//               student.profileLink == null ? const Icon(Icons.person) : null,
//             ),
//             const SizedBox(width: 14),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   MyRegularText(
//                     label:
//                     "${student.firstName ?? ""} ${student.lastName ?? ""}",
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: primaryText(context),
//                   ),
//                   const SizedBox(height: 2),
//                   Row(
//                     children: [
//                       MyRegularText(
//                           label: "roll_no".tr,
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500,
//                           color: secondaryText(context)),
//                       MyRegularText(
//                           label: " : ${student.rollNo ?? ""}",
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500,
//                           color: secondaryText(context)),
//                     ],
//                   ),
//                   const SizedBox(height: 2),
//                   MyRegularText(
//                       label: "${'Class'.tr} : ${student.className ?? ""}",
//                       fontSize: 13,    fontWeight: FontWeight.w500,
//
//                       color: secondaryText(context)),
//                 ],
//               ),
//             ),
//             if (isEdit)
//               GestureDetector(
//                 onTap: () {
//                   Get.to(
//                           () => EditStudentScreen(slug: student.studentSlug ?? ''));
//                 },
//                 child: SvgPicture.asset('assets/svg/edit.svg',
//                     height: 25,
//                     colorFilter: ColorFilter.mode(
//                         primaryText(context), BlendMode.srcIn)),
//               ),
//           ],
//         ),
//       );
//     });
//   }
//
//   Widget _buildActivityTab() {
//     return Obx(() {
//       final report = controller.ActiveReportDetails.value;
//       final attendance = report?.attendance;
//       final hasAttendanceData =
//           (attendance?.checkIn?.isNotEmpty == true) ||
//               (attendance?.checkOut?.isNotEmpty == true);
//       final hasMood = report?.todaysMood?.mood?.isNotEmpty == true;
//       final hasActivity = report?.activity?.isNotEmpty == true;
//       final hasNap = report?.nap?.isNotEmpty == true;
//       final hasMeal = report?.mealsAndSnacks?.isNotEmpty == true;
//       final hasHygiene = report?.hygiene?.isNotEmpty == true;
//       final hasNote = report?.note?.isNotEmpty == true;
//       final hasAnyActivityData = hasAttendanceData ||
//           hasMood ||
//           hasActivity ||
//           hasNap ||
//           hasMeal ||
//           hasHygiene ||
//           hasNote;
//
//       return SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 16),
//             _buildKidInfoCard(false),
//             const SizedBox(height: 16),
//             _buildDateSelector(),
//             const SizedBox(height: 16),
//             if (!hasAnyActivityData) ...[
//               const SizedBox(height: 24),
//               Center(child: EmptyState())
//             ] else ...[
//               _buildAttendanceCard(),
//               if (hasMood) ...[
//                 const SizedBox(height: 16),
//                 Divider(color: dividerClr(context), height: 1),
//                 const SizedBox(height: 16),
//                 _buildMoodCard(report),
//               ],
//               if (hasActivity) ...[
//                 const SizedBox(height: 16),
//                 Divider(color: dividerClr(context), height: 1),
//                 const SizedBox(height: 16),
//                 _buildActivitySection(report),
//               ],
//               if (hasNap) ...[
//                 const SizedBox(height: 16),
//                 Divider(color: dividerClr(context), height: 1),
//                 const SizedBox(height: 16),
//                 _buildNapSection(report),
//               ],
//               if (hasMeal) ...[
//                 const SizedBox(height: 16),
//                 Divider(color: dividerClr(context), height: 1),
//                 const SizedBox(height: 16),
//                 _buildMealSection(report),
//               ],
//               if (hasHygiene) ...[
//                 const SizedBox(height: 16),
//                 Divider(color: dividerClr(context), height: 1),
//                 const SizedBox(height: 16),
//                 _buildHygieneSection(report),
//               ],
//               if (hasNote) ...[
//                 const SizedBox(height: 16),
//                 Divider(color: dividerClr(context), height: 1),
//                 const SizedBox(height: 16),
//                 _buildNoteSection(report),
//               ],
//               const SizedBox(height: 24),
//               _buildDownloadButton(),
//             ],
//             const SizedBox(height: 24),
//           ],
//         ),
//       );
//     });
//   }
//
//   Widget _buildDateSelector() {
//     final light = isLight(context);
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 14),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GestureDetector(
//             onTap: () {
//               final newDate = _selectedDate.subtract(const Duration(days: 1));
//
//               if (newDate.isBefore(_minDate)) return;
//
//               setState(() => _selectedDate = newDate);
//               _reloadReportForSelectedStudent();
//             },
//             child: Container(
//               height: 45,
//               width: 45,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: borderClr(context), width: 1)),
//               child:   Icon(Icons.arrow_back_rounded,
//                   color:light ? Colors.black : Colors.white, size: 20),
//             ),
//           ),
//           Column(
//             children: [
//               MyRegularText(
//                   label: _displayDate(_selectedDate),
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: primaryText(context)),
//               MyRegularText(
//                   label: _selectedDate.year.toString(),
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: secondaryText(context)),
//             ],
//           ),
//           GestureDetector(
//             onTap: () {
//               final newDate = _selectedDate.add(const Duration(days: 1));
//
//               if (newDate.isAfter(_maxDate)) return;
//
//               setState(() => _selectedDate = newDate);
//               _reloadReportForSelectedStudent();
//             },
//             child: Container(
//               height: 45,
//               width: 45,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: borderClr(context), width: 1)),
//               child:
//               Icon(Icons.arrow_forward,    color:light ? Colors.black : Colors.white,size: 20),
//             ),
//           ),
//           GestureDetector(
//             onTap: () async {
//               final picked = await showDatePicker(
//                 context: context,
//                 initialDate: _selectedDate,
//                 firstDate: _minDate,
//                 lastDate: _maxDate,
//                 builder: (context, child) {
//                   final theme = Theme.of(context);
//                   final isDark = !isLight(context);
//                   return Theme(
//                     data: theme.copyWith(
//                       dialogBackgroundColor: cardBg(context),
//                       colorScheme: isDark
//                           ? ColorScheme.dark(
//                         primary: primaryColor,
//                         onPrimary: Colors.white,
//                         surface: cardBg(context),
//                         onSurface: primaryText(context),
//                       )
//                           : theme.colorScheme.copyWith(
//                         primary: primaryColor,
//                         onPrimary: Colors.white,
//                         surface: cardBg(context),
//                         onSurface: primaryText(context),
//                       ),
//                       datePickerTheme: DatePickerThemeData(
//                         backgroundColor: cardBg(context),
//                         headerBackgroundColor: cardBg(context),
//                         headerForegroundColor: primaryText(context),
//                         dayForegroundColor:
//                         WidgetStateProperty.all(primaryText(context)),
//                         weekdayStyle:
//                         TextStyle(color: secondaryText(context)),
//                         dayStyle: TextStyle(color: primaryText(context)),
//                         yearForegroundColor:
//                         WidgetStateProperty.all(primaryText(context)),
//                       ),
//                     ),
//                     child: child ?? const SizedBox.shrink(),
//                   );
//                 },
//               );
//
//               if (picked != null && picked != _selectedDate) {
//                 setState(() => _selectedDate = picked);
//                 _reloadReportForSelectedStudent();
//               }
//             },
//             child: Container(
//               height: 45,
//               width: 45,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: borderClr(context), width: 1)),
//               child:   Icon(Icons.calendar_month_outlined,
//                   color:light ? Colors.black : Colors.white, size: 20),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAttendanceCard() {
//     return Obx(() {
//       final report = controller.ActiveReportDetails.value;
//       final attendance = report?.attendance;
//
//       final checkIn = attendance?.checkIn ?? '';
//       final checkOut = attendance?.checkOut ?? '';
//
//       String formatDateTime(String time) {
//         if (time.isEmpty) return 'No Data';
//
//         try {
//           /// Combine date + time (UTC)
//           final utcDateTime = DateTime.parse(time);
//           final local = utcDateTime.toLocal();
//
//           /// Format HH:mm
//           final formattedTime = DateFormat('hh:mm a').format(local);
//
//           return '${DateFormat('dd-MMM-yyyy').format(local)} at $formattedTime';
//         } catch (e) {
//           return time; // fallback
//         }
//       }
//
//       return Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             MyRegularText(
//               label: 'attendance'.tr,
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//               color: primaryText(context),
//             ),
//             const SizedBox(height: 16),
//
//             /// ✅ Check In
//             _buildAttendanceRow(
//               'check_in'.tr,
//               formatDateTime(checkIn),
//               Colors.green,
//             ),
//
//             const SizedBox(height: 12),
//
//             /// ✅ Check Out
//             _buildAttendanceRow(
//               'check_out'.tr,
//               formatDateTime(checkOut),
//               Colors.red,
//             ),
//           ],
//         ),
//       );
//     });
//   }
//
//   Widget _buildAttendanceRow(String label, String time, Color dotColor) {
//     return Row(
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   margin: const EdgeInsets.only(top: 3),
//                   width: 10,
//                   height: 10,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(color: dotColor, width: 2.5),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 MyRegularText(    fontWeight: FontWeight.w500,
//                     label: time, fontSize: 12, color: secondaryText(context)),
//               ],
//             ),
//             const SizedBox(height: 4),
//             MyRegularText(
//                 label: label,
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 color: primaryText(context)),
//           ],
//         ),
//       ],
//     );
//   }
//
//   // Mood — exact same layout as commented _buildMoodCard(), first mood from API
//   String _moodEmoji(String mood) {
//     switch (mood.toLowerCase()) {
//       case 'happy':
//         return '😊';
//       case 'sad':
//         return '😢';
//       case 'angry':
//         return '😠';
//       case 'excited':
//         return '🤩';
//       case 'tired':
//         return '😴';
//       case 'sick':
//         return '🤒';
//       default:
//         return '😊';
//     }
//   }
//   final Map<String, String> moodImages = {
//     'happy': 'assets/png/happy.png',
//     'confused': 'assets/png/confused.png',
//     'cool': 'assets/png/cool.png',
//     'amazed': 'assets/png/amazed.png',
//     'stressed': 'assets/png/stressed.png',
//     'peaceful': 'assets/png/peaceful.png',
//   };
//
//   String _moodImage(String mood) {
//     return moodImages[mood.toLowerCase()] ?? moodImages['happy']!;
//   }
//   Widget _buildMoodCard(StudentReportDetailsData? report) {
//     final moods = report?.todaysMood?.mood ?? [];
//     if (moods.isEmpty) return const SizedBox();
//     final moodLabel = moods.isNotEmpty ? moods.first : 'happy';
//     final emoji = _moodEmoji(moodLabel);
//
//     final imagePath = _moodImage(moodLabel);
//
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           MyRegularText(
//             label: 'mood'.tr,
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//             color: primaryText(context),
//           ),
//           const SizedBox(height: 16),
//           Column(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(100),
//                   color: isLight(context)
//                       ? const Color(0xFFCFD7EA)
//                       : const Color(0xFF2A3A5A),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Image.asset(
//                     imagePath,
//                     height: 50,
//                     width: 50,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               MyRegularText(
//                 label: moodLabel,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: primaryText(context),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActivitySection(StudentReportDetailsData? report) {
//     final activities = report?.activity ?? [];
//     if (activities.isEmpty) return const SizedBox();
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           MyRegularText(
//               label: 'activity'.tr,
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//               color: primaryText(context)),
//           const SizedBox(height: 16),
//           ...activities.map((a) => _buildActivityItem(
//               a.description   ?? '', a.startTime ?? '')),
//         ],
//       ),
//     );
//   }
//   String _formatDateTimeWithAt(String time) {
//     final date = DateFormat('dd-MMM-yyyy').format(_selectedDate);
//     return '$date at $time';
//   }
//   Widget _buildActivityItem(String title, String time) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 14),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 10,
//                 height: 10,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(color:  Colors.green, width: 2.5),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               MyRegularText(    fontWeight: FontWeight.w500,
//                   label: _formatDateTimeWithAt(time), fontSize: 12, color: secondaryText(context)),
//             ],
//           ),
//           const SizedBox(height: 4),
//           Row(
//             children: [
//               SvgPicture.asset(
//                 'assets/svg/candle.svg',
//                 colorFilter: ColorFilter.mode(
//                     primaryText(context), BlendMode.srcIn),
//               ),
//               const SizedBox(width: 8),
//               MyRegularText(
//                   label: title,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   color: primaryText(context)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNapSection(StudentReportDetailsData? report) {
//     final naps = report?.nap ?? [];
//     if (naps.isEmpty) return const SizedBox();
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           MyRegularText(
//               label: 'nap'.tr,
//               fontSize: 20,
//               fontWeight: FontWeight.w500,
//               color: primaryText(context)),
//           const SizedBox(height: 16),
//           ...naps.map(
//                   (n) => _buildNapItem( 'NAP', "${n.startTime ?? ''} to ${n.endTime ?? ''}")),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNapItem(String title, String time) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 14),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 10,
//                 height: 10,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(color:  Colors.green, width: 2.5),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               MyRegularText(    fontWeight: FontWeight.w500,
//                   label: time, fontSize: 12, color: secondaryText(context)),
//             ],
//           ),
//           const SizedBox(height: 4),
//           Row(
//             children: [
//               SvgPicture.asset(
//                 'assets/svg/sleep.svg',
//                 colorFilter: ColorFilter.mode(
//                     primaryText(context), BlendMode.srcIn),
//               ),
//               const SizedBox(width: 8),
//               MyRegularText(
//                   label: formatTitle(title),
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   color: primaryText(context)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMealSection(StudentReportDetailsData? report) {
//     final meals = report?.mealsAndSnacks ?? [];
//     if (meals.isEmpty) return const SizedBox();
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           MyRegularText(
//               label: 'meal'.tr,
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//               color: primaryText(context)),
//           const SizedBox(height: 16),
//           ...meals.map((m) =>
//               _buildMealItem(m.mealName  ?? '', m.time ?? '')),
//         ],
//       ),
//     );
//   }
//   Widget _buildMealItem(String title, String time) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 14),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 10,
//                 height: 10,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(color:  Colors.green, width: 2.5),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               MyRegularText(    fontWeight: FontWeight.w500,
//                   label: _formatDateTimeWithAt(time), fontSize: 12, color: secondaryText(context)),
//             ],
//           ),
//           const SizedBox(height: 4),
//           Row(
//             children: [
//               SvgPicture.asset(
//                 'assets/svg/snoop.svg',
//                 colorFilter: ColorFilter.mode(
//                     primaryText(context), BlendMode.srcIn),
//               ),
//               const SizedBox(width: 8),
//               MyRegularText(
//                   label: formatTitle(title),
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   color: primaryText(context)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHygieneSection(StudentReportDetailsData? report) {
//     final hygieneList = report?.hygiene ?? [];
//     if (hygieneList.isEmpty) return const SizedBox();
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           MyRegularText(
//               label: 'hygiene'.tr,
//               fontSize: 15,
//               fontWeight: FontWeight.w600,
//               color: primaryText(context)),
//           const SizedBox(height: 16),
//           ...hygieneList.map((h) => _buildHygieneItem(
//               h.hygieneType ?? h.description ?? '', h.time ?? '')),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHygieneItem(String title, String time) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 14),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 10,
//                 height: 10,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(color:  Colors.green, width: 2.5),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               MyRegularText(    fontWeight: FontWeight.w500,
//                   label: _formatDateTimeWithAt(time), fontSize: 12, color: secondaryText(context)),
//             ],
//           ),
//           const SizedBox(height: 4),
//           Row(
//             children: [
//               SvgPicture.asset(
//                 'assets/svg/handwash.svg',
//                 colorFilter: ColorFilter.mode(
//                     primaryText(context), BlendMode.srcIn),
//               ),
//               const SizedBox(width: 8),
//               MyRegularText(
//                   label: formatTitle(title),
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   color: primaryText(context)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//   String formatTitle(String value) {
//     if (value.isEmpty) return value;
//
//     return value
//         .toLowerCase() // oats_and_milk
//         .split('_')    // [oats, and, milk]
//         .map((word) => word[0].toUpperCase() + word.substring(1))
//         .join(' ');
//   }
//   // Note — exact same layout as commented _buildNoteSection(), first note from API
//   Widget _buildNoteSection(StudentReportDetailsData? report) {
//     final notes = report?.note ?? [];
//     if (notes.isEmpty) return const SizedBox();
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           MyRegularText(
//               label: 'note'.tr,
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//               color: primaryText(context)),
//           const SizedBox(height: 12),
//           MyRegularText(
//             label: notes.isNotEmpty ? (notes.first.content ?? '') : '',
//             fontSize: 13,
//             color: secondaryText(context),
//             maxlines: 2,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDownloadButton() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: () async {
//           final report = controller.ActiveReportDetails.value;
//           final student = controller.studentInfoDetails.value;
//
//           if (report == null || student == null) {
//             Get.snackbar("Error", "No data available");
//             return;
//           }
//
//           Get.dialog(const Center(child: CircularProgressIndicator()),
//               barrierDismissible: false);
//
//           final bytes = await _buildReportPdfBytes(report, student);
//
//           final filePath = await _savePdfToFile(
//             bytes,
//             _buildReportFileName(
//               student.firstName,
//               student.lastName,
//               _selectedDate,
//             ),
//           );
//
//           Get.back(); // close loader
//
//           if (filePath != null) {
//             Get.snackbar(
//               "Success",
//               "PDF saved successfully",
//               duration: const Duration(seconds: 3),
//             );
//           }
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: primaryColor,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           shape:
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           elevation: 0,
//         ),
//         child: MyRegularText(
//             label: 'download_report'.tr,
//             fontSize: 15,
//             fontWeight: FontWeight.w600,
//             color: Colors.white),
//       ),
//     );
//   }
//
//   Future<Uint8List> _buildReportPdfBytes(
//       StudentReportDetailsData report,
//       dynamic student,
//       ) async {
//
//     final pdf = pw.Document();
//     String _safe(String? v) => (v == null || v.trim().isEmpty) ? 'N/A' : v;
//
//     pw.Widget sectionTitle(String title) {
//       return pw.Padding(
//         padding: const pw.EdgeInsets.only(top: 16, bottom: 8),
//         child: pw.Text(
//           title,
//           style: pw.TextStyle(
//             fontSize: 16,
//             fontWeight: pw.FontWeight.bold,
//             color: PdfColors.blueGrey800,
//           ),
//         ),
//       );
//     }
//
//     pw.Widget infoRow(String label, String value) {
//       return pw.Padding(
//         padding: const pw.EdgeInsets.symmetric(vertical: 2),
//         child: pw.Row(
//           children: [
//             pw.Expanded(
//               flex: 2,
//               child: pw.Text(label,
//                   style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//             ),
//             pw.Expanded(flex: 3, child: pw.Text(value)),
//           ],
//         ),
//       );
//     }
//
//     pw.Widget buildTable(List<List<String>> data, List<String> headers) {
//       return pw.Table.fromTextArray(
//         headers: headers,
//         data: data,
//         headerStyle: pw.TextStyle(
//           fontWeight: pw.FontWeight.bold,
//           color: PdfColors.white,
//         ),
//         headerDecoration:
//         const pw.BoxDecoration(color: PdfColors.blueGrey600),
//         cellPadding: const pw.EdgeInsets.all(6),
//         border: pw.TableBorder.all(color: PdfColors.grey300),
//       );
//     }
//
//     pdf.addPage(
//       pw.MultiPage(
//         margin: const pw.EdgeInsets.all(20),
//         build: (context) => [
//           /// HEADER
//           pw.Container(
//             padding: const pw.EdgeInsets.all(12),
//             decoration: pw.BoxDecoration(
//               color: PdfColors.blueGrey50,
//               borderRadius: pw.BorderRadius.circular(8),
//             ),
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pw.Text(
//                   "Student Activity Report",
//                   style: pw.TextStyle(
//                     fontSize: 22,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//                 pw.SizedBox(height: 8),
//                 infoRow("Report Date",
//                     DateFormat('dd-MMM-yyyy').format(_selectedDate)),
//                 infoRow("Name",
//                     "${student.firstName ?? ''} ${student.lastName ?? ''}"),
//                 infoRow("Roll No", _safe(student.rollNo)),
//                 infoRow("Class", _safe(student.className)),
//               ],
//             ),
//           ),
//
//           /// ATTENDANCE
//           sectionTitle("Attendance"),
//           buildTable([
//             [
//               _safe(report.attendance?.checkIn),
//               _safe(report.attendance?.checkOut),
//             ]
//           ], [
//             "Check In",
//             "Check Out"
//           ]),
//
//           /// MOOD
//           if (report.todaysMood?.mood?.isNotEmpty == true) ...[
//             sectionTitle("Mood"),
//             pw.Text(report.todaysMood!.mood!.join(", ")),
//           ],
//
//           /// ACTIVITIES
//           if (report.activity?.isNotEmpty == true) ...[
//             sectionTitle("Activities"),
//             buildTable(
//               report.activity!
//                   .map((a) => [
//                 formatTitle(_safe(a.activityType)),
//                 _safe(a.startTime),
//                 _safe(a.endTime),
//                 _safe(a.description),
//               ])
//                   .toList(),
//               ["Type", "Start", "End", "Description"],
//             ),
//           ],
//
//           /// NAP
//           if (report.nap?.isNotEmpty == true) ...[
//             sectionTitle("Nap"),
//             buildTable(
//               report.nap!
//                   .map((n) => [
//                 _safe(n.startTime),
//                 _safe(n.endTime),
//               ])
//                   .toList(),
//               ["Start Time", "End Time"],
//             ),
//           ],
//
//           /// MEALS
//           if (report.mealsAndSnacks?.isNotEmpty == true) ...[
//             sectionTitle("Meals"),
//             buildTable(
//               report.mealsAndSnacks!
//                   .map((m) => [
//                 formatTitle(_safe(m.mealName)),
//                 _safe(m.time),
//               ])
//                   .toList(),
//               ["Meal", "Time"],
//             ),
//           ],
//
//           /// HYGIENE
//           if (report.hygiene?.isNotEmpty == true) ...[
//             sectionTitle("Hygiene"),
//             buildTable(
//               report.hygiene!
//                   .map((h) => [
//                 formatTitle(
//                     _safe(h.hygieneType ?? h.description)),
//                 _safe(h.time),
//               ])
//                   .toList(),
//               ["Type", "Time"],
//             ),
//           ],
//
//           /// NOTES
//           if (report.note?.isNotEmpty == true) ...[
//             sectionTitle("Notes"),
//             ...report.note!.map(
//                   (n) => pw.Padding(
//                 padding: const pw.EdgeInsets.only(bottom: 4),
//                 child: pw.Bullet(text: _safe(n.content)),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//
//     return pdf.save();
//   }
//   String _buildReportFileName(
//       String? firstName,
//       String? lastName,
//       DateTime date,
//       ) {
//     final name = '${firstName ?? ''} ${lastName ?? ''}'.trim();
//     final safeName = name.isEmpty
//         ? 'student'
//         : name.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_');
//     final dateStamp = DateFormat('yyyyMMdd').format(date);
//     return 'Student_Report_${safeName}_$dateStamp.pdf';
//   }
//
//   Future<String?> _savePdfToFile(Uint8List bytes, String fileName) async {
//     try {
//       final filePath = await FilePicker.platform.saveFile(
//         dialogTitle: 'Save report',
//         fileName: fileName,
//         type: FileType.custom,
//         allowedExtensions: ['pdf'],
//         bytes: bytes,
//       );
//
//       if (filePath == null || filePath.isEmpty) {
//         return null;
//       }
//
//       return filePath;
//     } catch (e) {
//       print("SAVE ERROR: $e");
//       Get.snackbar("Error", "Failed to save report");
//       return null;
//     }
//   }
//   // TAB 2: INFO
//   Widget _buildInfoTab() {
//     return Obx(() {
//       final info = controller.studentInfoDetails.value;
//       final isLoading = controller.isStudentDetailsLoading.value;
//
//       if (isLoading) return const Center(child: CircularProgressIndicator());
//       if (info == null) {
//         return Center(
//             child: EmptyState());
//       }
//
//       final parent = info.parentProfile;
//       final emergency = info.emergencyContact;
//       final medical = info.medicalInfo;
//       final hasMedicalData =
//           info.hasAllergies == true ||
//               info.takesMedications == true ||
//               info.hasMedicalCondition == true ||
//               (medical?.note != null && medical!.note!.isNotEmpty);
//       return SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 16),
//             _buildKidInfoCard(true),
//             const SizedBox(height: 16),
//             Container(
//               decoration: BoxDecoration(
//                   color: softBg(context),
//                   borderRadius: BorderRadius.circular(12)),
//               child: Column(
//                 children: [
//                   _buildInfoSection(
//                       'date_of_birth'.tr,
//                       info.dateOfBirth != null
//                           ? '${info.dateOfBirth!.day} ${_monthName(info.dateOfBirth!.month)} ${info.dateOfBirth!.year}'
//                           : '—'),
//                   _buildInfoSection('gender'.tr, info.gender ?? '—'),
//                   _buildInfoSection('class_name'.tr, info.className ?? '—'),
//                   _buildInfoSection('roll_no'.tr, info.rollNo ?? '—'),
//                   _buildInfoSection(
//                       'phone_no'.tr,
//                       parent != null
//                           ? '${parent.countryCode ?? ''} ${parent.phoneNumber ?? ''}'
//                           .trim()
//                           : '—',
//                       isPhone: true),
//                   _buildInfoSection(
//                       'father_name'.tr,
//                       parent != null
//                           ? '${parent.firstName ?? ''} ${parent.lastName ?? ''}'
//                           .trim()
//                           : '—'),
//                   _buildInfoSection('address'.tr, info.address ?? '—'),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             _buildSectionHeader('parent_information'.tr),
//             const SizedBox(height: 12),
//             Container(
//               decoration: BoxDecoration(
//                   color: softBg(context),
//                   borderRadius: BorderRadius.circular(12)),
//               child: Column(
//                 children: [
//                   _buildInfoSection(
//                       'Name'.tr,
//                       parent != null
//                           ? '${parent.firstName ?? ''} ${parent.lastName ?? ''}'
//                           .trim()
//                           : '—'),
//                   _buildInfoSection(
//                       'Phone No'.tr,
//                       parent != null
//                           ? '${parent.countryCode ?? ''} ${parent.phoneNumber ?? ''}'
//                           .trim()
//                           : '—',
//                       isPhone: true),
//                   _buildInfoSection(
//                       'Relationship'.tr, parent?.relationship ?? '—'),
//                   _buildInfoSection('Occupation'.tr, parent?.occupation ?? '—'),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             _buildSectionHeader('emergency_contact'.tr),
//             const SizedBox(height: 12),
//             Container(
//               decoration: BoxDecoration(
//                   color: softBg(context),
//                   borderRadius: BorderRadius.circular(12)),
//               child: Column(
//                 children: [
//                   _buildInfoSection(
//                       'Name'.tr,
//                       emergency != null
//                           ? '${emergency.firstName ?? ''} ${emergency.lastName ?? ''}'
//                           .trim()
//                           : '—'),
//                   _buildInfoSection(
//                       'Phone No'.tr,
//                       emergency != null
//                           ? '${emergency.countryCode ?? ''} ${emergency.phoneNumber ?? ''}'
//                           .trim()
//                           : '—',
//                       isPhone: true),
//                   _buildInfoSection(
//                       'Relationship'.tr,
//
//                       emergency?.relation
//                   ),
//                   _buildInfoSection('Occupation'.tr, emergency?.occupation ?? '—'),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//
//
//             if (hasMedicalData) ...[
//               _buildSectionHeader('medical_info'.tr),
//               const SizedBox(height: 12),
//               Container(
//                 decoration: BoxDecoration(
//                   color: softBg(context),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   children: [
//                     if (info.hasAllergies == true)
//                       _buildInfoSection('Has Allergies'.tr, 'Yes'.tr),
//
//                     if (info.takesMedications == true)
//                       _buildInfoSection('Takes Medications'.tr, 'Yes'.tr),
//
//                     if (info.hasMedicalCondition == true)
//                       _buildInfoSection('Has Medical Condition'.tr, 'Yes'.tr),
//
//                     // 👇 ADD THESE
//                     if (info.pickup == true)
//                       _buildInfoSection('Pickup'.tr, 'Yes'),
//
//                     if (info.medicalDecision == true)
//                       _buildInfoSection('Medical Decision'.tr, 'Yes'.tr),
//
//                     if (medical?.note != null && medical!.note!.isNotEmpty)
//                       _buildInfoSection('Note'.tr, medical.note!),
//                   ],
//                 ),
//               ),
//             ],
//             const SizedBox(height: 24),
//           ],
//         ),
//       );
//     });
//   }
//
//   Widget _buildInfoSection(String label, String? value, {bool isPhone = false}) {
//     final displayValue =
//     (value == null || value.trim().isEmpty) ? 'No Data Found' : value;
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           MyRegularText(
//             label: label,
//             fontSize: 14,
//             fontWeight: FontWeight.w400,
//             color: secondaryText(context),
//           ),
//           Flexible(
//             child: MyRegularText(
//               label: displayValue,
//               fontSize: 14,
//               color: isPhone
//                   ? Colors.blue
//                   : (displayValue == 'No Data Found'
//                   ? Colors.grey // 👈 make it look disabled
//                   : primaryText(context)),
//               fontWeight: FontWeight.w500,
//               maxlines: 2,
//               align: TextAlign.end,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSectionHeader(String title) {
//     return Container(
//       decoration: BoxDecoration(
//           color: pageBg(context),
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
//       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           MyRegularText(
//               label: title,
//               fontSize: 15,
//               fontWeight: FontWeight.w600,
//               color: primaryText(context)),
//           // SvgPicture.asset('assets/svg/edit.svg',
//           //     height: 25,
//           //     colorFilter:
//           //         ColorFilter.mode(primaryText(context), BlendMode.srcIn)),
//         ],
//       ),
//     );
//   }
//
//   // TAB 3: FEE (UNCHANGED)
//   Widget _buildFeeTab() {
//     return Obx(() {
//       if (controller.isFeesLoading.value) {
//         return const Center(child: CircularProgressIndicator());
//       }
//
//       final fees = controller.feesList.toList();
//
//       return SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 16),
//             _buildKidInfoCard(false),
//             const SizedBox(height: 16),
//             if (fees.isEmpty)
//               const Center(child: EmptyState())
//             else
//               ...fees.map((fee) {
//                 return _buildFeeItem(
//                   fee.dueDate ?? '',
//                   '\$${fee.amount ?? 0} - ${fee.installment ?? ''}',
//                   fee.status ?? '',
//                 );
//               }).toList(),
//           ],
//         ),
//       );
//     });
//   }
//
//   Widget _buildFeeItem(String date, String amount, String status) {
//     final normalizedStatus = status.toUpperCase();
//
//     Color bgColor;
//     Color textColor;
//     String label;
//
//     switch (normalizedStatus) {
//       case 'PAID':
//         bgColor = secondaryColor;
//         textColor = Colors.white;
//         label = 'paid'.tr;
//         break;
//
//       case 'PENDING':
//         bgColor = Colors.orange.withOpacity(0.1);
//         textColor = Colors.orange;
//         label = 'pending'.tr;
//         break;
//
//       case 'REJECTED':
//         bgColor = Colors.red.withOpacity(0.1);
//         textColor = Colors.red;
//         label = 'rejected'.tr;
//         break;
//
//       default:
//         bgColor = Colors.grey.withOpacity(0.1);
//         textColor = Colors.grey;
//         label = status;
//     }
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       width: 10,
//                       height: 10,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color:  Colors.green, width: 2.5),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     MyRegularText(
//                       label: date,
//                       fontSize: 12,
//                       color: secondaryText(context),
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 MyRegularText(
//                   label: amount,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                   color: primaryText(context),
//                 ),
//               ],
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//               decoration: BoxDecoration(
//                 color: bgColor,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: textColor, width: 1.5),
//               ),
//               child: MyRegularText(
//                 label: label,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: textColor,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // TAB 4: GALLERY (UNCHANGED)
//   Widget _buildGalleryTab() {
//     return Obx(() {
//       if (controller.isGalleryLoading.value) {
//         return const Center(child: CircularProgressIndicator());
//       }
//
//       final gallery = controller.galleryList;
//
//       return SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 16),
//             _buildKidInfoCard(false),
//             const SizedBox(height: 16),
//             if (gallery.isEmpty)
//               const Center(child: EmptyState())
//             else
//               GridView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                     crossAxisSpacing: 2,
//                     mainAxisSpacing: 2,
//                   ),
//                   itemCount: gallery.length,
//                   itemBuilder: (context, index) {
//                     final url = gallery[index];
//                     print('URL: $url');
//                     return ClipRRect(
//                       borderRadius: BorderRadius.circular(4),
//                       child: Container(
//                         color: Colors.grey.shade200,
//                         child: Image.network(
//                           url,
//                           fit: BoxFit.cover,
//                           width: double.infinity,
//                           height: double.infinity,
//                           loadingBuilder: (context, child, progress) {
//                             if (progress == null) return child;
//                             return const Center(
//                               child: SizedBox(
//                                 height: 20,
//                                 width: 20,
//                                 child:
//                                 CircularProgressIndicator(strokeWidth: 2),
//                               ),
//                             );
//                           },
//                           errorBuilder: (context, error, stackTrace) {
//                             return const Center(
//                               child:
//                               Icon(Icons.broken_image, color: Colors.grey),
//                             );
//                           },
//                         ),
//                       ),
//                     );
//                   }),
//             const SizedBox(height: 24),
//           ],
//         ),
//       );
//     });
//   }
// }
//
