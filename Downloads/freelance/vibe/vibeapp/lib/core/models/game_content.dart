import 'package:flutter/material.dart';

enum GameType {
  learning,
  story,
  puzzle,
  interactive,
  quiz,
}

enum DifficultyLevel {
  beginner,
  intermediate,
  advanced,
  expert,
}

class GameContent {
  final String id;
  final String title;
  final String description;
  final GameType type;
  final DifficultyLevel difficulty;
  final List<String> tags;
  final String? thumbnailPath;
  final String? videoPath;
  final Duration estimatedDuration;
  final int maxScore;
  final Map<String, dynamic>? metadata;

  const GameContent({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.tags,
    this.thumbnailPath,
    this.videoPath,
    required this.estimatedDuration,
    required this.maxScore,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'difficulty': difficulty.name,
      'tags': tags,
      'thumbnailPath': thumbnailPath,
      'videoPath': videoPath,
      'estimatedDuration': estimatedDuration.inMilliseconds,
      'maxScore': maxScore,
      'metadata': metadata,
    };
  }

  factory GameContent.fromJson(Map<String, dynamic> json) {
    return GameContent(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: GameType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => GameType.learning,
      ),
      difficulty: DifficultyLevel.values.firstWhere(
        (e) => e.name == json['difficulty'],
        orElse: () => DifficultyLevel.beginner,
      ),
      tags: List<String>.from(json['tags'] ?? []),
      thumbnailPath: json['thumbnailPath'],
      videoPath: json['videoPath'],
      estimatedDuration: Duration(milliseconds: json['estimatedDuration']),
      maxScore: json['maxScore'] ?? 100,
      metadata: json['metadata'],
    );
  }
}

class StoryElement {
  final String id;
  final String text;
  final String? imagePath;
  final String? videoPath;
  final String? signLanguageVideo;
  final Duration? displayDuration;
  final List<String>? choices;
  final Map<String, dynamic>? metadata;

  const StoryElement({
    required this.id,
    required this.text,
    this.imagePath,
    this.videoPath,
    this.signLanguageVideo,
    this.displayDuration,
    this.choices,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'imagePath': imagePath,
      'videoPath': videoPath,
      'signLanguageVideo': signLanguageVideo,
      'displayDuration': displayDuration?.inMilliseconds,
      'choices': choices,
      'metadata': metadata,
    };
  }

  factory StoryElement.fromJson(Map<String, dynamic> json) {
    return StoryElement(
      id: json['id'],
      text: json['text'],
      imagePath: json['imagePath'],
      videoPath: json['videoPath'],
      signLanguageVideo: json['signLanguageVideo'],
      displayDuration: json['displayDuration'] != null
          ? Duration(milliseconds: json['displayDuration'])
          : null,
      choices: json['choices'] != null ? List<String>.from(json['choices']) : null,
      metadata: json['metadata'],
    );
  }
}

class UserProgress {
  final String userId;
  final String contentId;
  final int score;
  final Duration timeSpent;
  final DateTime completedAt;
  final Map<String, dynamic>? performanceData;

  const UserProgress({
    required this.userId,
    required this.contentId,
    required this.score,
    required this.timeSpent,
    required this.completedAt,
    this.performanceData,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'contentId': contentId,
      'score': score,
      'timeSpent': timeSpent.inMilliseconds,
      'completedAt': completedAt.millisecondsSinceEpoch,
      'performanceData': performanceData,
    };
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      userId: json['userId'],
      contentId: json['contentId'],
      score: json['score'],
      timeSpent: Duration(milliseconds: json['timeSpent']),
      completedAt: DateTime.fromMillisecondsSinceEpoch(json['completedAt']),
      performanceData: json['performanceData'],
    );
  }
}
