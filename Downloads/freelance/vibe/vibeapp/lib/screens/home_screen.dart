import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../core/providers/accessibility_provider.dart';
import '../core/providers/database_provider.dart';
import '../core/theme/app_theme.dart';
import '../core/models/achievement.dart';
import '../widgets/accessibility_banner.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/recent_activities.dart';
import '../widgets/gesture_visualizer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accessibilitySettings = ref.watch(accessibilityProvider);
    final currentUserId = ref.watch(currentUserIdProvider);
    final userStats = ref.watch(userStatsProvider(currentUserId));
    final achievements = ref.watch(unlockedAchievementsProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryColor.withOpacity(0.1),
              AppTheme.accentColor.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    _buildHeader(context, accessibilitySettings),
                    
                    SizedBox(height: 24.h),
                    
                    // Stats Cards
                    _buildStatsCards(context, userStats, achievements),
                    
                    SizedBox(height: 24.h),
                    
                    // Quick Actions
                    _buildQuickActions(context, accessibilitySettings),
                    
                    SizedBox(height: 24.h),
                    
                    // Recent Activities
                    _buildRecentActivities(context, accessibilitySettings),
                    
                    SizedBox(height: 24.h),
                    
                    // Gesture Visualizer
                    if (accessibilitySettings.enableVisualCues)
                      _buildGestureVisualizer(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, accessibilitySettings) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back! 👋',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Ready to learn and explore?',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppTheme.primaryGradient,
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(
            Icons.notifications_rounded,
            color: Colors.white,
            size: 24.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards(BuildContext context, AsyncValue<Map<String, dynamic>> userStats, AsyncValue<List<Achievement>> achievements) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Time Spent',
            value: userStats.when(
              data: (stats) => '${(stats['totalTime'] / 60).round()}m',
              loading: () => '...',
              error: (_, __) => '0m',
            ),
            icon: Icons.timer_rounded,
            color: AppTheme.primaryColor,
            gradient: AppTheme.primaryGradient,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _StatCard(
            title: 'Achievements',
            value: achievements.when(
              data: (achievements) => '${achievements.length}',
              loading: () => '...',
              error: (_, __) => '0',
            ),
            icon: Icons.emoji_events_rounded,
            color: AppTheme.warningColor,
            gradient: [AppTheme.warningColor, AppTheme.accentColor],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, accessibilitySettings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 16.h),
        const QuickActionsGrid(),
      ],
    );
  }

  Widget _buildRecentActivities(BuildContext context, accessibilitySettings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activities',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 16.h),
        const RecentActivities(),
      ],
    );
  }

  Widget _buildGestureVisualizer(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppTheme.accentGradient,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentColor.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Gesture Training',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12.h),
          const GestureVisualizer(
            gestures: [],
            isActive: false,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final List<Color> gradient;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24.sp,
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
