import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_service.dart';
import '../models/user_progress.dart';
import '../models/achievement.dart';

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

final userProgressProvider = FutureProvider.family<List<UserProgress>, String>((ref, userId) async {
  final databaseService = ref.read(databaseServiceProvider);
  return await databaseService.getUserProgress(userId);
});

final achievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  final databaseService = ref.read(databaseServiceProvider);
  return await databaseService.getAllAchievements();
});

final unlockedAchievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  final databaseService = ref.read(databaseServiceProvider);
  return await databaseService.getUnlockedAchievements();
});

final userStatsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
  final databaseService = ref.read(databaseServiceProvider);
  return await databaseService.getUserStats(userId);
});

final currentUserIdProvider = StateProvider<String>((ref) {
  return 'user_001'; // Default user ID, in a real app this would come from authentication
});
