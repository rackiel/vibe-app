import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/models/game_content.dart';

class GameCard extends StatelessWidget {
  final GameContent game;
  final VoidCallback onTap;
  final double fontSize;
  
  const GameCard({
    super.key,
    required this.game,
    required this.onTap,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getGameIcon(game.type),
                    size: 32.w,
                    color: _getGameColor(game.type),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          game.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: fontSize + 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          game.description,
                          style: TextStyle(
                            fontSize: fontSize - 2,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 12.h),
              
              // Tags
              Wrap(
                spacing: 8.w,
                runSpacing: 4.h,
                children: game.tags.take(3).map((tag) => Chip(
                  label: Text(
                    tag,
                    style: TextStyle(fontSize: fontSize - 4),
                  ),
                  backgroundColor: _getGameColor(game.type).withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: _getGameColor(game.type),
                    fontSize: fontSize - 4,
                  ),
                )).toList(),
              ),
              
              SizedBox(height: 12.h),
              
              // Bottom row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.timer,
                        size: 16.w,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _formatDuration(game.estimatedDuration),
                        style: TextStyle(
                          fontSize: fontSize - 2,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16.w,
                        color: Colors.amber,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _getDifficultyText(game.difficulty),
                        style: TextStyle(
                          fontSize: fontSize - 2,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: _getGameColor(game.type),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      '${game.maxScore} pts',
                      style: TextStyle(
                        fontSize: fontSize - 2,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getGameIcon(GameType type) {
    switch (type) {
      case GameType.learning:
        return Icons.school;
      case GameType.story:
        return Icons.book;
      case GameType.puzzle:
        return Icons.extension;
      case GameType.interactive:
        return Icons.touch_app;
      case GameType.quiz:
        return Icons.quiz;
    }
  }

  Color _getGameColor(GameType type) {
    switch (type) {
      case GameType.learning:
        return Colors.blue;
      case GameType.story:
        return Colors.purple;
      case GameType.puzzle:
        return Colors.orange;
      case GameType.interactive:
        return Colors.green;
      case GameType.quiz:
        return Colors.red;
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inMinutes < 60) {
      return '${duration.inMinutes}m';
    } else {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      return '${hours}h ${minutes}m';
    }
  }

  String _getDifficultyText(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return 'Easy';
      case DifficultyLevel.intermediate:
        return 'Medium';
      case DifficultyLevel.advanced:
        return 'Hard';
      case DifficultyLevel.expert:
        return 'Expert';
    }
  }
}
