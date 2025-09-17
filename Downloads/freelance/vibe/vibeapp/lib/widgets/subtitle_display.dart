import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/models/audio_visual_data.dart';

class SubtitleDisplay extends StatelessWidget {
  final List<SubtitleData> subtitles;
  final double fontSize;
  
  const SubtitleDisplay({
    super.key,
    required this.subtitles,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    if (subtitles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Live Subtitles',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: fontSize + 2,
              ),
            ),
            
            SizedBox(height: 16.h),
            
            Container(
              height: 120.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Text(
                  subtitles.last.text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize + 4,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            
            if (subtitles.length > 1) ...[
              SizedBox(height: 16.h),
              Text(
                'Recent Subtitles',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              ...subtitles.take(3).map((subtitle) => Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Text(
                  subtitle.text,
                  style: TextStyle(
                    fontSize: fontSize - 2,
                    color: Colors.grey[600],
                  ),
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }
}
