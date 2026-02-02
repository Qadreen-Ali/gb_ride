class RatingModel {
  final String id;
  final String rideId;
  final String raterId;
  final String ratedUserId;
  final int rating;
  final List<String> tags;
  final int? tip;
  final String? comment;
  final DateTime? createdAt;

  RatingModel({
    required this.id,
    required this.rideId,
    required this.raterId,
    required this.ratedUserId,
    required this.rating,
    this.tags = const [],
    this.tip,
    this.comment,
    this.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    final tagsRaw = json['tags'];
    List<String> tagsList = [];
    if (tagsRaw is List) tagsList = tagsRaw.map((e) => e.toString()).toList();
    return RatingModel(
      id: json['id'] as String,
      rideId: json['ride_id'] as String,
      raterId: json['rater_id'] as String,
      ratedUserId: json['rated_user_id'] as String,
      rating: (json['rating'] as num).toInt(),
      tags: tagsList,
      tip: json['tip'] as int?,
      comment: json['comment'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'ride_id': rideId,
    'rater_id': raterId,
    'rated_user_id': ratedUserId,
    'rating': rating,
    'tags': tags,
    'tip': tip,
    'comment': comment,
    'created_at': createdAt?.toIso8601String(),
  };
}