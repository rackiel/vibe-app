import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';

class AccessibilityNotifier extends StateNotifier<AccessibilityProfile> {
  AccessibilityNotifier() : super(_defaultProfile);

  static const _defaultProfile = AccessibilityProfile(
    id: 'default',
    name: 'Default Profile',
    hearingLevel: HearingLevel.moderate,
    preferredLanguage: PreferredLanguage.english,
  );

  void updateProfile(AccessibilityProfile profile) {
    state = profile;
  }

  void updateHearingLevel(HearingLevel level) {
    state = state.copyWith(hearingLevel: level);
  }

  void updatePreferredLanguage(PreferredLanguage language) {
    state = state.copyWith(preferredLanguage: language);
  }

  void toggleHapticFeedback() {
    state = state.copyWith(enableHapticFeedback: !state.enableHapticFeedback);
  }

  void toggleVisualCues() {
    state = state.copyWith(enableVisualCues: !state.enableVisualCues);
  }

  void toggleSubtitles() {
    state = state.copyWith(enableSubtitles: !state.enableSubtitles);
  }

  void toggleSignLanguage() {
    state = state.copyWith(enableSignLanguage: !state.enableSignLanguage);
  }

  void updateFontSize(double fontSize) {
    state = state.copyWith(fontSize: fontSize);
  }

  void updateVibrationIntensity(double intensity) {
    state = state.copyWith(vibrationIntensity: intensity);
  }

  void toggleHighContrastMode() {
    state = state.copyWith(highContrastMode: !state.highContrastMode);
  }

  void toggleReducedMotion() {
    state = state.copyWith(reducedMotion: !state.reducedMotion);
  }

  ThemeMode get themeMode {
    if (state.highContrastMode) {
      return ThemeMode.light; // High contrast theme
    }
    return ThemeMode.system;
  }
}

final accessibilityProvider = StateNotifierProvider<AccessibilityNotifier, AccessibilityProfile>(
  (ref) => AccessibilityNotifier(),
);
