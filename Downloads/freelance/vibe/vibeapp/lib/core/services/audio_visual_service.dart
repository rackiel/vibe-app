import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/audio_visual_data.dart';

class AudioVisualService {
  static final AudioVisualService _instance = AudioVisualService._internal();
  factory AudioVisualService() => _instance;
  AudioVisualService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  
  bool _isListening = false;
  bool _isPlaying = false;
  StreamController<SubtitleData>? _subtitleStreamController;
  StreamController<AudioVisualData>? _audioVisualStreamController;

  Stream<SubtitleData> get subtitleStream {
    _subtitleStreamController ??= StreamController<SubtitleData>.broadcast();
    return _subtitleStreamController!.stream;
  }

  Stream<AudioVisualData> get audioVisualStream {
    _audioVisualStreamController ??= StreamController<AudioVisualData>.broadcast();
    return _audioVisualStreamController!.stream;
  }

  Future<bool> initialize() async {
    try {
      // Initialize speech recognition
      await _speechToText.initialize();
      
      // Initialize text-to-speech
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      
      return true;
    } catch (e) {
      debugPrint('Error initializing audio visual service: $e');
      return false;
    }
  }

  Future<void> startListening() async {
    if (_isListening) return;

    try {
      await _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        localeId: "en_US",
        onSoundLevelChange: _onSoundLevelChange,
      );
      _isListening = true;
    } catch (e) {
      debugPrint('Error starting speech recognition: $e');
    }
  }

  Future<void> stopListening() async {
    if (!_isListening) return;

    await _speechToText.stop();
    _isListening = false;
  }

  void _onSpeechResult(result) {
    if (result.finalResult) {
      final subtitle = SubtitleData(
        text: result.recognizedWords,
        startTime: DateTime.now().difference(DateTime.now()).abs(),
        endTime: DateTime.now().difference(DateTime.now()).abs() + const Duration(seconds: 2),
        confidence: result.confidence,
      );
      
      _subtitleStreamController?.add(subtitle);
      
      // Generate visual representation
      _generateVisualRepresentation(result.recognizedWords, result.confidence);
    }
  }

  void _onSoundLevelChange(double level) {
    // Generate visual feedback based on sound level
    final visualData = AudioVisualData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: AudioVisualType.speech,
      visualType: VisualRepresentationType.frequencyBars,
      audioPath: '',
      primaryColor: _getColorFromLevel(level),
      secondaryColor: _getColorFromLevel(level).withOpacity(0.5),
      intensity: level,
      duration: const Duration(milliseconds: 100),
    );
    
    _audioVisualStreamController?.add(visualData);
  }

  Color _getColorFromLevel(double level) {
    if (level < 0.3) return Colors.green;
    if (level < 0.6) return Colors.yellow;
    if (level < 0.8) return Colors.orange;
    return Colors.red;
  }

  void _generateVisualRepresentation(String text, double confidence) {
    final visualData = AudioVisualData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: AudioVisualType.speech,
      visualType: VisualRepresentationType.text,
      audioPath: '',
      subtitle: text,
      primaryColor: _getColorFromConfidence(confidence),
      secondaryColor: _getColorFromConfidence(confidence).withOpacity(0.3),
      intensity: confidence,
      duration: const Duration(seconds: 3),
    );
    
    _audioVisualStreamController?.add(visualData);
  }

  Color _getColorFromConfidence(double confidence) {
    if (confidence < 0.5) return Colors.red;
    if (confidence < 0.7) return Colors.orange;
    if (confidence < 0.9) return Colors.yellow;
    return Colors.green;
  }

  Future<void> playAudio(String audioPath) async {
    if (_isPlaying) {
      await _audioPlayer.stop();
    }

    try {
      await _audioPlayer.play(AssetSource(audioPath));
      _isPlaying = true;
      
      // Generate visual representation for audio
      _generateAudioVisualRepresentation(audioPath);
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  void _generateAudioVisualRepresentation(String audioPath) {
    final visualData = AudioVisualData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: AudioVisualType.music,
      visualType: VisualRepresentationType.waveform,
      audioPath: audioPath,
      primaryColor: Colors.blue,
      secondaryColor: Colors.blue.withOpacity(0.3),
      intensity: 0.8,
      duration: const Duration(seconds: 10),
    );
    
    _audioVisualStreamController?.add(visualData);
  }

  Future<void> speak(String text) async {
    try {
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint('Error speaking text: $e');
    }
  }

  Future<void> stopAudio() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
      _isPlaying = false;
    }
  }

  Future<void> dispose() async {
    await stopListening();
    await stopAudio();
    await _audioPlayer.dispose();
    _subtitleStreamController?.close();
    _audioVisualStreamController?.close();
  }
}
