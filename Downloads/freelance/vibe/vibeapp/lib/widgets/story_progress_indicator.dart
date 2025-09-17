import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoryProgressIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalElements;
  final double fontSize;
  
  const StoryProgressIndicator({
    super.key,
    required this.currentIndex,
    required this.totalElements,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalElements > 0 ? (currentIndex + 1) / totalElements : 0.0;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${currentIndex + 1} / $totalElements',
                style: TextStyle(
                  fontSize: fontSize - 2,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 8.h),
          
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
          
          SizedBox(height: 4.h),
          
          Text(
            '${(progress * 100).toInt()}% Complete',
            style: TextStyle(
              fontSize: fontSize - 2,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
