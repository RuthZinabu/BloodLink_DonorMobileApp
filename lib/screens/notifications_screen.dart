import 'package:bloodlink_donor_mobile_app/models/app_notification.dart';
import 'package:bloodlink_donor_mobile_app/services/notification_service.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _notificationService = NotificationService();
  bool _isLoading = true;
  String? _errorMessage;
  List<AppNotification> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final notifications = await _notificationService.fetchNotifications();
      if (!mounted) return;
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      var message =
          'Unable to load notifications right now. Please try again later.';
      final errorMessage = error.toString().toLowerCase();
      if (errorMessage.contains('authentication required')) {
        message =
            'Unable to load notifications. Please sign in again and retry.';
      } else if (errorMessage.contains('network error')) {
        message =
            'Unable to load notifications. Please check your connection and try again.';
      }
      setState(() {
        _errorMessage = message;
        _isLoading = false;
      });
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    try {
      await _notificationService.markNotificationAsRead(notificationId);
      setState(() {
        final index = _notifications
            .indexWhere((n) => n.notificationId == notificationId);
        if (index != -1) {
          _notifications[index] = _notifications[index].copyWith(isRead: true);
        }
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to mark notification as read')),
      );
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await _notificationService.markAllNotificationsAsRead();
      setState(() {
        _notifications =
            _notifications.map((n) => n.copyWith(isRead: true)).toList();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All notifications marked as read')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to mark all notifications as read')),
      );
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'EMERGENCY':
        return AppColors.warning;
      case 'CAMPAIGN':
        return AppColors.primary;
      case 'TEST_RESULT':
        return AppColors.secondary;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'EMERGENCY':
        return Icons.warning;
      case 'CAMPAIGN':
        return Icons.campaign;
      case 'TEST_RESULT':
        return Icons.science;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Notifications'),
          elevation: 0,
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          actions: [
            if (_notifications.any((n) => !n.isRead))
              TextButton(
                onPressed: _markAllAsRead,
                child: Text(
                  'Mark All Read',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: responsive.getPadding(20),
              vertical: responsive.getPadding(16)),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body
                                .copyWith(color: AppColors.warning),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadNotifications,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : _notifications.isEmpty
                      ? Center(
                          child: Text(
                            'No notifications yet. You will be notified about campaigns, emergencies, and test results.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body,
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadNotifications,
                          child: ListView.separated(
                            itemCount: _notifications.length,
                            separatorBuilder: (_, __) => SizedBox(
                                height: responsive.getSpacing(
                                    small: 8, medium: 10, large: 12)),
                            itemBuilder: (context, index) {
                              final notification = _notifications[index];
                              return Dismissible(
                                key: Key(notification.notificationId),
                                direction: notification.isRead
                                    ? DismissDirection.none
                                    : DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: AppColors.white,
                                  ),
                                ),
                                onDismissed: (direction) {
                                  _markAsRead(notification.notificationId);
                                },
                                child: Container(
                                  padding:
                                      EdgeInsets.all(responsive.getPadding(16)),
                                  decoration: BoxDecoration(
                                    color: notification.isRead
                                        ? AppColors.surface
                                        : AppColors.white,
                                    borderRadius: BorderRadius.circular(
                                        responsive.getBorderRadius(12)),
                                    border: notification.isRead
                                        ? null
                                        : Border.all(
                                            color: _getNotificationColor(
                                                    notification.type)
                                                .withOpacity(0.3),
                                            width: 1,
                                          ),
                                    boxShadow: notification.isRead
                                        ? null
                                        : [
                                            BoxShadow(
                                              color: _getNotificationColor(
                                                      notification.type)
                                                  .withOpacity(0.1),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: responsive.getWidth(12),
                                        height: responsive.getWidth(12),
                                        decoration: BoxDecoration(
                                          color: _getNotificationColor(
                                                  notification.type)
                                              .withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          _getNotificationIcon(
                                              notification.type),
                                          color: _getNotificationColor(
                                              notification.type),
                                          size: responsive.getFont(16),
                                        ),
                                      ),
                                      SizedBox(
                                          width: responsive.getSpacing(
                                              small: 12,
                                              medium: 14,
                                              large: 16)),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    notification.title,
                                                    style: AppTextStyles.title
                                                        .copyWith(
                                                      fontSize: responsive
                                                          .getFont(16),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: notification.isRead
                                                          ? AppColors
                                                              .textSecondary
                                                          : AppColors
                                                              .textPrimary,
                                                    ),
                                                  ),
                                                ),
                                                if (!notification.isRead)
                                                  Container(
                                                    width: 8,
                                                    height: 8,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: AppColors.primary,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              notification.message,
                                              style:
                                                  AppTextStyles.body.copyWith(
                                                fontSize:
                                                    responsive.getFont(14),
                                                color: notification.isRead
                                                    ? AppColors.textSecondary
                                                    : AppColors.textPrimary,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        _getNotificationColor(
                                                                notification
                                                                    .type)
                                                            .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Text(
                                                    notification.type,
                                                    style: AppTextStyles
                                                        .subtitle
                                                        .copyWith(
                                                      fontSize: responsive
                                                          .getFont(10),
                                                      color:
                                                          _getNotificationColor(
                                                              notification
                                                                  .type),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  _formatDate(
                                                      notification.createdAt),
                                                  style: AppTextStyles.subtitle
                                                      .copyWith(
                                                    fontSize:
                                                        responsive.getFont(12),
                                                    color:
                                                        AppColors.textSecondary,
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
                            },
                          ),
                        ),
        ),
      ),
    );
  }
}
