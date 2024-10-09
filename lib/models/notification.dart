class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String processFrom;
  final String createdBy;
  final String sendTo;
  final int read;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.processFrom,
    required this.createdBy,
    required this.sendTo,
    required this.read,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      processFrom: json['process_from'] ?? '',
      createdBy: json['created_by'] ?? '',
      sendTo: json['send_to'] ?? '',
      read: json['is_read'], // Convert 1 to true, 0 to false
    );
  }
}

class NotificationResponse {
  final String createdAt;
  final List<NotificationModel> notifications;

  NotificationResponse({
    required this.createdAt,
    required this.notifications,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    var notificationList = json['notifications'] as List;
    List<NotificationModel> notifications =
        notificationList.map((e) => NotificationModel.fromJson(e)).toList();
    return NotificationResponse(
      createdAt: json['created_at'],
      notifications: notifications,
    );
  }
}
