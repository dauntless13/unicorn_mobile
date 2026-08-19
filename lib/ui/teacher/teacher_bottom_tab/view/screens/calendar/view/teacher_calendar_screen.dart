// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:unicorn/core/widget/my_regular_text.dart';
//
// import '../../home/view/report/controller/report_controller.dart';
//
// class TeacherCalendarScreen extends StatefulWidget {
//   const TeacherCalendarScreen({super.key});
//
//   @override
//   State<TeacherCalendarScreen> createState() => _TeacherCalendarScreenState();
// }
//
// class _TeacherCalendarScreenState extends State<TeacherCalendarScreen> {
//   DateTime selectedDate = DateTime(2021, 9, 2);
//   DateTime currentMonth = DateTime(2021, 9);
//
//   bool isLight(BuildContext context) =>
//       Theme.of(context).brightness == Brightness.light;
//
//   final Map<int, List<Color>> eventDots = {
//     2: [Color(0xFF00C853), Color(0xFF2979FF)],
//     3: [Color(0xFF7C4DFF), Color(0xFF2979FF)],
//     6: [Color(0xFF00C853)],
//     9: [Color(0xFF7C4DFF)],
//     10: [Color(0xFF00C853), Color(0xFF2979FF), Color(0xFF7C4DFF)],
//     13: [Color(0xFF2979FF), Color(0xFF7C4DFF)],
//     15: [Color(0xFF00C853), Color(0xFF2979FF)],
//     20: [Color(0xFF7C4DFF), Color(0xFF2979FF)],
//     22: [Color(0xFF00C853), Color(0xFF7C4DFF), Color(0xFF2979FF)],
//     29: [Color(0xFF2979FF), Color(0xFF7C4DFF), Color(0xFF00C853)],
//     31: [Color(0xFF7C4DFF), Color(0xFF2979FF), Color(0xFF00C853)],
//   };
//
//   List<Map<String, dynamic>> events = [
//     {
//       'time': '19:00-23:00',
//       'title': 'event_annual_day'.tr,
//       'subtitle': 'event_annual_day_sub'.tr,
//       'color': const Color(0xFF00BCD4),
//     },
//     {
//       'time': '14:00-15:00',
//       'title': 'event_christmas'.tr,
//       'subtitle': 'event_christmas_sub'.tr,
//       'color': const Color(0xFF7C4DFF),
//     },
//     {
//       'time': '19:00-20:00',
//       'title': 'event_workout'.tr,
//       'subtitle': 'event_workout_sub'.tr,
//       'color': const Color(0xFF2196F3),
//     },
//   ];
//
//   final ReportController controller = Get.put(ReportController());
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Future.delayed(const Duration(seconds: 0), () {
//       controller.teacherHolidayEventListing(context, );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final light = isLight(context);
//
//     return Scaffold(
//       backgroundColor:
//       light ? Colors.white : const Color(0xFF0F0F0F),
//       body: SafeArea(
//         child: CustomScrollView(
//           slivers: [
//             /// CALENDAR
//             SliverToBoxAdapter(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: light ? Colors.white : const Color(0xFF1A1A1A),
//                   borderRadius: BorderRadius.circular(24),
//                   boxShadow: light
//                       ? [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       offset: Offset(0, 4),
//                     )
//                   ]
//                       : [],
//                 ),
//                 child: Column(
//                   children: [
//                     _buildCalendarHeader(),
//                     _buildWeekDays(),
//                     _buildCalendarGrid(),
//                     const SizedBox(height: 16),
//                   ],
//                 ),
//               ),
//             ),
//
//             const SliverToBoxAdapter(child: SizedBox(height: 12)),
//
//             /// EVENTS
//             SliverPadding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               sliver: SliverList(
//                 delegate: SliverChildBuilderDelegate(
//                       (context, index) {
//                     return _buildEventCard(events[index]);
//                   },
//                   childCount: events.length,
//                 ),
//               ),
//             ),
//
//             const SliverToBoxAdapter(child: SizedBox(height: 24)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// HEADER
//   Widget _buildCalendarHeader() {
//     final light = isLight(context);
//
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           _navButton(Icons.chevron_left, () {
//             setState(() {
//               currentMonth =
//                   DateTime(currentMonth.year, currentMonth.month - 1);
//             });
//           }),
//           Column(
//             children: [
//               MyRegularText(
//                 label: _getMonthName(currentMonth.month),
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//                 color: light ? Colors.black87 : Colors.white,
//               ),
//               MyRegularText(
//                 label: currentMonth.year.toString(),
//                 fontSize: 14,
//                 color: Colors.grey,
//               ),
//             ],
//           ),
//           _navButton(Icons.chevron_right, () {
//             setState(() {
//               currentMonth =
//                   DateTime(currentMonth.year, currentMonth.month + 1);
//             });
//           }),
//         ],
//       ),
//     );
//   }
//
//   Widget _navButton(IconData icon, VoidCallback onTap) {
//     final light = isLight(context);
//
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         height: 45,
//         width: 45,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: light ? Colors.grey.shade300 : Colors.grey.shade700,
//           ),
//         ),
//         child: Icon(
//           icon,
//           size: 28,
//           color: light ? Colors.black87 : Colors.white,
//         ),
//       ),
//     );
//   }
//
//   /// WEEK DAYS
//   Widget _buildWeekDays() {
//     final weekDays = [
//       'calendar_mon'.tr,
//       'calendar_tue'.tr,
//       'calendar_wed'.tr,
//       'calendar_thu'.tr,
//       'calendar_fri'.tr,
//       'calendar_sat'.tr,
//       'calendar_sun'.tr,
//     ];
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Row(
//         children: weekDays.map((day) {
//           return Expanded(
//             child: Center(
//               child: MyRegularText(
//                 label: day,
//                 fontSize: 12,
//                 color: Colors.grey,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
//
//   /// CALENDAR GRID
//   Widget _buildCalendarGrid() {
//     final daysInMonth =
//         DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
//     final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
//     final startingWeekday = firstDayOfMonth.weekday;
//
//     List<Widget> dayWidgets = [];
//
//     final prevMonthDays =
//         DateTime(currentMonth.year, currentMonth.month, 0).day;
//
//     for (int i = startingWeekday - 1; i > 0; i--) {
//       dayWidgets.add(_buildDayCell(prevMonthDays - i + 1, false));
//     }
//
//     for (int day = 1; day <= daysInMonth; day++) {
//       dayWidgets.add(_buildDayCell(day, true));
//     }
//
//     final remainingCells = 42 - dayWidgets.length;
//     for (int day = 1; day <= remainingCells; day++) {
//       dayWidgets.add(_buildDayCell(day, false));
//     }
//
//     return GridView.count(
//       crossAxisCount: 7,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       childAspectRatio: 0.8,
//       children: dayWidgets,
//     );
//   }
//
//   Widget _buildDayCell(int day, bool isCurrentMonth) {
//     final light = isLight(context);
//
//     final isSelected = isCurrentMonth &&
//         day == selectedDate.day &&
//         currentMonth.month == selectedDate.month &&
//         currentMonth.year == selectedDate.year;
//
//     final dots = eventDots[day] ?? [];
//
//     return InkWell(
//       onTap: isCurrentMonth
//           ? () {
//         setState(() {
//           selectedDate =
//               DateTime(currentMonth.year, currentMonth.month, day);
//         });
//       }
//           : null,
//       child: Column(
//         children: [
//           Container(
//             width: 32,
//             height: 32,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: isSelected ? const Color(0xFF00BCD4) : Colors.transparent,
//             ),
//             child: Center(
//               child: MyRegularText(
//                 label: day.toString(),
//                 fontSize: 15,
//                 color: isSelected
//                     ? Colors.white
//                     : isCurrentMonth
//                     ? (light ? Colors.black87 : Colors.white)
//                     : Colors.grey,
//               ),
//             ),
//           ),
//           const SizedBox(height: 2),
//           if (dots.isNotEmpty)
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: dots.take(3).map((c) {
//                 return Container(
//                   width: 3,
//                   height: 3,
//                   margin: const EdgeInsets.symmetric(horizontal: 0.5),
//                   decoration: BoxDecoration(color: c, shape: BoxShape.circle),
//                 );
//               }).toList(),
//             ),
//         ],
//       ),
//     );
//   }
//
//   /// EVENT CARD
//   Widget _buildEventCard(Map<String, dynamic> event) {
//     final light = isLight(context);
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: light ? Colors.white : const Color(0xFF1A1A1A),
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 14,
//             height: 14,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: event['color'], width: 2.5),
//             ),
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 MyRegularText(
//                   label: event['time'],
//                   fontSize: 12,
//                   color: Colors.grey,
//                 ),
//                 const SizedBox(height: 6),
//                 MyRegularText(
//                   label: event['title'],
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: light ? Colors.black87 : Colors.white,
//                 ),
//                 const SizedBox(height: 6),
//                 MyRegularText(
//                   label: event['subtitle'],
//                   fontSize: 13,
//                   color: Colors.grey,
//                   maxlines: 1,
//                 ),
//               ],
//             ),
//           ),
//           Icon(Icons.more_horiz, color: Colors.grey),
//         ],
//       ),
//     );
//   }
//
//   String _getMonthName(int month) {
//     const months = [
//       'month_january',
//       'month_february',
//       'month_march',
//       'month_april',
//       'month_may',
//       'month_june',
//       'month_july',
//       'month_august',
//       'month_september',
//       'month_october',
//       'month_november',
//       'month_december',
//     ];
//     return months[month - 1].tr;
//   }
// }
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicorn/core/widget/my_regular_text.dart';
import 'package:unicorn/core/widget/empty_state.dart';

import '../../home/view/report/controller/report_controller.dart';
import '../../home/view/report/model/teacher_holiday_event_list/teacher_holiday_event_list_response.dart';

class TeacherCalendarScreen extends StatefulWidget {
  const TeacherCalendarScreen({super.key});

  @override
  State<TeacherCalendarScreen> createState() => _TeacherCalendarScreenState();
}

class _TeacherCalendarScreenState extends State<TeacherCalendarScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime currentMonth = DateTime(DateTime.now().year, DateTime.now().month);

  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  final ReportController controller = Get.put(ReportController());

  // ── Color palette per event type ──────────────────────────────────────────
  Color _colorForType(String? type) {
    switch ((type ?? '').toUpperCase()) {
      case 'HOLIDAY':
        return const Color(0xFF00C853);
      case 'EVENT':
        return const Color(0xFF2979FF);
      case 'EXAM':
        return const Color(0xFF7C4DFF);
      case 'MEETING':
        return const Color(0xFFFF6D00);
      default:
        return const Color(0xFF00BCD4);
    }
  }

  // ── Build dot map  {day → [colors]} for current month ────────────────────
  Map<int, List<Color>> _buildEventDots(
      List<TeacherHolidayListElement> eventList) {
    final Map<int, Set<Color>> dotMap = {};

    for (final event in eventList) {
      final start = _parseDate(event.startDate); // ← fixed
      if (start == null) continue;

      final end = _parseDate(event.endDate) ?? start; // ← fixed

      for (DateTime d = start;
      !d.isAfter(end);
      d = d.add(const Duration(days: 1))) {
        if (d.year == currentMonth.year && d.month == currentMonth.month) {
          dotMap.putIfAbsent(d.day, () => {}).add(_colorForType(event.type));
        }
      }
    }

    return dotMap.map((day, colors) => MapEntry(day, colors.toList()));
  }

  // ── Events for the selected date ─────────────────────────────────────────
  List<TeacherHolidayListElement> _eventsForSelectedDate(
      List<TeacherHolidayListElement> eventList) {
    return eventList.where((event) {
      final start = _parseDate(event.startDate); // ← fixed
      if (start == null) return false;

      final end = _parseDate(event.endDate) ?? start; // ← fixed

      final sel = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      final s = DateTime(start.year, start.month, start.day);
      final e = DateTime(end.year, end.month, end.day);

      return !sel.isBefore(s) && !sel.isAfter(e);
    }).toList();
  }
  // ── Formatted display time ────────────────────────────────────────────────
  String _displayTime(TeacherHolidayListElement event) {
    if (event.time != null && event.time!.isNotEmpty) return event.time!;
    final parts = <String>[];
    if (event.startDate != null) {
      try {
        final d = DateTime.parse(event.startDate!);
        parts.add(
            '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}');
      } catch (_) {}
    }
    return parts.join(' – ');
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      controller.teacherHolidayEventListing(context, isRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    return Scaffold(
      backgroundColor: light ? Colors.white : const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Obx(() {
          final eventList = controller.eventList;
          final dots = _buildEventDots(eventList);
          final selectedEvents = _eventsForSelectedDate(eventList);

          return EasyRefresh(
            header: const ClassicHeader(showText: false),
            footer: const ClassicFooter(showText: false),
            onRefresh: () async {
              await controller.teacherHolidayEventListing(context, isRefresh: true);
            },
            child: CustomScrollView(
              slivers: [
                // ── CALENDAR ────────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                      light ? Colors.white : const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: light
                          ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ]
                          : [],
                    ),
                    child: Column(
                      children: [
                        _buildCalendarHeader(),
                        _buildWeekDays(),
                        _buildCalendarGrid(dots),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // ── SELECTED DATE LABEL ──────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    child: Row(
                      children: [
                        MyRegularText(
                          label:
                          '${selectedDate.day} ${_getMonthName(selectedDate.month)} ${selectedDate.year}',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color:
                          light ? Colors.black87 : Colors.white,
                        ),
                        // const SizedBox(width: 8),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 8, vertical: 2),
                        //   decoration: BoxDecoration(
                        //     color: const Color(0xFF00BCD4).withOpacity(0.15),
                        //     borderRadius: BorderRadius.circular(20),
                        //   ),
                        //   child: MyRegularText(
                        //     label:
                        //     '${selectedEvents.length} ${'events'.tr}',
                        //     fontSize: 12,
                        //     color: const Color(0xFF00BCD4),
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 8)),

                // ── LOADING ──────────────────────────────────────────────────
                if (controller.isLoading.value)
                  const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )

                // ── EMPTY ────────────────────────────────────────────────────
                else if (selectedEvents.isEmpty)
                SliverToBoxAdapter(
                  child: const EmptyState(),
                )

                // ── EVENT CARDS ──────────────────────────────────────────────
                else
                  SliverPadding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) =>
                            _buildEventCard(selectedEvents[index]),
                        childCount: selectedEvents.length,
                      ),
                    ),
                  ),

                // ── LOAD MORE ────────────────────────────────────────────────
                if (controller.isLoadMore.value)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ── CALENDAR HEADER ────────────────────────────────────────────────────────
  Widget _buildCalendarHeader() {
    final light = isLight(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _navButton(Icons.chevron_left, () {
            setState(() {
              currentMonth =
                  DateTime(currentMonth.year, currentMonth.month - 1);
            });
          }),
          Column(
            children: [
              MyRegularText(
                label: _getMonthName(currentMonth.month),
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: light ? Colors.black87 : Colors.white,
              ),
              GestureDetector(
                onTap: _showYearPicker,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyRegularText(
                      label: currentMonth.year.toString(),
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
          _navButton(Icons.chevron_right, () {
            setState(() {
              currentMonth =
                  DateTime(currentMonth.year, currentMonth.month + 1);
            });
          }),
        ],
      ),
    );
  }
  void _showYearPicker() {
    final currentYear = DateTime.now().year;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            height: 300,
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              itemCount: 50, // range of years
              itemBuilder: (context, index) {
                final year = currentYear - 25 + index;

                final isSelected = year == currentMonth.year;

                return ListTile(
                  title: Text(
                    year.toString(),
                    style: TextStyle(
                      fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? const Color(0xFF00BCD4)
                          : Colors.black,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      currentMonth =
                          DateTime(year, currentMonth.month);
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
  Widget _navButton(IconData icon, VoidCallback onTap) {
    final light = isLight(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: light
                ? Colors.grey.shade300
                : Colors.grey.shade700,
          ),
        ),
        child: Icon(icon,
            size: 28,
            color: light ? Colors.black87 : Colors.white),
      ),
    );
  }

  // ── WEEK DAYS ROW ──────────────────────────────────────────────────────────
  Widget _buildWeekDays() {
    final weekDays = [
      'calendar_mon'.tr,
      'calendar_tue'.tr,
      'calendar_wed'.tr,
      'calendar_thu'.tr,
      'calendar_fri'.tr,
      'calendar_sat'.tr,
      'calendar_sun'.tr,
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: weekDays.map((day) {
          return Expanded(
            child: Center(
              child: MyRegularText(
                label: day,
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── CALENDAR GRID ──────────────────────────────────────────────────────────
  Widget _buildCalendarGrid(Map<int, List<Color>> dots) {
    final daysInMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final firstDayOfMonth =
    DateTime(currentMonth.year, currentMonth.month, 1);
    final startingWeekday = firstDayOfMonth.weekday;
    final prevMonthDays =
        DateTime(currentMonth.year, currentMonth.month, 0).day;

    List<Widget> dayWidgets = [];

    // Previous month filler
    for (int i = startingWeekday - 1; i > 0; i--) {
      dayWidgets.add(_buildDayCell(prevMonthDays - i + 1, false, dots));
    }

    // Current month days
    for (int day = 1; day <= daysInMonth; day++) {
      dayWidgets.add(_buildDayCell(day, true, dots));
    }

    // Next month filler
    final remaining = 42 - dayWidgets.length;
    for (int day = 1; day <= remaining; day++) {
      dayWidgets.add(_buildDayCell(day, false, dots));
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.8,
      children: dayWidgets,
    );
  }

  Widget _buildDayCell(
      int day, bool isCurrentMonth, Map<int, List<Color>> dots) {
    final light = isLight(context);
    final disabledTextColor =
        (light ? Colors.black87 : Colors.white).withOpacity(0.28);

    final isSelected = isCurrentMonth &&
        day == selectedDate.day &&
        currentMonth.month == selectedDate.month &&
        currentMonth.year == selectedDate.year;

    final today = DateTime.now();
    final isToday = isCurrentMonth &&
        day == today.day &&
        currentMonth.month == today.month &&
        currentMonth.year == today.year;

    final cellDots = isCurrentMonth ? (dots[day] ?? []) : [];

    return InkWell(
      onTap: isCurrentMonth
          ? () {
        setState(() {
          selectedDate = DateTime(
              currentMonth.year, currentMonth.month, day);
        });
      }
          : null,
      child: Opacity(
        opacity: isCurrentMonth ? 1 : 0.45,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? const Color(0xFF00BCD4)
                  : Colors.transparent,
              border: isToday && !isSelected
                  ? Border.all(
                  color: const Color(0xFF00BCD4), width: 1.5)
                  : null,
            ),
            child: Center(
              child: MyRegularText(
                label: day.toString(),
                fontSize: 13,
                fontWeight: isToday || isSelected
                    ? FontWeight.w700
                    : FontWeight.w400,
                color: isSelected
                    ? Colors.white
                    : isCurrentMonth
                    ? (light ? Colors.black87 : Colors.white)
                    : disabledTextColor,
              ),
            ),
          ),
          const SizedBox(height: 3),
          // ── dots row ────────────────────────────────────────────
          SizedBox(
            height: 6,
            child: cellDots.isNotEmpty
                ? Row(
              mainAxisSize: MainAxisSize.min,
              children: (cellDots as List<Color>)
                  .take(3)
                  .map(
                    (c) => Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 0.8),
                  decoration: BoxDecoration(
                      color: c, shape: BoxShape.circle),
                ),
              )
                  .toList(),
            )
                : const SizedBox.shrink(),
          ),
        ],
        ),
      ),
    );
  }
  List<String> _getAudienceLabels(TeacherHolidayListElement event) {
    final List<String> audience = [];

    if (event.student == true) audience.add('Student');
    if (event.teacher == true) audience.add('Teacher');

    return audience;
  }
  // ── EVENT CARD ─────────────────────────────────────────────────────────────
  Widget _buildEventCard(TeacherHolidayListElement event) {
    final light = isLight(context);
    final color = _colorForType(event.type);
    final audienceList = _getAudienceLabels(event);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: light ? Colors.white : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        boxShadow: light
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── TOP ROW (dot + time + menu) ─────────────────────────
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: MyRegularText(
                  label: _displayTime(event),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),

              GestureDetector(
                  onTap: () {
                    _showEventDialog(event);
                  },
                  child: Icon(Icons.more_horiz, size: 20, color: Colors.grey)),
            ],
          ),

          const SizedBox(height: 10),

          // ── TITLE ───────────────────────────────────────────────
          MyRegularText(
            label: event.name ?? '–',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: light ? Colors.black87 : Colors.white,
          ),

          const SizedBox(height: 6),

          // ── SUBTITLE (time description) ─────────────────────────
          if ((event.time ?? '').isNotEmpty)
            MyRegularText(
              label: "Start from ${event.time}",
              fontSize: 13,
              color: Colors.grey.shade500,
            ),

          // ── AUDIENCE ────────────────────────────────────────────
          if (audienceList.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              children: audienceList.map((aud) {
                return Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: MyRegularText(
                    label: aud,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
  void _showEventDialog(TeacherHolidayListElement event) {
    final color = _colorForType(event.type);

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (context) {
        final light = isLight(context);
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          clipBehavior: Clip.antiAlias,
          backgroundColor: light ? Colors.white : const Color(0xFF1E1E2E),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // ── Header Banner ──────────────────────────────────────────────
              Container(
                color: color,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Icon + close button row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.event_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Event name
                    Text(
                      event.name ?? '–',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 14),

                    // Type badge
                    if (event.type != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.85),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              event.type!.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              // ── Detail Rows ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                child: Column(
                  children: [
                    _dialogRow(
                      icon: Icons.access_time_rounded,
                      iconColor: color,
                      title: 'time'.tr,
                      value: event.time ?? '–',
                      light: light,
                    ),
                    _dialogRow(
                      icon: Icons.calendar_today_rounded,
                      iconColor: color,
                      title: 'start_date'.tr,
                      value: event.startDate ?? '–',
                      light: light,
                    ),
                    _dialogRow(
                      icon: Icons.event_available_rounded,
                      iconColor: color,
                      title: 'end_date'.tr,
                      value: event.endDate ?? '–',
                      light: light,
                      showDivider: (event.description ?? '').isNotEmpty,
                    ),
                    if ((event.description ?? '').isNotEmpty)
                      _dialogRow(
                        icon: Icons.notes_rounded,
                        iconColor: color,
                        title: 'description'.tr,
                        value: event.description!,
                        light: light,
                        showDivider: false,
                      ),
                  ],
                ),
              ),

              // ── Close Button ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: color.withOpacity(0.1),
                    foregroundColor: color,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'close'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _dialogRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required bool light,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 11,
                        color: light
                            ? Colors.grey.shade500
                            : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: light
                            ? const Color(0xFF1A1A2E)
                            : Colors.white,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 0.5,
            color: light
                ? Colors.grey.shade100
                : Colors.white.withOpacity(0.06),
          ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'month_january',
      'month_february',
      'month_march',
      'month_april',
      'month_may',
      'month_june',
      'month_july',
      'month_august',
      'month_september',
      'month_october',
      'month_november',
      'month_december',
    ];
    return months[month - 1].tr;
  }
  /// Parses "dd-MM-yyyy" OR standard "yyyy-MM-dd" safely
  DateTime? _parseDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      // API format: dd-MM-yyyy  e.g. "27-02-2026"
      final parts = raw.split('-');
      if (parts.length == 3 && parts[0].length == 2) {
        return DateTime(
          int.parse(parts[2]), // year
          int.parse(parts[1]), // month
          int.parse(parts[0]), // day
        );
      }
      // fallback: standard ISO format
      return DateTime.parse(raw);
    } catch (_) {
      return null;
    }
  }
}
