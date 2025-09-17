import 'package:flutter/material.dart';

enum GestureType {
  tap,
  doubleTap,
  longPress,
  swipe,
  pinch,
  rotate,
  handSign,
  custom,
}

enum HandSignType {
  hello,
  yes,
  no,
  thankYou,
  please,
  sorry,
  help,
  stop,
  go,
  custom,
}

class GestureData {
  final String id;
  final GestureType type;
  final HandSignType? handSignType;
  final Offset position;
  final double confidence;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  const GestureData({
    required this.id,
    required this.type,
    this.handSignType,
    required this.position,
    required this.confidence,
    required this.timestamp,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'handSignType': handSignType?.name,
      'position': {'x': position.dx, 'y': position.dy},
      'confidence': confidence,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'metadata': metadata,
    };
  }

  factory GestureData.fromJson(Map<String, dynamic> json) {
    return GestureData(
      id: json['id'],
      type: GestureType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => GestureType.tap,
      ),
      handSignType: json['handSignType'] != null
          ? HandSignType.values.firstWhere(
              (e) => e.name == json['handSignType'],
              orElse: () => HandSignType.custom,
            )
          : null,
      position: Offset(
        json['position']['x'].toDouble(),
        json['position']['y'].toDouble(),
      ),
      confidence: json['confidence'].toDouble(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      metadata: json['metadata'],
    );
  }
}

class GestureRecognitionResult {
  final List<GestureData> gestures;
  final double overallConfidence;
  final bool isRecognized;
  final String? errorMessage;

  const GestureRecognitionResult({
    required this.gestures,
    required this.overallConfidence,
    required this.isRecognized,
    this.errorMessage,
  });

  bool get hasError => errorMessage != null;
  bool get isEmpty => gestures.isEmpty;
}
