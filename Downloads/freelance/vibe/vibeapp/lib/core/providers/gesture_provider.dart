import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/gesture_data.dart';

class GestureNotifier extends StateNotifier<GestureRecognitionResult> {
  GestureNotifier() : super(const GestureRecognitionResult(
    gestures: [],
    overallConfidence: 0.0,
    isRecognized: false,
  ));

  void updateGestureResult(GestureRecognitionResult result) {
    state = result;
  }

  void addGesture(GestureData gesture) {
    final updatedGestures = [...state.gestures, gesture];
    final overallConfidence = updatedGestures.isNotEmpty
        ? updatedGestures.map((g) => g.confidence).reduce((a, b) => a + b) / updatedGestures.length
        : 0.0;
    
    state = GestureRecognitionResult(
      gestures: updatedGestures,
      overallConfidence: overallConfidence,
      isRecognized: overallConfidence > 0.7,
    );
  }

  void clearGestures() {
    state = const GestureRecognitionResult(
      gestures: [],
      overallConfidence: 0.0,
      isRecognized: false,
    );
  }

  void setError(String errorMessage) {
    state = GestureRecognitionResult(
      gestures: state.gestures,
      overallConfidence: state.overallConfidence,
      isRecognized: false,
      errorMessage: errorMessage,
    );
  }

  List<GestureData> get recentGestures {
    final now = DateTime.now();
    return state.gestures.where((gesture) {
      return now.difference(gesture.timestamp).inSeconds < 5;
    }).toList();
  }

  List<GestureData> get handSignGestures {
    return state.gestures.where((gesture) => gesture.type == GestureType.handSign).toList();
  }
}

final gestureProvider = StateNotifierProvider<GestureNotifier, GestureRecognitionResult>(
  (ref) => GestureNotifier(),
);
