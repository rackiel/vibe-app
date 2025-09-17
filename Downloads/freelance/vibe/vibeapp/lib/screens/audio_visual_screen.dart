import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/providers/audio_visual_provider.dart';
import '../core/providers/accessibility_provider.dart';
import '../core/services/audio_visual_service.dart';
import '../widgets/audio_visualizer.dart';
import '../widgets/subtitle_display.dart';
import '../widgets/audio_controls.dart';

class AudioVisualScreen extends ConsumerStatefulWidget {
  const AudioVisualScreen({super.key});

  @override
  ConsumerState<AudioVisualScreen> createState() => _AudioVisualScreenState();
}

class _AudioVisualScreenState extends ConsumerState<AudioVisualScreen> {
  final AudioVisualService _audioVisualService = AudioVisualService();
  bool _isListening = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeAudioVisualService();
  }

  Future<void> _initializeAudioVisualService() async {
    await _audioVisualService.initialize();
  }

  @override
  void dispose() {
    _audioVisualService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accessibilitySettings = ref.watch(accessibilityProvider);
    final audioVisualData = ref.watch(audioVisualProvider);
    final subtitles = ref.watch(subtitleProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio-Visual Experience'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isListening ? Icons.mic : Icons.mic_off),
            onPressed: _toggleListening,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Audio Controls
            AudioControls(
              isPlaying: _isPlaying,
              isListening: _isListening,
              onPlay: _playSampleAudio,
              onStop: _stopAudio,
              onListen: _toggleListening,
              fontSize: accessibilitySettings.fontSize,
            ),
            
            SizedBox(height: 24.h),
            
            // Audio Visualizer
            if (accessibilitySettings.enableVisualCues)
              AudioVisualizer(
                audioVisualData: audioVisualData,
                isActive: _isListening || _isPlaying,
              ),
            
            SizedBox(height: 24.h),
            
            // Subtitle Display
            if (accessibilitySettings.enableSubtitles && subtitles.isNotEmpty)
              SubtitleDisplay(
                subtitles: subtitles,
                fontSize: accessibilitySettings.fontSize,
              ),
            
            SizedBox(height: 24.h),
            
            // Visual Representations
            Text(
              'Visual Representations',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: accessibilitySettings.fontSize + 2,
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Visual Representation Cards
            ...audioVisualData.take(5).map((data) => Card(
              child: ListTile(
                leading: Icon(_getVisualIcon(data.visualType)),
                title: Text(
                  data.type.name.toUpperCase(),
                  style: TextStyle(fontSize: accessibilitySettings.fontSize),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (data.subtitle != null)
                      Text(
                        data.subtitle!,
                        style: TextStyle(fontSize: accessibilitySettings.fontSize - 2),
                      ),
                    Text(
                      'Intensity: ${(data.intensity * 100).toStringAsFixed(1)}%',
                      style: TextStyle(fontSize: accessibilitySettings.fontSize - 2),
                    ),
                  ],
                ),
                trailing: Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: data.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            )),
            
            SizedBox(height: 24.h),
            
            // Test Audio-Visual Conversion
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Audio-Visual Conversion',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: accessibilitySettings.fontSize + 2,
                      ),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    Text(
                      'Try speaking or playing audio to see visual representations in real-time.',
                      style: TextStyle(fontSize: accessibilitySettings.fontSize),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _testSpeechToVisual,
                            icon: const Icon(Icons.mic),
                            label: Text(
                              'Test Speech',
                              style: TextStyle(fontSize: accessibilitySettings.fontSize),
                            ),
                          ),
                        ),
                        
                        SizedBox(width: 16.w),
                        
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _testAudioToVisual,
                            icon: const Icon(Icons.volume_up),
                            label: Text(
                              'Test Audio',
                              style: TextStyle(fontSize: accessibilitySettings.fontSize),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getVisualIcon(visualType) {
    switch (visualType.toString()) {
      case 'VisualRepresentationType.waveform':
        return Icons.graphic_eq;
      case 'VisualRepresentationType.frequencyBars':
        return Icons.bar_chart;
      case 'VisualRepresentationType.colorPattern':
        return Icons.palette;
      case 'VisualRepresentationType.shapeAnimation':
        return Icons.animation;
      case 'VisualRepresentationType.text':
        return Icons.text_fields;
      case 'VisualRepresentationType.icon':
        return Icons.image;
      default:
        return Icons.visibility;
    }
  }

  void _toggleListening() async {
    if (_isListening) {
      await _audioVisualService.stopListening();
      setState(() {
        _isListening = false;
      });
    } else {
      await _audioVisualService.startListening();
      setState(() {
        _isListening = true;
      });
    }
  }

  void _playSampleAudio() async {
    await _audioVisualService.playAudio('sounds/sample_audio.mp3');
    setState(() {
      _isPlaying = true;
    });
  }

  void _stopAudio() async {
    await _audioVisualService.stopAudio();
    setState(() {
      _isPlaying = false;
    });
  }

  void _testSpeechToVisual() async {
    await _audioVisualService.speak('Hello, this is a test of speech to visual conversion.');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Speaking test phrase...'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _testAudioToVisual() async {
    _playSampleAudio();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Playing sample audio...'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
