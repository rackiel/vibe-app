import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AudioControls extends StatelessWidget {
  final bool isPlaying;
  final bool isListening;
  final VoidCallback onPlay;
  final VoidCallback onStop;
  final VoidCallback onListen;
  final double fontSize;
  
  const AudioControls({
    super.key,
    required this.isPlaying,
    required this.isListening,
    required this.onPlay,
    required this.onStop,
    required this.onListen,
    required this.fontSize,
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
              'Audio Controls',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: fontSize + 2,
              ),
            ),
            
            SizedBox(height: 16.h),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildControlButton(
                  context,
                  isListening ? 'Stop Listening' : 'Start Listening',
                  isListening ? Icons.mic : Icons.mic_off,
                  isListening ? Colors.red : Colors.blue,
                  onListen,
                ),
                
                _buildControlButton(
                  context,
                  isPlaying ? 'Stop Audio' : 'Play Audio',
                  isPlaying ? Icons.stop : Icons.play_arrow,
                  isPlaying ? Colors.red : Colors.green,
                  isPlaying ? onStop : onPlay,
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            // Status indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatusIndicator(
                  context,
                  'Listening',
                  isListening,
                  Icons.mic,
                  fontSize,
                ),
                _buildStatusIndicator(
                  context,
                  'Playing',
                  isPlaying,
                  Icons.volume_up,
                  fontSize,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        Container(
          width: 60.w,
          height: 60.h,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: color, width: 2),
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon, color: color, size: 30.w),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize - 2,
            color: color,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStatusIndicator(
    BuildContext context,
    String label,
    bool isActive,
    IconData icon,
    double fontSize,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: isActive ? Colors.green : Colors.grey,
          size: 20.w,
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize - 2,
            color: isActive ? Colors.green : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
