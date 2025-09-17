import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/providers/accessibility_provider.dart';
import '../core/models/user_profile.dart';

class AccessibilityScreen extends ConsumerWidget {
  const AccessibilityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilitySettings = ref.watch(accessibilityProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessibility Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Overview
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Profile',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: accessibilitySettings.fontSize + 2,
                      ),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    Row(
                      children: [
                        Icon(Icons.person, size: 48.w),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                accessibilitySettings.name,
                                style: TextStyle(
                                  fontSize: accessibilitySettings.fontSize + 2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Hearing Level: ${_getHearingLevelName(accessibilitySettings.hearingLevel)}',
                                style: TextStyle(fontSize: accessibilitySettings.fontSize),
                              ),
                              Text(
                                'Language: ${_getLanguageName(accessibilitySettings.preferredLanguage)}',
                                style: TextStyle(fontSize: accessibilitySettings.fontSize),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Quick Settings
            Text(
              'Quick Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: accessibilitySettings.fontSize + 2,
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Toggle Settings
            _buildToggleCard(
              context,
              'Visual Cues',
              'Enable visual indicators and animations',
              accessibilitySettings.enableVisualCues,
              (value) => ref.read(accessibilityProvider.notifier).toggleVisualCues(),
              Icons.visibility,
              accessibilitySettings.fontSize,
            ),
            
            _buildToggleCard(
              context,
              'Haptic Feedback',
              'Enable vibration feedback for interactions',
              accessibilitySettings.enableHapticFeedback,
              (value) => ref.read(accessibilityProvider.notifier).toggleHapticFeedback(),
              Icons.vibration,
              accessibilitySettings.fontSize,
            ),
            
            _buildToggleCard(
              context,
              'Subtitles',
              'Display text captions for audio content',
              accessibilitySettings.enableSubtitles,
              (value) => ref.read(accessibilityProvider.notifier).toggleSubtitles(),
              Icons.subtitles,
              accessibilitySettings.fontSize,
            ),
            
            _buildToggleCard(
              context,
              'Sign Language',
              'Include sign language videos and instructions',
              accessibilitySettings.enableSignLanguage,
              (value) => ref.read(accessibilityProvider.notifier).toggleSignLanguage(),
              Icons.gesture,
              accessibilitySettings.fontSize,
            ),
            
            _buildToggleCard(
              context,
              'High Contrast Mode',
              'Use high contrast colors for better visibility',
              accessibilitySettings.highContrastMode,
              (value) => ref.read(accessibilityProvider.notifier).toggleHighContrastMode(),
              Icons.contrast,
              accessibilitySettings.fontSize,
            ),
            
            _buildToggleCard(
              context,
              'Reduced Motion',
              'Minimize animations and transitions',
              accessibilitySettings.reducedMotion,
              (value) => ref.read(accessibilityProvider.notifier).toggleReducedMotion(),
              Icons.motion_photos_pause,
              accessibilitySettings.fontSize,
            ),
            
            SizedBox(height: 24.h),
            
            // Adjustable Settings
            Text(
              'Adjustable Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: accessibilitySettings.fontSize + 2,
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Font Size
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.text_fields),
                        SizedBox(width: 16.w),
                        Text(
                          'Font Size',
                          style: TextStyle(fontSize: accessibilitySettings.fontSize + 2),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    Slider(
                      value: accessibilitySettings.fontSize,
                      min: 12.0,
                      max: 24.0,
                      divisions: 12,
                      onChanged: (value) {
                        ref.read(accessibilityProvider.notifier).updateFontSize(value);
                      },
                    ),
                    
                    Text(
                      'Current size: ${accessibilitySettings.fontSize.toStringAsFixed(1)}',
                      style: TextStyle(fontSize: accessibilitySettings.fontSize - 2),
                    ),
                  ],
                ),
              ),
            ),
            
            // Vibration Intensity
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.vibration),
                        SizedBox(width: 16.w),
                        Text(
                          'Vibration Intensity',
                          style: TextStyle(fontSize: accessibilitySettings.fontSize + 2),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    Slider(
                      value: accessibilitySettings.vibrationIntensity,
                      min: 0.0,
                      max: 1.0,
                      divisions: 10,
                      onChanged: (value) {
                        ref.read(accessibilityProvider.notifier).updateVibrationIntensity(value);
                      },
                    ),
                    
                    Text(
                      'Current intensity: ${(accessibilitySettings.vibrationIntensity * 100).toStringAsFixed(0)}%',
                      style: TextStyle(fontSize: accessibilitySettings.fontSize - 2),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Preset Profiles
            Text(
              'Preset Profiles',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: accessibilitySettings.fontSize + 2,
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Profile Cards
            _buildProfileCard(
              context,
              'Beginner',
              'Mild hearing loss, basic features',
              HearingLevel.mild,
              () => _applyPresetProfile(ref, HearingLevel.mild),
              accessibilitySettings.fontSize,
            ),
            
            _buildProfileCard(
              context,
              'Intermediate',
              'Moderate hearing loss, enhanced features',
              HearingLevel.moderate,
              () => _applyPresetProfile(ref, HearingLevel.moderate),
              accessibilitySettings.fontSize,
            ),
            
            _buildProfileCard(
              context,
              'Advanced',
              'Severe hearing loss, full accessibility',
              HearingLevel.severe,
              () => _applyPresetProfile(ref, HearingLevel.severe),
              accessibilitySettings.fontSize,
            ),
            
            _buildProfileCard(
              context,
              'Expert',
              'Profound hearing loss, maximum accessibility',
              HearingLevel.profound,
              () => _applyPresetProfile(ref, HearingLevel.profound),
              accessibilitySettings.fontSize,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleCard(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    IconData icon,
    double fontSize,
  ) {
    return Card(
      child: SwitchListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: fontSize),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: fontSize - 2),
        ),
        value: value,
        onChanged: onChanged,
        secondary: Icon(icon),
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    String title,
    String subtitle,
    HearingLevel level,
    VoidCallback onTap,
    double fontSize,
  ) {
    return Card(
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: fontSize),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: fontSize - 2),
        ),
        onTap: onTap,
        leading: Icon(_getHearingLevelIcon(level)),
        trailing: const Icon(Icons.arrow_forward),
      ),
    );
  }

  IconData _getHearingLevelIcon(HearingLevel level) {
    switch (level) {
      case HearingLevel.mild:
        return Icons.hearing;
      case HearingLevel.moderate:
        return Icons.hearing;
      case HearingLevel.severe:
        return Icons.hearing_disabled;
      case HearingLevel.profound:
        return Icons.hearing_disabled;
    }
  }

  String _getHearingLevelName(HearingLevel level) {
    switch (level) {
      case HearingLevel.mild:
        return 'Mild';
      case HearingLevel.moderate:
        return 'Moderate';
      case HearingLevel.severe:
        return 'Severe';
      case HearingLevel.profound:
        return 'Profound';
    }
  }

  String _getLanguageName(PreferredLanguage language) {
    switch (language) {
      case PreferredLanguage.english:
        return 'English';
      case PreferredLanguage.spanish:
        return 'Spanish';
      case PreferredLanguage.french:
        return 'French';
      case PreferredLanguage.asl:
        return 'American Sign Language';
    }
  }

  void _applyPresetProfile(WidgetRef ref, HearingLevel level) {
    final profile = _getPresetProfile(level);
    ref.read(accessibilityProvider.notifier).updateProfile(profile);
    
    ScaffoldMessenger.of(ref.context).showSnackBar(
      SnackBar(
        content: Text('Applied ${_getHearingLevelName(level)} profile'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  AccessibilityProfile _getPresetProfile(HearingLevel level) {
    switch (level) {
      case HearingLevel.mild:
        return const AccessibilityProfile(
          id: 'mild',
          name: 'Beginner Profile',
          hearingLevel: HearingLevel.mild,
          preferredLanguage: PreferredLanguage.english,
          enableHapticFeedback: true,
          enableVisualCues: true,
          enableSubtitles: true,
          enableSignLanguage: false,
          fontSize: 16.0,
          vibrationIntensity: 0.3,
          highContrastMode: false,
          reducedMotion: false,
        );
      case HearingLevel.moderate:
        return const AccessibilityProfile(
          id: 'moderate',
          name: 'Intermediate Profile',
          hearingLevel: HearingLevel.moderate,
          preferredLanguage: PreferredLanguage.english,
          enableHapticFeedback: true,
          enableVisualCues: true,
          enableSubtitles: true,
          enableSignLanguage: true,
          fontSize: 18.0,
          vibrationIntensity: 0.5,
          highContrastMode: false,
          reducedMotion: false,
        );
      case HearingLevel.severe:
        return const AccessibilityProfile(
          id: 'severe',
          name: 'Advanced Profile',
          hearingLevel: HearingLevel.severe,
          preferredLanguage: PreferredLanguage.english,
          enableHapticFeedback: true,
          enableVisualCues: true,
          enableSubtitles: true,
          enableSignLanguage: true,
          fontSize: 20.0,
          vibrationIntensity: 0.7,
          highContrastMode: true,
          reducedMotion: false,
        );
      case HearingLevel.profound:
        return const AccessibilityProfile(
          id: 'profound',
          name: 'Expert Profile',
          hearingLevel: HearingLevel.profound,
          preferredLanguage: PreferredLanguage.asl,
          enableHapticFeedback: true,
          enableVisualCues: true,
          enableSubtitles: true,
          enableSignLanguage: true,
          fontSize: 22.0,
          vibrationIntensity: 1.0,
          highContrastMode: true,
          reducedMotion: true,
        );
    }
  }
}
