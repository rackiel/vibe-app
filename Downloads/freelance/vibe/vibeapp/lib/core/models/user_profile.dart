import 'package:flutter/material.dart';

enum HearingLevel {
  mild,
  moderate,
  severe,
  profound,
}

enum PreferredLanguage {
  english,
  spanish,
  french,
  asl, // American Sign Language
}

class AccessibilityProfile {
  final String id;
  final String name;
  final HearingLevel hearingLevel;
  final PreferredLanguage preferredLanguage;
  final bool enableHapticFeedback;
  final bool enableVisualCues;
  final bool enableSubtitles;
  final bool enableSignLanguage;
  final double fontSize;
  final ColorScheme colorScheme;
  final double vibrationIntensity;
  final bool highContrastMode;
  final bool reducedMotion;

  const AccessibilityProfile({
    required this.id,
    required this.name,
    required this.hearingLevel,
    required this.preferredLanguage,
    this.enableHapticFeedback = true,
    this.enableVisualCues = true,
    this.enableSubtitles = true,
    this.enableSignLanguage = true,
    this.fontSize = 16.0,
    this.colorScheme = const ColorScheme.light(),
    this.vibrationIntensity = 0.5,
    this.highContrastMode = false,
    this.reducedMotion = false,
  });

  AccessibilityProfile copyWith({
    String? id,
    String? name,
    HearingLevel? hearingLevel,
    PreferredLanguage? preferredLanguage,
    bool? enableHapticFeedback,
    bool? enableVisualCues,
    bool? enableSubtitles,
    bool? enableSignLanguage,
    double? fontSize,
    ColorScheme? colorScheme,
    double? vibrationIntensity,
    bool? highContrastMode,
    bool? reducedMotion,
  }) {
    return AccessibilityProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      hearingLevel: hearingLevel ?? this.hearingLevel,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
      enableVisualCues: enableVisualCues ?? this.enableVisualCues,
      enableSubtitles: enableSubtitles ?? this.enableSubtitles,
      enableSignLanguage: enableSignLanguage ?? this.enableSignLanguage,
      fontSize: fontSize ?? this.fontSize,
      colorScheme: colorScheme ?? this.colorScheme,
      vibrationIntensity: vibrationIntensity ?? this.vibrationIntensity,
      highContrastMode: highContrastMode ?? this.highContrastMode,
      reducedMotion: reducedMotion ?? this.reducedMotion,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'hearingLevel': hearingLevel.name,
      'preferredLanguage': preferredLanguage.name,
      'enableHapticFeedback': enableHapticFeedback,
      'enableVisualCues': enableVisualCues,
      'enableSubtitles': enableSubtitles,
      'enableSignLanguage': enableSignLanguage,
      'fontSize': fontSize,
      'colorScheme': colorScheme.toString(),
      'vibrationIntensity': vibrationIntensity,
      'highContrastMode': highContrastMode,
      'reducedMotion': reducedMotion,
    };
  }

  factory AccessibilityProfile.fromJson(Map<String, dynamic> json) {
    return AccessibilityProfile(
      id: json['id'],
      name: json['name'],
      hearingLevel: HearingLevel.values.firstWhere(
        (e) => e.name == json['hearingLevel'],
        orElse: () => HearingLevel.moderate,
      ),
      preferredLanguage: PreferredLanguage.values.firstWhere(
        (e) => e.name == json['preferredLanguage'],
        orElse: () => PreferredLanguage.english,
      ),
      enableHapticFeedback: json['enableHapticFeedback'] ?? true,
      enableVisualCues: json['enableVisualCues'] ?? true,
      enableSubtitles: json['enableSubtitles'] ?? true,
      enableSignLanguage: json['enableSignLanguage'] ?? true,
      fontSize: json['fontSize']?.toDouble() ?? 16.0,
      vibrationIntensity: json['vibrationIntensity']?.toDouble() ?? 0.5,
      highContrastMode: json['highContrastMode'] ?? false,
      reducedMotion: json['reducedMotion'] ?? false,
    );
  }

  ThemeMode get themeMode {
    if (highContrastMode) {
      return ThemeMode.light; // High contrast theme
    }
    return ThemeMode.system;
  }
}
