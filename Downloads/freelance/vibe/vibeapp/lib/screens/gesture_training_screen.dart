import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/providers/gesture_provider.dart';
import '../core/providers/accessibility_provider.dart';
import '../core/services/gesture_recognition_service.dart';
import '../widgets/gesture_visualizer.dart';
import '../widgets/gesture_training_card.dart';

class GestureTrainingScreen extends ConsumerStatefulWidget {
  const GestureTrainingScreen({super.key});

  @override
  ConsumerState<GestureTrainingScreen> createState() => _GestureTrainingScreenState();
}

class _GestureTrainingScreenState extends ConsumerState<GestureTrainingScreen> {
  final GestureRecognitionService _gestureService = GestureRecognitionService();
  bool _isTraining = false;
  String _currentGesture = '';

  @override
  void initState() {
    super.initState();
    _initializeGestureService();
  }

  Future<void> _initializeGestureService() async {
    await _gestureService.initialize();
  }

  @override
  void dispose() {
    _gestureService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accessibilitySettings = ref.watch(accessibilityProvider);
    final gestureResult = ref.watch(gestureProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gesture Training'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isTraining ? Icons.stop : Icons.play_arrow),
            onPressed: _toggleTraining,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Training Status
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isTraining ? Icons.record_voice_over : Icons.mic_off,
                          color: _isTraining ? Colors.red : Colors.grey,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          _isTraining ? 'Training Active' : 'Training Inactive',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: accessibilitySettings.fontSize + 2,
                          ),
                        ),
                      ],
                    ),
                    if (_isTraining) ...[
                      SizedBox(height: 16.h),
                      LinearProgressIndicator(
                        value: gestureResult.overallConfidence,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          gestureResult.overallConfidence > 0.7 ? Colors.green : Colors.orange,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Confidence: ${(gestureResult.overallConfidence * 100).toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: accessibilitySettings.fontSize,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Gesture Visualizer
            if (accessibilitySettings.enableVisualCues)
              GestureVisualizer(
                gestures: gestureResult.gestures,
                isActive: _isTraining,
              ),
            
            SizedBox(height: 24.h),
            
            // Training Exercises
            Text(
              'Training Exercises',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: accessibilitySettings.fontSize + 2,
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Gesture Training Cards
            ..._getTrainingGestures().map((gesture) => Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: GestureTrainingCard(
                gestureName: gesture['name']!,
                description: gesture['description']!,
                icon: gesture['icon']!,
                isCompleted: gesture['completed']!,
                onTap: () => _startGestureTraining(gesture['name']!),
                fontSize: accessibilitySettings.fontSize,
              ),
            )),
            
            SizedBox(height: 24.h),
            
            // Recent Gestures
            if (gestureResult.gestures.isNotEmpty) ...[
              Text(
                'Recent Gestures',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: accessibilitySettings.fontSize + 2,
                ),
              ),
              
              SizedBox(height: 16.h),
              
              ...gestureResult.gestures.take(5).map((gesture) => Card(
                child: ListTile(
                  leading: Icon(_getGestureIcon(gesture.type)),
                  title: Text(
                    gesture.type.name.toUpperCase(),
                    style: TextStyle(fontSize: accessibilitySettings.fontSize),
                  ),
                  subtitle: Text(
                    'Confidence: ${(gesture.confidence * 100).toStringAsFixed(1)}%',
                    style: TextStyle(fontSize: accessibilitySettings.fontSize - 2),
                  ),
                  trailing: Text(
                    _formatTime(gesture.timestamp),
                    style: TextStyle(fontSize: accessibilitySettings.fontSize - 2),
                  ),
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getTrainingGestures() {
    return [
      {
        'name': 'Hello',
        'description': 'Wave your hand to say hello',
        'icon': Icons.waving_hand,
        'completed': false,
      },
      {
        'name': 'Yes',
        'description': 'Nod your head or thumbs up',
        'icon': Icons.thumb_up,
        'completed': false,
      },
      {
        'name': 'No',
        'description': 'Shake your head or thumbs down',
        'icon': Icons.thumb_down,
        'completed': false,
      },
      {
        'name': 'Thank You',
        'description': 'Place hand on chest and move forward',
        'icon': Icons.favorite,
        'completed': false,
      },
      {
        'name': 'Help',
        'description': 'Raise both hands above head',
        'icon': Icons.help,
        'completed': false,
      },
    ];
  }

  IconData _getGestureIcon(gestureType) {
    switch (gestureType.toString()) {
      case 'GestureType.tap':
        return Icons.touch_app;
      case 'GestureType.doubleTap':
        return Icons.touch_app;
      case 'GestureType.longPress':
        return Icons.touch_app;
      case 'GestureType.swipe':
        return Icons.swipe;
      case 'GestureType.pinch':
        return Icons.zoom_in;
      case 'GestureType.rotate':
        return Icons.rotate_right;
      case 'GestureType.handSign':
        return Icons.gesture;
      default:
        return Icons.gesture;
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else {
      return '${difference.inHours}h ago';
    }
  }

  void _toggleTraining() async {
    if (_isTraining) {
      await _gestureService.stopCamera();
      setState(() {
        _isTraining = false;
        _currentGesture = '';
      });
    } else {
      await _gestureService.startCamera();
      setState(() {
        _isTraining = true;
      });
    }
  }

  void _startGestureTraining(String gestureName) {
    setState(() {
      _currentGesture = gestureName;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Training: $gestureName'),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
