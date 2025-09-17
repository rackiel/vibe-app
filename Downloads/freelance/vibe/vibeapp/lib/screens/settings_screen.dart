import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/providers/accessibility_provider.dart';
import '../core/providers/onboarding_provider.dart';
import '../core/models/user_profile.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilitySettings = ref.watch(accessibilityProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // Accessibility Settings
          _buildSectionHeader(context, 'Accessibility', accessibilitySettings.fontSize),
          
          _buildSwitchTile(
            context,
            'Haptic Feedback',
            'Enable vibration feedback for interactions',
            accessibilitySettings.enableHapticFeedback,
            (value) => ref.read(accessibilityProvider.notifier).toggleHapticFeedback(),
            Icons.vibration,
            accessibilitySettings.fontSize,
          ),
          
          _buildSwitchTile(
            context,
            'Visual Cues',
            'Show visual indicators and animations',
            accessibilitySettings.enableVisualCues,
            (value) => ref.read(accessibilityProvider.notifier).toggleVisualCues(),
            Icons.visibility,
            accessibilitySettings.fontSize,
          ),
          
          _buildSwitchTile(
            context,
            'Subtitles',
            'Display text captions for audio content',
            accessibilitySettings.enableSubtitles,
            (value) => ref.read(accessibilityProvider.notifier).toggleSubtitles(),
            Icons.subtitles,
            accessibilitySettings.fontSize,
          ),
          
          _buildSwitchTile(
            context,
            'Sign Language',
            'Include sign language videos and instructions',
            accessibilitySettings.enableSignLanguage,
            (value) => ref.read(accessibilityProvider.notifier).toggleSignLanguage(),
            Icons.gesture,
            accessibilitySettings.fontSize,
          ),
          
          _buildSwitchTile(
            context,
            'High Contrast Mode',
            'Use high contrast colors for better visibility',
            accessibilitySettings.highContrastMode,
            (value) => ref.read(accessibilityProvider.notifier).toggleHighContrastMode(),
            Icons.contrast,
            accessibilitySettings.fontSize,
          ),
          
          _buildSwitchTile(
            context,
            'Reduced Motion',
            'Minimize animations and transitions',
            accessibilitySettings.reducedMotion,
            (value) => ref.read(accessibilityProvider.notifier).toggleReducedMotion(),
            Icons.motion_photos_pause,
            accessibilitySettings.fontSize,
          ),
          
          SizedBox(height: 24.h),
          
          // Display Settings
          _buildSectionHeader(context, 'Display', accessibilitySettings.fontSize),
          
          _buildSliderTile(
            context,
            'Font Size',
            'Adjust text size for better readability',
            accessibilitySettings.fontSize,
            12.0,
            24.0,
            (value) => ref.read(accessibilityProvider.notifier).updateFontSize(value),
            Icons.text_fields,
            accessibilitySettings.fontSize,
          ),
          
          _buildSliderTile(
            context,
            'Vibration Intensity',
            'Adjust vibration strength for haptic feedback',
            accessibilitySettings.vibrationIntensity,
            0.0,
            1.0,
            (value) => ref.read(accessibilityProvider.notifier).updateVibrationIntensity(value),
            Icons.vibration,
            accessibilitySettings.fontSize,
          ),
          
          SizedBox(height: 24.h),
          
          // Language Settings
          _buildSectionHeader(context, 'Language', accessibilitySettings.fontSize),
          
          _buildListTile(
            context,
            'Preferred Language',
            _getLanguageName(accessibilitySettings.preferredLanguage),
            () => _showLanguageDialog(context, ref, accessibilitySettings),
            Icons.language,
            accessibilitySettings.fontSize,
          ),
          
          _buildListTile(
            context,
            'Hearing Level',
            _getHearingLevelName(accessibilitySettings.hearingLevel),
            () => _showHearingLevelDialog(context, ref, accessibilitySettings),
            Icons.hearing,
            accessibilitySettings.fontSize,
          ),
          
          SizedBox(height: 24.h),
          
          // Advanced Settings
          _buildSectionHeader(context, 'Advanced', accessibilitySettings.fontSize),
          
          _buildListTile(
            context,
            'Accessibility Profile',
            'Customize accessibility settings',
            () => context.go('/accessibility'),
            Icons.accessibility,
            accessibilitySettings.fontSize,
          ),
          
          _buildListTile(
            context,
            'Export Data',
            'Export your profile and progress data',
            () => _exportData(context),
            Icons.download,
            accessibilitySettings.fontSize,
          ),
          
          _buildListTile(
            context,
            'Reset Settings',
            'Reset all settings to default values',
            () => _resetSettings(context, ref),
            Icons.restore,
            accessibilitySettings.fontSize,
          ),
          
          _buildListTile(
            context,
            'Show Onboarding',
            'Show the app introduction again',
            () => _showOnboarding(context, ref),
            Icons.help_outline,
            accessibilitySettings.fontSize,
          ),
          
          SizedBox(height: 24.h),
          
          // About
          _buildSectionHeader(context, 'About', accessibilitySettings.fontSize),
          
          _buildListTile(
            context,
            'Version',
            '1.0.0',
            null,
            Icons.info,
            accessibilitySettings.fontSize,
          ),
          
          _buildListTile(
            context,
            'Privacy Policy',
            'View our privacy policy',
            () => _showPrivacyPolicy(context),
            Icons.privacy_tip,
            accessibilitySettings.fontSize,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, double fontSize) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontSize: fontSize + 2,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
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

  Widget _buildSliderTile(
    BuildContext context,
    String title,
    String subtitle,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
    IconData icon,
    double fontSize,
  ) {
    return Card(
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: fontSize),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: TextStyle(fontSize: fontSize - 2),
            ),
            Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
              divisions: ((max - min) * 10).round(),
            ),
            Text(
              '${value.toStringAsFixed(1)}',
              style: TextStyle(fontSize: fontSize - 2),
            ),
          ],
        ),
        leading: Icon(icon),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String title,
    String subtitle,
    VoidCallback? onTap,
    IconData icon,
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
        leading: Icon(icon),
        trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      ),
    );
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

  void _showLanguageDialog(BuildContext context, WidgetRef ref, AccessibilityProfile profile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: PreferredLanguage.values.map((language) => RadioListTile<PreferredLanguage>(
            title: Text(_getLanguageName(language)),
            value: language,
            groupValue: profile.preferredLanguage,
            onChanged: (value) {
              ref.read(accessibilityProvider.notifier).updatePreferredLanguage(value!);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showHearingLevelDialog(BuildContext context, WidgetRef ref, AccessibilityProfile profile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Hearing Level'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: HearingLevel.values.map((level) => RadioListTile<HearingLevel>(
            title: Text(_getHearingLevelName(level)),
            value: level,
            groupValue: profile.hearingLevel,
            onChanged: (value) {
              ref.read(accessibilityProvider.notifier).updateHearingLevel(value!);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _exportData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exporting data...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _resetSettings(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text('Are you sure you want to reset all settings to default values?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Reset to default profile
              ref.read(accessibilityProvider.notifier).updateProfile(
                const AccessibilityProfile(
                  id: 'default',
                  name: 'Default Profile',
                  hearingLevel: HearingLevel.moderate,
                  preferredLanguage: PreferredLanguage.english,
                ),
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings reset to default'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showOnboarding(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Show Onboarding'),
        content: const Text('This will reset the onboarding status and show the app introduction again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(onboardingProvider.notifier).resetOnboarding();
              Navigator.pop(context);
              context.go('/onboarding');
            },
            child: const Text('Show Onboarding'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'VIBE respects your privacy and is committed to protecting your personal information. '
            'We collect only the data necessary to provide you with the best accessibility experience. '
            'Your data is stored locally on your device and is not shared with third parties without your consent.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
