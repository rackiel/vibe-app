import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/providers/accessibility_provider.dart';
import '../core/models/game_content.dart';
import '../widgets/story_element_widget.dart';
import '../widgets/story_progress_indicator.dart';

class StoryScreen extends ConsumerStatefulWidget {
  final String storyId;
  
  const StoryScreen({super.key, required this.storyId});

  @override
  ConsumerState<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends ConsumerState<StoryScreen> {
  int _currentElementIndex = 0;
  bool _isPlaying = false;
  List<StoryElement> _storyElements = [];

  @override
  void initState() {
    super.initState();
    _loadStory();
  }

  void _loadStory() {
    // Load story elements based on storyId
    _storyElements = _getSampleStoryElements();
  }

  List<StoryElement> _getSampleStoryElements() {
    return [
      const StoryElement(
        id: '1',
        text: 'Welcome to the Visual Story Adventure!',
        imagePath: 'assets/images/story_1.jpg',
        displayDuration: Duration(seconds: 3),
      ),
      const StoryElement(
        id: '2',
        text: 'In this story, you will learn about sign language through interactive elements.',
        imagePath: 'assets/images/story_2.jpg',
        displayDuration: Duration(seconds: 4),
      ),
      const StoryElement(
        id: '3',
        text: 'Let\'s start with the sign for "Hello". Watch the video carefully.',
        videoPath: 'assets/videos/hello_sign.mp4',
        signLanguageVideo: 'assets/videos/hello_sign_sl.mp4',
        displayDuration: Duration(seconds: 5),
      ),
      const StoryElement(
        id: '4',
        text: 'Now try to make the "Hello" sign yourself. Use the gesture recognition to practice.',
        choices: ['I got it!', 'Show me again', 'I need help'],
        displayDuration: Duration(seconds: 10),
      ),
      const StoryElement(
        id: '5',
        text: 'Great job! You\'ve learned your first sign. Let\'s continue with "Thank you".',
        imagePath: 'assets/images/story_3.jpg',
        displayDuration: Duration(seconds: 3),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final accessibilitySettings = ref.watch(accessibilityProvider);
    
    if (_storyElements.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final currentElement = _storyElements[_currentElementIndex];
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Story: ${widget.storyId}'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _togglePlayback,
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Indicator
          StoryProgressIndicator(
            currentIndex: _currentElementIndex,
            totalElements: _storyElements.length,
            fontSize: accessibilitySettings.fontSize,
          ),
          
          // Story Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: StoryElementWidget(
                element: currentElement,
                fontSize: accessibilitySettings.fontSize,
                enableSignLanguage: accessibilitySettings.enableSignLanguage,
                enableSubtitles: accessibilitySettings.enableSubtitles,
                onChoiceSelected: _handleChoiceSelection,
              ),
            ),
          ),
          
          // Navigation Controls
          Container(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _currentElementIndex > 0 ? _previousElement : null,
                  icon: const Icon(Icons.arrow_back),
                  label: Text(
                    'Previous',
                    style: TextStyle(fontSize: accessibilitySettings.fontSize),
                  ),
                ),
                
                if (_isPlaying)
                  ElevatedButton.icon(
                    onPressed: _pausePlayback,
                    icon: const Icon(Icons.pause),
                    label: Text(
                      'Pause',
                      style: TextStyle(fontSize: accessibilitySettings.fontSize),
                    ),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: _resumePlayback,
                    icon: const Icon(Icons.play_arrow),
                    label: Text(
                      'Play',
                      style: TextStyle(fontSize: accessibilitySettings.fontSize),
                    ),
                  ),
                
                ElevatedButton.icon(
                  onPressed: _currentElementIndex < _storyElements.length - 1 ? _nextElement : _completeStory,
                  icon: Icon(_currentElementIndex < _storyElements.length - 1 ? Icons.arrow_forward : Icons.check),
                  label: Text(
                    _currentElementIndex < _storyElements.length - 1 ? 'Next' : 'Complete',
                    style: TextStyle(fontSize: accessibilitySettings.fontSize),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _togglePlayback() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    
    if (_isPlaying) {
      _startAutoAdvance();
    } else {
      _stopAutoAdvance();
    }
  }

  void _pausePlayback() {
    setState(() {
      _isPlaying = false;
    });
    _stopAutoAdvance();
  }

  void _resumePlayback() {
    setState(() {
      _isPlaying = true;
    });
    _startAutoAdvance();
  }

  void _startAutoAdvance() {
    if (_currentElementIndex < _storyElements.length) {
      final element = _storyElements[_currentElementIndex];
      if (element.displayDuration != null) {
        Future.delayed(element.displayDuration!, () {
          if (_isPlaying && mounted) {
            _nextElement();
          }
        });
      }
    }
  }

  void _stopAutoAdvance() {
    // Auto-advance is handled by Future.delayed, so no explicit stopping needed
  }

  void _nextElement() {
    if (_currentElementIndex < _storyElements.length - 1) {
      setState(() {
        _currentElementIndex++;
      });
      
      if (_isPlaying) {
        _startAutoAdvance();
      }
    }
  }

  void _previousElement() {
    if (_currentElementIndex > 0) {
      setState(() {
        _currentElementIndex--;
      });
    }
  }

  void _handleChoiceSelection(String choice) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You selected: $choice'),
        duration: const Duration(seconds: 2),
      ),
    );
    
    // Auto-advance after choice selection
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _nextElement();
      }
    });
  }

  void _completeStory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Story Complete!'),
        content: const Text('Congratulations! You have completed this story.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }
}
