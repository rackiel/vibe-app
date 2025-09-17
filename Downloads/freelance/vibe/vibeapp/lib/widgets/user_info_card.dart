import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/models/user_profile.dart';

class UserInfoCard extends StatelessWidget {
  final AccessibilityProfile profile;
  
  const UserInfoCard({
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
            Row(
              children: [
                CircleAvatar(
                  radius: 30.w,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(
                    Icons.person,
                    size: 30.w,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: profile.fontSize + 2,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Hearing Level: ${_getHearingLevelName(profile.hearingLevel)}',
                        style: TextStyle(fontSize: profile.fontSize),
                      ),
                      Text(
                        'Language: ${_getLanguageName(profile.preferredLanguage)}',
                        style: TextStyle(fontSize: profile.fontSize),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            // Progress indicators
            _buildProgressIndicator(
              context,
              'Learning Progress',
              0.75,
              Colors.blue,
              profile.fontSize,
            ),
            
            SizedBox(height: 8.h),
            
            _buildProgressIndicator(
              context,
              'Gesture Recognition',
              0.60,
              Colors.green,
              profile.fontSize,
            ),
            
            SizedBox(height: 8.h),
            
            _buildProgressIndicator(
              context,
              'Audio-Visual Training',
              0.45,
              Colors.orange,
              profile.fontSize,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(
    BuildContext context,
    String label,
    double progress,
    Color color,
    double fontSize,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: fontSize),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: fontSize - 2,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
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
}
