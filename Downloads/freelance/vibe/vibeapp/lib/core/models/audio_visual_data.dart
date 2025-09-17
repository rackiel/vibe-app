import 'package:flutter/material.dart';

enum AudioVisualType {
  speech,
  music,
  soundEffect,
  ambient,
  notification,
}

enum VisualRepresentationType {
  waveform,
  frequencyBars,
  colorPattern,
  shapeAnimation,
  text,
  icon,
}

class AudioVisualData {
  final String id;
  final AudioVisualType type;
  final VisualRepresentationType visualType;
  final String audioPath;
  final String? subtitle;
  final String? signLanguageVideo;
  final Color primaryColor;
  final Color secondaryColor;
  final double intensity;
  final Duration duration;
  final Map<String, dynamic>? metadata;

  const AudioVisualData({
    required this.id,
    required this.type,
    required this.visualType,
    required this.audioPath,
    this.subtitle,
    this.signLanguageVideo,
    required this.primaryColor,
    required this.secondaryColor,
    required this.intensity,
    required this.duration,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'visualType': visualType.name,
      'audioPath': audioPath,
      'subtitle': subtitle,
      'signLanguageVideo': signLanguageVideo,
      'primaryColor': primaryColor.value,
      'secondaryColor': secondaryColor.value,
      'intensity': intensity,
      'duration': duration.inMilliseconds,
      'metadata': metadata,
    };
  }

  factory AudioVisualData.fromJson(Map<String, dynamic> json) {
    return AudioVisualData(
      id: json['id'],
      type: AudioVisualType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AudioVisualType.speech,
      ),
      visualType: VisualRepresentationType.values.firstWhere(
        (e) => e.name == json['visualType'],
        orElse: () => VisualRepresentationType.waveform,
      ),
      audioPath: json['audioPath'],
      subtitle: json['subtitle'],
      signLanguageVideo: json['signLanguageVideo'],
      primaryColor: Color(json['primaryColor']),
      secondaryColor: Color(json['secondaryColor']),
      intensity: json['intensity'].toDouble(),
      duration: Duration(milliseconds: json['duration']),
      metadata: json['metadata'],
    );
  }
}

class SubtitleData {
  final String text;
  final Duration startTime;
  final Duration endTime;
  final String? speaker;
  final double confidence;
  final bool isSignLanguage;

  const SubtitleData({
    required this.text,
    required this.startTime,
    required this.endTime,
    this.speaker,
    required this.confidence,
    this.isSignLanguage = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'startTime': startTime.inMilliseconds,
      'endTime': endTime.inMilliseconds,
      'speaker': speaker,
      'confidence': confidence,
      'isSignLanguage': isSignLanguage,
    };
  }

  factory SubtitleData.fromJson(Map<String, dynamic> json) {
    return SubtitleData(
      text: json['text'],
      startTime: Duration(milliseconds: json['startTime']),
      endTime: Duration(milliseconds: json['endTime']),
      speaker: json['speaker'],
      confidence: json['confidence'].toDouble(),
      isSignLanguage: json['isSignLanguage'] ?? false,
    );
  }
}
