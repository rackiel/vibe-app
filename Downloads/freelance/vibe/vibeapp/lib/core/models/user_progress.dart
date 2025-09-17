class UserProgress {
  final int? id;
  final String userId;
  final String activityType; // 'gesture', 'game', 'story', 'audio_visual'
  final String activityId;
  final int progress; // 0-100
  final int timeSpent; // in seconds
  final DateTime completedAt;
  final Map<String, dynamic> metadata; // Additional data like scores, achievements

  UserProgress({
    this.id,
    required this.userId,
    required this.activityType,
    required this.activityId,
    required this.progress,
    required this.timeSpent,
    required this.completedAt,
    this.metadata = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'activity_type': activityType,
      'activity_id': activityId,
      'progress': progress,
      'time_spent': timeSpent,
      'completed_at': completedAt.millisecondsSinceEpoch,
      'metadata': metadata.toString(),
    };
  }

  factory UserProgress.fromMap(Map<String, dynamic> map) {
    return UserProgress(
      id: map['id'],
      userId: map['user_id'],
      activityType: map['activity_type'],
      activityId: map['activity_id'],
      progress: map['progress'],
      timeSpent: map['time_spent'],
      completedAt: DateTime.fromMillisecondsSinceEpoch(map['completed_at']),
      metadata: Map<String, dynamic>.from(map['metadata'] ?? {}),
    );
  }

  UserProgress copyWith({
    int? id,
    String? userId,
    String? activityType,
    String? activityId,
    int? progress,
    int? timeSpent,
    DateTime? completedAt,
    Map<String, dynamic>? metadata,
  }) {
    return UserProgress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      activityType: activityType ?? this.activityType,
      activityId: activityId ?? this.activityId,
      progress: progress ?? this.progress,
      timeSpent: timeSpent ?? this.timeSpent,
      completedAt: completedAt ?? this.completedAt,
      metadata: metadata ?? this.metadata,
    );
  }
}
