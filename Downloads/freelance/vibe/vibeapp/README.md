# VIBE - Visual and Interactive-Based Experience for the Hearing Impaired

VIBE is a comprehensive Flutter application designed to enhance communication and learning for individuals with hearing impairments through visual and interactive methods.

## Features

### 🎯 Core Modules

#### 1. User Interaction
- **Gesture Recognition**: Detects hand signs and movements for system interaction
- **Haptic Feedback**: Provides physical responses through vibrations
- **Visual Cues**: Uses symbols, icons, and visual indicators to guide users

#### 2. Game Logic and Middleware
- **AI-Based Audio-to-Visual Conversion**: Converts sounds and speech into visual formats
- **Real-time Subtitle Generation**: Automatically generates text captions for audio content
- **Adaptive Difficulty**: Adjusts learning difficulty based on user performance

#### 3. Game Content and Design
- **Visual Storytelling**: Engaging narratives using visual elements
- **Sign Language Integration**: Incorporates sign language for instructions and dialogue
- **Interactive UI**: User interface designed for easy, visual-first interaction

#### 4. Rendering and Feedback
- **Dynamic Lighting and Color Coding**: Uses lighting effects and color schemes for enhanced understanding
- **Accessibility Profiles**: Customizable settings for different user needs

## GitHub Actions

This repository uses GitHub Actions to automatically build APK files for Android. The workflow is configured to:

- Build both Debug and Release APK files
- Run tests automatically
- Upload APK files as downloadable artifacts
- Create GitHub releases for the main branch

To download the latest APK:
1. Go to the "Actions" tab in this repository
2. Find the latest successful workflow run
3. Download the APK from the "Artifacts" section

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code
- Android device or emulator

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd vibeapp
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── models/           # Data models and structures
│   ├── providers/        # State management providers
│   ├── services/         # Core services (gesture recognition, audio-visual)
│   ├── theme/           # App theming and styling
│   └── router/          # Navigation configuration
├── screens/             # Main application screens
├── widgets/             # Reusable UI components
└── main.dart           # Application entry point
```

## Key Features

### Accessibility Support
- **High Contrast Mode**: Enhanced visibility for users with visual impairments
- **Font Size Adjustment**: Customizable text size for better readability
- **Reduced Motion**: Option to minimize animations and transitions
- **Haptic Feedback**: Vibration patterns for different interactions

### Gesture Recognition
- Real-time hand gesture detection using camera
- Support for various gesture types (tap, swipe, pinch, hand signs)
- Confidence scoring for gesture accuracy
- Visual feedback for gesture recognition status

### Audio-Visual Processing
- Speech-to-text conversion with real-time subtitles
- Audio visualization through waveforms and frequency bars
- Color-coded feedback based on audio intensity
- Support for multiple audio formats

### Learning Content
- Interactive story-based learning modules
- Sign language video integration
- Adaptive difficulty progression
- Progress tracking and statistics

## Dependencies

- **flutter_riverpod**: State management
- **go_router**: Navigation
- **camera**: Camera access for gesture recognition
- **audioplayers**: Audio playback
- **speech_to_text**: Speech recognition
- **flutter_tts**: Text-to-speech
- **tflite_flutter**: Machine learning model inference
- **vibration**: Haptic feedback

## Configuration

### Android Permissions
The app requires the following permissions:
- `CAMERA`: For gesture recognition
- `RECORD_AUDIO`: For speech recognition
- `VIBRATE`: For haptic feedback
- `INTERNET`: For online features

### Model Files
Place TensorFlow Lite models in `assets/models/`:
- `gesture_model.tflite`: Gesture recognition model

## Usage

### Setting Up Accessibility Profile
1. Open the app and navigate to Profile
2. Configure your hearing level and preferred language
3. Enable/disable specific accessibility features
4. Adjust font size and vibration intensity

### Gesture Training
1. Go to Gesture Training screen
2. Start the camera for real-time gesture detection
3. Practice different hand signs and gestures
4. Monitor confidence scores and improve accuracy

### Audio-Visual Experience
1. Navigate to Audio-Visual screen
2. Test speech recognition and audio playback
3. Observe visual representations of audio content
4. View real-time subtitles

### Learning Games
1. Browse available games and stories
2. Select content based on difficulty level
3. Follow interactive instructions
4. Track your progress and achievements

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please contact the development team or create an issue in the repository.

## Acknowledgments

- Flutter team for the excellent framework
- TensorFlow team for machine learning capabilities
- Accessibility community for feedback and suggestions
