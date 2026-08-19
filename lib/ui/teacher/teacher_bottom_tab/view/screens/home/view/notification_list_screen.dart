import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../core/ColorUtils.dart';
import '../../../../../../../core/widget/back_button.dart';
import '../../../../../../../core/widget/empty_state.dart';
import '../../../../../../../service/notification_service/FirebaseNotificationService.dart';
import '../controller/notification_controller.dart';
import '../model/notification_list/notification_list_response.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late final NotificationController ctrl;
  late final EasyRefreshController _refreshCtrl;

  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<NotificationController>()) {
      Get.delete<NotificationController>();
    }
    ctrl = Get.put(NotificationController());
    _refreshCtrl = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctrl.getNotifications(context, refresh: true);
    });
  }

  @override
  void dispose() {
    _refreshCtrl.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await ctrl.getNotifications(context, refresh: true);
    _refreshCtrl.finishRefresh();
    _refreshCtrl.resetFooter();
  }

  Future<void> _onLoad() async {
    final hasMore = await ctrl.loadMore(context);
    _refreshCtrl.finishLoad(
      hasMore ? IndicatorResult.success : IndicatorResult.noMore,
    );
  }

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    return Scaffold(
      backgroundColor: light ? const Color(0xFFF6F8FB) : const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
              child: Row(
                children: [
                  appBackButton(context),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Notifications'.tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: light ? const Color(0xFF0F172A) : Colors.white,
                      ),
                    ),
                  ),
                  Obx(() {
                    if (ctrl.unreadCount == 0) return const SizedBox.shrink();
                    return TextButton(
                      onPressed: () => ctrl.markAllRead(context),
                      child: Text(
                        'mark_all_read'.tr,
                        style: const TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Obx(() => Row(
                    children: [
                      _FilterChip(
                        label: 'all_notifications'.tr,
                        selected: ctrl.filter.value == NotificationFilter.all,
                        count: ctrl.notifications.length,
                        onTap: () => ctrl.setFilter(NotificationFilter.all),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'unread'.tr,
                        selected: ctrl.filter.value == NotificationFilter.unread,
                        count: ctrl.unreadCount,
                        onTap: () => ctrl.setFilter(NotificationFilter.unread),
                      ),
                    ],
                  )),
            ),
            Expanded(
              child: Obx(() {
                if (ctrl.isLoading.value && ctrl.notifications.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (ctrl.hasError.value && ctrl.notifications.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'failed_to_load_notifications'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: light
                                  ? const Color(0xFF64748B)
                                  : Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () =>
                                ctrl.getNotifications(context, refresh: true),
                            child: Text(
                              'retry'.tr,
                              style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final items = ctrl.visibleNotifications;
                if (items.isEmpty) {
                  return EasyRefresh(
                    controller: _refreshCtrl,
                    onRefresh: _onRefresh,
                    header: const ClassicHeader(showText: false),
                    child: ListView(
                      children: const [
                        SizedBox(height: 80),
                        EmptyState(),
                      ],
                    ),
                  );
                }

                return EasyRefresh(
                  controller: _refreshCtrl,
                  onRefresh: _onRefresh,
                  onLoad: _onLoad,
                  header: const ClassicHeader(showText: false),
                  footer: const ClassicFooter(showText: false),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return _NotificationCard(
                        item: items[index],
                        light: light,
                        onTap: () async {
                          await ctrl.markOneRead(context, items[index]);
                          await FirebaseNotificationService
                              .navigateFromNotification(
                            type: items[index].type ?? '',
                            id: items[index].navigationId,
                          );
                        },
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final int count;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? primaryColor
                : (light ? Colors.white : const Color(0xFF1A1A1A)),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? primaryColor
                  : (light ? const Color(0xFFE2E8F0) : Colors.white12),
            ),
          ),
          child: Text(
            '$label ($count)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: selected
                  ? Colors.white
                  : (light ? const Color(0xFF1E293B) : Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationUserData item;
  final bool light;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.item,
    required this.light,
    required this.onTap,
  });

  IconData get _icon {
    switch ((item.type ?? '').toUpperCase()) {
      case 'ACTIVITY':
        return Icons.sports_soccer_outlined;
      case 'REPORT':
        return Icons.assignment_outlined;
      case 'POST':
        return Icons.photo_outlined;
      case 'EVENT':
      case 'HOLIDAY':
        return Icons.event_outlined;
      case 'LEAVE':
        return Icons.event_busy_outlined;
      case 'FEES':
      case 'BILLING':
        return Icons.payments_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  String get _typeLabel {
    final key = (item.type ?? '').toUpperCase();
    if (key.isEmpty) return 'notification'.tr;
    return key.toLowerCase().tr;
  }

  @override
  Widget build(BuildContext context) {
    final unread = !item.isRead;
    final when = [
      if ((item.date ?? '').isNotEmpty) item.date,
      if ((item.time ?? '').isNotEmpty) item.time,
    ].join(' · ');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: unread
                ? (light
                    ? primaryColor.withOpacity(0.08)
                    : primaryColor.withOpacity(0.18))
                : (light ? Colors.white : const Color(0xFF1A1A1A)),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: unread
                  ? primaryColor.withOpacity(0.35)
                  : (light ? const Color(0xFFE2E8F0) : Colors.white12),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: primaryColor,
                    child: Icon(_icon, color: Colors.white, size: 18),
                  ),
                  if (unread)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _typeLabel,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (when.isNotEmpty)
                          Text(
                            when,
                            style: TextStyle(
                              fontSize: 11,
                              color: light
                                  ? const Color(0xFF94A3B8)
                                  : Colors.white54,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.title ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: light ? const Color(0xFF0F172A) : Colors.white,
                      ),
                    ),
                    if ((item.message ?? '').isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.message ?? '',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.35,
                          color: light
                              ? const Color(0xFF475569)
                              : Colors.white70,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
