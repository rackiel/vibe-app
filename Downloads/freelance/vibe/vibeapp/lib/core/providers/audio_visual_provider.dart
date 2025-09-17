import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/audio_visual_data.dart';

class AudioVisualNotifier extends StateNotifier<List<AudioVisualData>> {
  AudioVisualNotifier() : super([]);

  void addAudioVisualData(AudioVisualData data) {
    state = [...state, data];
  }

  void removeAudioVisualData(String id) {
    state = state.where((data) => data.id != id).toList();
  }

  void updateAudioVisualData(AudioVisualData data) {
    state = state.map((item) => item.id == data.id ? data : item).toList();
  }

  AudioVisualData? getAudioVisualData(String id) {
    try {
      return state.firstWhere((data) => data.id == id);
    } catch (e) {
      return null;
    }
  }

  List<AudioVisualData> getAudioVisualDataByType(AudioVisualType type) {
    return state.where((data) => data.type == type).toList();
  }

  void clearAll() {
    state = [];
  }
}

class SubtitleNotifier extends StateNotifier<List<SubtitleData>> {
  SubtitleNotifier() : super([]);

  void addSubtitle(SubtitleData subtitle) {
    state = [...state, subtitle];
  }

  void addSubtitles(List<SubtitleData> subtitles) {
    state = [...state, ...subtitles];
  }

  void clearSubtitles() {
    state = [];
  }

  List<SubtitleData> getSubtitlesForTimeRange(Duration start, Duration end) {
    return state.where((subtitle) {
      return subtitle.startTime >= start && subtitle.endTime <= end;
    }).toList();
  }

  SubtitleData? getCurrentSubtitle(Duration currentTime) {
    try {
      return state.firstWhere((subtitle) {
        return currentTime >= subtitle.startTime && currentTime <= subtitle.endTime;
      });
    } catch (e) {
      return null;
    }
  }
}

final audioVisualProvider = StateNotifierProvider<AudioVisualNotifier, List<AudioVisualData>>(
  (ref) => AudioVisualNotifier(),
);

final subtitleProvider = StateNotifierProvider<SubtitleNotifier, List<SubtitleData>>(
  (ref) => SubtitleNotifier(),
);
