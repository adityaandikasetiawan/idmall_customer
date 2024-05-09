class NotificationModel {
  final String title;
  final String message;
  final String processFrom;
  final String createdBy;

  NotificationModel({
    required this.title,
    required this.message,
    required this.processFrom,
    required this.createdBy,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'] ?? "",
      message: json['message'] ?? "",
      processFrom: json['processFrom'] ?? "",
      createdBy: json['createdBy'] ?? "",
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
