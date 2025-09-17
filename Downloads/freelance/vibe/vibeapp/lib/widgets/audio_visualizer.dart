import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

import '../core/models/audio_visual_data.dart';

class AudioVisualizer extends StatefulWidget {
  final List<AudioVisualData> audioVisualData;
  final bool isActive;
  
  const AudioVisualizer({
    super.key,
    required this.audioVisualData,
    this.isActive = false,
  });

  @override
  State<AudioVisualizer> createState() => _AudioVisualizerState();
}

class _AudioVisualizerState extends State<AudioVisualizer>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    if (widget.isActive) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AudioVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _animationController.repeat(reverse: true);
    } else if (!widget.isActive && oldWidget.isActive) {
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 200.h,
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Audio-Visual Representation',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            
            SizedBox(height: 16.h),
            
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(300.w, 120.h),
                      painter: AudioVisualPainter(
                        audioVisualData: widget.audioVisualData,
                        animationValue: _animation.value,
                        isActive: widget.isActive,
                      ),
                    );
                  },
                ),
              ),
            ),
            
            if (widget.audioVisualData.isNotEmpty) ...[
              SizedBox(height: 16.h),
              Text(
                'Active Representations: ${widget.audioVisualData.length}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AudioVisualPainter extends CustomPainter {
  final List<AudioVisualData> audioVisualData;
  final double animationValue;
  final bool isActive;

  AudioVisualPainter({
    required this.audioVisualData,
    required this.animationValue,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (audioVisualData.isEmpty) {
      _drawIdleState(canvas, size);
      return;
    }

    final currentData = audioVisualData.last;
    
    switch (currentData.visualType) {
      case VisualRepresentationType.waveform:
        _drawWaveform(canvas, size, currentData);
        break;
      case VisualRepresentationType.frequencyBars:
        _drawFrequencyBars(canvas, size, currentData);
        break;
      case VisualRepresentationType.colorPattern:
        _drawColorPattern(canvas, size, currentData);
        break;
      case VisualRepresentationType.shapeAnimation:
        _drawShapeAnimation(canvas, size, currentData);
        break;
      case VisualRepresentationType.text:
        _drawTextRepresentation(canvas, size, currentData);
        break;
      case VisualRepresentationType.icon:
        _drawIconRepresentation(canvas, size, currentData);
        break;
    }
  }

  void _drawIdleState(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, 20, paint);
    
    // Draw "No Audio" text
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'No Audio',
        style: TextStyle(color: Colors.grey, fontSize: 14),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy + 30),
    );
  }

  void _drawWaveform(Canvas canvas, Size size, AudioVisualData data) {
    final paint = Paint()
      ..color = data.primaryColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    final centerY = size.height / 2;
    final amplitude = data.intensity * 30;
    
    for (double x = 0; x < size.width; x += 2) {
      final y = centerY + math.sin((x / size.width) * 4 * math.pi + animationValue * 2 * math.pi) * amplitude;
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    canvas.drawPath(path, paint);
  }

  void _drawFrequencyBars(Canvas canvas, Size size, AudioVisualData data) {
    final barWidth = size.width / 20;
    final maxHeight = size.height * 0.8;
    
    for (int i = 0; i < 20; i++) {
      final barHeight = (data.intensity * maxHeight * (0.5 + 0.5 * math.sin(animationValue * 2 * math.pi + i * 0.3)));
      final x = i * barWidth;
      final y = size.height - barHeight;
      
      final paint = Paint()
        ..color = Color.lerp(data.primaryColor, data.secondaryColor, i / 20)!
        ..style = PaintingStyle.fill;
      
      canvas.drawRect(
        Rect.fromLTWH(x, y, barWidth - 2, barHeight),
        paint,
      );
    }
  }

  void _drawColorPattern(Canvas canvas, Size size, AudioVisualData data) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = 40 + (animationValue * 20);
    
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [data.primaryColor, data.secondaryColor],
        stops: [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius, paint);
  }

  void _drawShapeAnimation(Canvas canvas, Size size, AudioVisualData data) {
    final center = Offset(size.width / 2, size.height / 2);
    final rotation = animationValue * 2 * math.pi;
    
    final paint = Paint()
      ..color = data.primaryColor
      ..style = PaintingStyle.fill;
    
    // Draw rotating triangle
    final path = Path();
    for (int i = 0; i < 3; i++) {
      final angle = (i * 2 * math.pi / 3) + rotation;
      final x = center.dx + math.cos(angle) * 30;
      final y = center.dy + math.sin(angle) * 30;
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    
    canvas.drawPath(path, paint);
  }

  void _drawTextRepresentation(Canvas canvas, Size size, AudioVisualData data) {
    if (data.subtitle == null) return;
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: data.subtitle!,
        style: TextStyle(
          color: data.primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    
    final x = (size.width - textPainter.width) / 2;
    final y = (size.height - textPainter.height) / 2;
    
    textPainter.paint(canvas, Offset(x, y));
  }

  void _drawIconRepresentation(Canvas canvas, Size size, AudioVisualData data) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = data.primaryColor
      ..style = PaintingStyle.fill;
    
    // Draw a simple icon representation
    canvas.drawCircle(center, 20 + (animationValue * 10), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is AudioVisualPainter &&
        (oldDelegate.audioVisualData != audioVisualData ||
            oldDelegate.animationValue != animationValue ||
            oldDelegate.isActive != isActive);
  }
}
