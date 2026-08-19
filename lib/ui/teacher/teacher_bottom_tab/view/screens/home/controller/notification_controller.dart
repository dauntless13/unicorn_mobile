import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../service/api_service/api_worker.dart';
import '../model/notification_list/notification_list_response.dart';

enum NotificationFilter { all, unread }

class NotificationController extends GetxController {
  final ApiWorker _api = ApiWorker();
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasError = false.obs;
  final notifications = <NotificationUserData>[].obs;
  final filter = NotificationFilter.all.obs;

  int currentPage = 1;
  bool canLoadMore = true;

  List<NotificationUserData> get visibleNotifications {
    if (filter.value == NotificationFilter.unread) {
      return notifications.where((item) => !item.isRead).toList();
    }
    return notifications;
  }

  int get unreadCount => notifications.where((item) => !item.isRead).length;

  Future<void> getNotifications(
    BuildContext context, {
    bool refresh = false,
  }) async {
    if (refresh) {
      currentPage = 1;
      canLoadMore = true;
      hasError.value = false;
    } else if (isLoading.value || isLoadingMore.value) {
      return;
    }

    if (currentPage == 1) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await _api.notificationList(
        context,
        page: currentPage,
        limit: 50,
      );

      final list = response?.data?.list ?? [];
      if (refresh || currentPage == 1) {
        notifications.value = list;
      } else {
        notifications.addAll(list);
      }

      final pagination = response?.data?.pagination;
      canLoadMore =
          (pagination?.currentPage ?? currentPage) <
          (pagination?.totalPages ?? 1);
      if (list.isNotEmpty) currentPage++;
      hasError.value = false;
    } catch (e) {
      hasError.value = notifications.isEmpty;
      debugPrint('Notification Error: $e');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<bool> loadMore(BuildContext context) async {
    if (!canLoadMore || isLoading.value || isLoadingMore.value) return false;
    await getNotifications(context);
    return canLoadMore;
  }

  void setFilter(NotificationFilter value) {
    filter.value = value;
  }

  Future<void> markOneRead(BuildContext context, NotificationUserData item) async {
    if (item.isRead || item.id == null) return;
    item.isRead = true;
    notifications.refresh();
    try {
      await _api.markNotificationRead(
        context,
        id: item.id!,
        isRead: true,
      );
    } catch (e) {
      item.isRead = false;
      notifications.refresh();
      debugPrint('Mark notification read error: $e');
    }
  }

  Future<void> markAllRead(BuildContext context) async {
    if (unreadCount == 0) return;
    for (final item in notifications) {
      item.isRead = true;
    }
    notifications.refresh();
    try {
      await _api.markAllNotificationsRead(context);
    } catch (e) {
      debugPrint('Mark all notifications read error: $e');
      await getNotifications(context, refresh: true);
    }
  }
}
