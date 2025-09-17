import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
// import 'package:tflite_flutter/tflite_flutter.dart'; // Commented out for web compatibility
import '../models/gesture_data.dart';

class GestureRecognitionService {
  static final GestureRecognitionService _instance = GestureRecognitionService._internal();
  factory GestureRecognitionService() => _instance;
  GestureRecognitionService._internal();

  // Interpreter? _interpreter; // Commented out for web compatibility
  List<CameraDescription>? _cameras;
  CameraController? _cameraController;
  bool _isInitialized = false;
  StreamController<GestureRecognitionResult>? _gestureStreamController;

  Stream<GestureRecognitionResult> get gestureStream {
    _gestureStreamController ??= StreamController<GestureRecognitionResult>.broadcast();
    return _gestureStreamController!.stream;
  }

  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Initialize camera
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        throw Exception('No cameras available');
      }

      // Initialize TensorFlow Lite model (commented out for web compatibility)
      // _interpreter = await Interpreter.fromAsset('assets/models/gesture_model.tflite');
      
      _isInitialized = true;
      return true;
    } catch (e) {
      debugPrint('Error initializing gesture recognition: $e');
      return false;
    }
  }

  Future<void> startCamera() async {
    if (!_isInitialized || _cameras == null) {
      throw Exception('Gesture recognition not initialized');
    }

    _cameraController = CameraController(
      _cameras![0],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    await _cameraController!.startImageStream(_processCameraImage);
  }

  Future<void> stopCamera() async {
    await _cameraController?.stopImageStream();
    await _cameraController?.dispose();
    _cameraController = null;
  }

  void _processCameraImage(CameraImage image) {
    // Simplified gesture recognition for web compatibility
    try {
      // Simulate gesture detection for web demo
      final gestures = _simulateGestureDetection();
      
      // Emit result
      _gestureStreamController?.add(GestureRecognitionResult(
        gestures: gestures,
        overallConfidence: 0.8,
        isRecognized: gestures.isNotEmpty,
      ));
    } catch (e) {
      debugPrint('Error processing camera image: $e');
      _gestureStreamController?.add(GestureRecognitionResult(
        gestures: [],
        overallConfidence: 0.0,
        isRecognized: false,
        errorMessage: e.toString(),
      ));
    }
  }

  List<GestureData> _simulateGestureDetection() {
    // Simulate some gestures for web demo
    final gestures = <GestureData>[];
    
    // Add a simulated tap gesture
    gestures.add(GestureData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: GestureType.tap,
      position: const Offset(100, 100),
      confidence: 0.8,
      timestamp: DateTime.now(),
    ));
    
    return gestures;
  }

  List<List<double>> _preprocessImage(CameraImage image) {
    // Convert YUV420 to RGB and resize to model input size
    // This is a simplified implementation
    final input = List.generate(1, (i) => List.generate(224 * 224 * 3, (j) => 0.0));
    
    // In a real implementation, you would:
    // 1. Convert YUV420 to RGB
    // 2. Resize to 224x224
    // 3. Normalize pixel values
    
    return input;
  }

  List<GestureData> _processModelOutput(List<List<double>> output) {
    final gestures = <GestureData>[];
    final confidenceThreshold = 0.5;
    
    for (int i = 0; i < output[0].length; i++) {
      final confidence = output[0][i];
      if (confidence > confidenceThreshold) {
        final gestureType = _getGestureTypeFromIndex(i);
        final gesture = GestureData(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: gestureType,
          position: const Offset(0, 0), // Would be calculated from hand detection
          confidence: confidence,
          timestamp: DateTime.now(),
        );
        gestures.add(gesture);
      }
    }
    
    return gestures;
  }

  GestureType _getGestureTypeFromIndex(int index) {
    // Map model output indices to gesture types
    const gestureTypes = [
      GestureType.tap,
      GestureType.doubleTap,
      GestureType.longPress,
      GestureType.swipe,
      GestureType.pinch,
      GestureType.rotate,
      GestureType.handSign,
      GestureType.custom,
    ];
    
    return gestureTypes[index % gestureTypes.length];
  }

  GestureRecognitionResult get gestureRecognitionResult {
    return GestureRecognitionResult(
      gestures: [],
      overallConfidence: 0.0,
      isRecognized: false,
    );
  }

  Future<void> dispose() async {
    await stopCamera();
    // _interpreter?.close(); // Commented out for web compatibility
    // _interpreter = null;
    _gestureStreamController?.close();
    _gestureStreamController = null;
    _isInitialized = false;
  }
}
