import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/models/game_content.dart';

class StoryElementWidget extends StatelessWidget {
  final StoryElement element;
  final double fontSize;
  final bool enableSignLanguage;
  final bool enableSubtitles;
  final Function(String)? onChoiceSelected;
  
  const StoryElementWidget({
    super.key,
    required this.element,
    required this.fontSize,
    this.enableSignLanguage = true,
    this.enableSubtitles = true,
    this.onChoiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text content
        if (element.text.isNotEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              element.text,
              style: TextStyle(
                fontSize: fontSize + 2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        
        SizedBox(height: 16.h),
        
        // Image content
        if (element.imagePath != null)
          Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.asset(
                element.imagePath!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.image,
                      size: 48.w,
                      color: Colors.grey[600],
                    ),
                  );
                },
              ),
            ),
          ),
        
        // Video content
        if (element.videoPath != null) ...[
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.black,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Stack(
                children: [
                  // Placeholder for video player
                  Container(
                    color: Colors.grey[800],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_circle_outline,
                            size: 48.w,
                            color: Colors.white,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Video Content',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Sign language overlay
                  if (enableSignLanguage && element.signLanguageVideo != null)
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Text(
                          'ASL',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSize - 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
        
        // Choices
        if (element.choices != null && element.choices!.isNotEmpty) ...[
          SizedBox(height: 24.h),
          Text(
            'Choose your response:',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          ...element.choices!.map((choice) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => onChoiceSelected?.call(choice),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  choice,
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ),
          )),
        ],
        
        // Subtitles
        if (enableSubtitles && element.text.isNotEmpty) ...[
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              element.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }
}
