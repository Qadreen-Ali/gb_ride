class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type; // as schema
  final String? relatedId;
  final bool isRead;
  final DateTime? createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.relatedId,
    this.isRead = false,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    title: json['title'] as String,
    message: json['message'] as String,
    type: json['type'] as String,
    relatedId: json['related_id'] as String?,
    isRead: (json['is_read'] ?? false) as bool,
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'title': title,
    'message': message,
    'type': type,
    'related_id': relatedId,
    'is_read': isRead,
    'created_at': createdAt?.toIso8601String(),
  };
}