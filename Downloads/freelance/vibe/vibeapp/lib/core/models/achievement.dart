class Achievement {
  final int? id;
  final String title;
  final String description;
  final String iconPath;
  final String category; // 'gesture', 'game', 'story', 'time', 'streak'
  final int points;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final Map<String, dynamic> requirements;

  Achievement({
    this.id,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.category,
    required this.points,
    this.isUnlocked = false,
    this.unlockedAt,
    this.requirements = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon_path': iconPath,
      'category': category,
      'points': points,
      'is_unlocked': isUnlocked ? 1 : 0,
      'unlocked_at': unlockedAt?.millisecondsSinceEpoch,
      'requirements': requirements.toString(),
    };
  }

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      iconPath: map['icon_path'],
      category: map['category'],
      points: map['points'],
      isUnlocked: map['is_unlocked'] == 1,
      unlockedAt: map['unlocked_at'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['unlocked_at'])
          : null,
      requirements: Map<String, dynamic>.from(map['requirements'] ?? {}),
    );
  }

  Achievement copyWith({
    int? id,
    String? title,
    String? description,
    String? iconPath,
    String? category,
    int? points,
    bool? isUnlocked,
    DateTime? unlockedAt,
    Map<String, dynamic>? requirements,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      category: category ?? this.category,
      points: points ?? this.points,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      requirements: requirements ?? this.requirements,
    );
  }
}
