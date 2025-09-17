import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/providers/accessibility_provider.dart';
import '../core/models/user_profile.dart';
import '../widgets/accessibility_settings_card.dart';
import '../widgets/user_info_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilitySettings = ref.watch(accessibilityProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit profile screen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Card
            UserInfoCard(profile: accessibilitySettings),
            
            SizedBox(height: 24.h),
            
            // Accessibility Settings
            Text(
              'Accessibility Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: accessibilitySettings.fontSize + 2,
              ),
            ),
            
            SizedBox(height: 16.h),
            
            AccessibilitySettingsCard(profile: accessibilitySettings),
            
            SizedBox(height: 24.h),
            
            // Statistics
            Text(
              'Statistics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: accessibilitySettings.fontSize + 2,
              ),
            ),
            
            SizedBox(height: 16.h),
            
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    _buildStatRow(
                      context,
                      'Games Completed',
                      '12',
                      Icons.games,
                      accessibilitySettings.fontSize,
                    ),
                    SizedBox(height: 16.h),
                    _buildStatRow(
                      context,
                      'Gestures Learned',
                      '8',
                      Icons.gesture,
                      accessibilitySettings.fontSize,
                    ),
                    SizedBox(height: 16.h),
                    _buildStatRow(
                      context,
                      'Time Spent',
                      '2h 30m',
                      Icons.timer,
                      accessibilitySettings.fontSize,
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to accessibility settings
                },
                icon: const Icon(Icons.accessibility),
                label: Text(
                  'Customize Accessibility',
                  style: TextStyle(fontSize: accessibilitySettings.fontSize),
                ),
              ),
            ),
            
            SizedBox(height: 16.h),
            
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Export profile data
                },
                icon: const Icon(Icons.download),
                label: Text(
                  'Export Profile Data',
                  style: TextStyle(fontSize: accessibilitySettings.fontSize),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    double fontSize,
  ) {
    return Row(
      children: [
        Icon(icon, size: 24.w),
        SizedBox(width: 16.w),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: fontSize,
            ),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: fontSize + 2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
