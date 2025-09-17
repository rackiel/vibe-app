import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/providers/accessibility_provider.dart';
import '../core/models/game_content.dart';
import '../widgets/game_card.dart';
// import '../widgets/difficulty_filter.dart'; // Commented out - file doesn't exist

class GamesScreen extends ConsumerStatefulWidget {
  const GamesScreen({super.key});

  @override
  ConsumerState<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends ConsumerState<GamesScreen> {
  DifficultyLevel _selectedDifficulty = DifficultyLevel.beginner;
  GameType? _selectedType = GameType.learning;

  @override
  Widget build(BuildContext context) {
    final accessibilitySettings = ref.watch(accessibilityProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Games & Learning'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(
                    'All',
                    _selectedType == null,
                    () => setState(() => _selectedType = null),
                    accessibilitySettings.fontSize,
                  ),
                  SizedBox(width: 8.w),
                  ...GameType.values.map((type) => Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: _buildFilterChip(
                      type.name.toUpperCase(),
                      _selectedType == type,
                      () => setState(() => _selectedType = type),
                      accessibilitySettings.fontSize,
                    ),
                  )),
                ],
              ),
            ),
          ),
          
          // Games List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: _getFilteredGames().length,
              itemBuilder: (context, index) {
                final game = _getFilteredGames()[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: GameCard(
                    game: game,
                    onTap: () => _navigateToGame(game),
                    fontSize: accessibilitySettings.fontSize,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap, double fontSize) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(fontSize: fontSize),
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
    );
  }

  List<GameContent> _getFilteredGames() {
    return _getSampleGames().where((game) {
      if (_selectedType != null && game.type != _selectedType) {
        return false;
      }
      return true;
    }).toList();
  }

  List<GameContent> _getSampleGames() {
    return [
      const GameContent(
        id: '1',
        title: 'Sign Language Basics',
        description: 'Learn basic sign language gestures through interactive lessons',
        type: GameType.learning,
        difficulty: DifficultyLevel.beginner,
        tags: ['sign language', 'basics', 'interactive'],
        estimatedDuration: Duration(minutes: 15),
        maxScore: 100,
      ),
      const GameContent(
        id: '2',
        title: 'Visual Story Adventure',
        description: 'Experience an interactive story with visual cues and sign language',
        type: GameType.story,
        difficulty: DifficultyLevel.intermediate,
        tags: ['story', 'adventure', 'visual'],
        estimatedDuration: Duration(minutes: 30),
        maxScore: 150,
      ),
      const GameContent(
        id: '3',
        title: 'Gesture Recognition Challenge',
        description: 'Test your gesture recognition skills with various hand signs',
        type: GameType.puzzle,
        difficulty: DifficultyLevel.advanced,
        tags: ['gestures', 'recognition', 'challenge'],
        estimatedDuration: Duration(minutes: 20),
        maxScore: 200,
      ),
      const GameContent(
        id: '4',
        title: 'Audio-Visual Quiz',
        description: 'Match audio patterns with their visual representations',
        type: GameType.quiz,
        difficulty: DifficultyLevel.intermediate,
        tags: ['audio', 'visual', 'quiz'],
        estimatedDuration: Duration(minutes: 10),
        maxScore: 120,
      ),
    ];
  }

  void _navigateToGame(GameContent game) {
    switch (game.type) {
      case GameType.story:
        context.go('/story/${game.id}');
        break;
      case GameType.learning:
      case GameType.puzzle:
      case GameType.quiz:
      case GameType.interactive:
        // Navigate to game play screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Starting ${game.title}...')),
        );
        break;
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Games'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Difficulty Level'),
            ...DifficultyLevel.values.map((level) => RadioListTile<DifficultyLevel>(
              title: Text(level.name.toUpperCase()),
              value: level,
              groupValue: _selectedDifficulty,
              onChanged: (value) {
                setState(() => _selectedDifficulty = value!);
                Navigator.pop(context);
              },
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
