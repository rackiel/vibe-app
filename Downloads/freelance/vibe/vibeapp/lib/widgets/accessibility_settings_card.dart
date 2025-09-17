import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/models/user_profile.dart';

class AccessibilitySettingsCard extends StatelessWidget {
  final AccessibilityProfile profile;
  
  const AccessibilitySettingsCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Settings',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: profile.fontSize + 2,
              ),
            ),
            
            SizedBox(height: 16.h),
            
            _buildSettingRow(
              context,
              'Haptic Feedback',
              profile.enableHapticFeedback,
              Icons.vibration,
              profile.fontSize,
            ),
            
            _buildSettingRow(
              context,
              'Visual Cues',
              profile.enableVisualCues,
              Icons.visibility,
              profile.fontSize,
            ),
            
            _buildSettingRow(
              context,
              'Subtitles',
              profile.enableSubtitles,
              Icons.subtitles,
              profile.fontSize,
            ),
            
            _buildSettingRow(
              context,
              'Sign Language',
              profile.enableSignLanguage,
              Icons.gesture,
              profile.fontSize,
            ),
            
            _buildSettingRow(
              context,
              'High Contrast',
              profile.highContrastMode,
              Icons.contrast,
              profile.fontSize,
            ),
            
            _buildSettingRow(
              context,
              'Reduced Motion',
              profile.reducedMotion,
              Icons.motion_photos_pause,
              profile.fontSize,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow(
    BuildContext context,
    String title,
    bool isEnabled,
    IconData icon,
    double fontSize,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20.w,
            color: isEnabled ? Colors.green : Colors.grey,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: fontSize),
            ),
          ),
          Icon(
            isEnabled ? Icons.check_circle : Icons.cancel,
            color: isEnabled ? Colors.green : Colors.grey,
            size: 20.w,
          ),
        ],
      ),
    );
  }
}
