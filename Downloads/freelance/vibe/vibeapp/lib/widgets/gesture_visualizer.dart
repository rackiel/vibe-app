import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

import '../core/models/gesture_data.dart';

class GestureVisualizer extends StatefulWidget {
  final List<GestureData> gestures;
  final bool isActive;
  
  const GestureVisualizer({
    super.key,
    required this.gestures,
    this.isActive = false,
  });

  @override
  State<GestureVisualizer> createState() => _GestureVisualizerState();
}

class _GestureVisualizerState extends State<GestureVisualizer>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
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
  void didUpdateWidget(GestureVisualizer oldWidget) {
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
              'Gesture Recognition',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            
            SizedBox(height: 16.h),
            
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(200.w, 100.h),
                      painter: GesturePainter(
                        gestures: widget.gestures,
                        animationValue: _animation.value,
                        isActive: widget.isActive,
                      ),
                    );
                  },
                ),
              ),
            ),
            
            if (widget.gestures.isNotEmpty) ...[
              SizedBox(height: 16.h),
              Text(
                'Recent Gestures: ${widget.gestures.length}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class GesturePainter extends CustomPainter {
  final List<GestureData> gestures;
  final double animationValue;
  final bool isActive;

  GesturePainter({
    required this.gestures,
    required this.animationValue,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    if (isActive) {
      // Draw active state with pulsing circle
      final paint = Paint()
        ..color = Colors.blue.withOpacity(0.3)
        ..style = PaintingStyle.fill;
      
      final radius = 20 + (animationValue * 10);
      canvas.drawCircle(center, radius, paint);
      
      // Draw inner circle
      final innerPaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(center, 15, innerPaint);
    } else {
      // Draw inactive state
      final paint = Paint()
        ..color = Colors.grey.withOpacity(0.3)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(center, 20, paint);
    }
    
    // Draw gesture indicators
    for (int i = 0; i < gestures.length && i < 5; i++) {
      final gesture = gestures[i];
      final angle = (i * 2 * math.pi) / 5;
      final gestureCenter = Offset(
        center.dx + math.cos(angle) * 60,
        center.dy + math.sin(angle) * 60,
      );
      
      final gesturePaint = Paint()
        ..color = _getGestureColor(gesture.type)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(gestureCenter, 8, gesturePaint);
    }
  }

  Color _getGestureColor(GestureType type) {
    switch (type) {
      case GestureType.tap:
        return Colors.green;
      case GestureType.doubleTap:
        return Colors.blue;
      case GestureType.longPress:
        return Colors.orange;
      case GestureType.swipe:
        return Colors.purple;
      case GestureType.pinch:
        return Colors.red;
      case GestureType.rotate:
        return Colors.teal;
      case GestureType.handSign:
        return Colors.pink;
      case GestureType.custom:
        return Colors.brown;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is GesturePainter &&
        (oldDelegate.gestures != gestures ||
            oldDelegate.animationValue != animationValue ||
            oldDelegate.isActive != isActive);
  }
}
