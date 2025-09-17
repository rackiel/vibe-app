import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GestureTrainingCard extends StatelessWidget {
  final String gestureName;
  final String description;
  final IconData icon;
  final bool isCompleted;
  final VoidCallback onTap;
  final double fontSize;
  
  const GestureTrainingCard({
    super.key,
    required this.gestureName,
    required this.description,
    required this.icon,
    required this.isCompleted,
    required this.onTap,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isCompleted ? 4 : 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            gradient: isCompleted
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.green.withOpacity(0.1),
                      Colors.green.withOpacity(0.05),
                    ],
                  )
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green : Colors.blue,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24.w,
                ),
              ),
              
              SizedBox(width: 16.w),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gestureName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: fontSize + 2,
                        fontWeight: FontWeight.bold,
                        color: isCompleted ? Colors.green[800] : null,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: fontSize - 2,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              if (isCompleted)
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 24.w,
                )
              else
                Icon(
                  Icons.play_circle_outline,
                  color: Colors.blue,
                  size: 24.w,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
