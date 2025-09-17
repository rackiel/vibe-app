import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import '../core/providers/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _currentPage = 0;
  final int _totalPages = 4;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      title: 'Welcome to VIBE',
      subtitle: 'Visual Interactive Experience',
      description: 'An innovative app designed specifically for the hearing impaired community to enhance learning and communication through visual and interactive experiences.',
      icon: Icons.volume_up_rounded,
      gradient: AppTheme.primaryGradient,
    ),
    OnboardingData(
      title: 'Gesture Training',
      subtitle: 'Learn Sign Language',
      description: 'Master sign language through interactive gesture recognition and training modules. Practice with real-time feedback and progress tracking.',
      icon: Icons.gesture_rounded,
      gradient: [AppTheme.accentColor, AppTheme.secondaryColor],
    ),
    OnboardingData(
      title: 'Interactive Games',
      subtitle: 'Learn While Playing',
      description: 'Engage with educational games designed to improve communication skills, memory, and cognitive abilities in a fun and interactive way.',
      icon: Icons.games_rounded,
      gradient: [AppTheme.successColor, AppTheme.warningColor],
    ),
    OnboardingData(
      title: 'Audio-Visual Learning',
      subtitle: 'Multi-Sensory Experience',
      description: 'Experience learning through visual cues, vibrations, and audio feedback. Customize your learning experience based on your preferences.',
      icon: Icons.visibility_rounded,
      gradient: [AppTheme.warningColor, AppTheme.accentColor],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
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
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _completeOnboarding() async {
    await ref.read(onboardingProvider.notifier).completeOnboarding();
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              // Skip Button
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Page Indicator
                    Row(
                      children: List.generate(
                        _totalPages,
                        (index) => Container(
                          margin: EdgeInsets.only(right: 8.w),
                          width: _currentPage == index ? 24.w : 8.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppTheme.primaryColor
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _skipOnboarding,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Page View
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _totalPages,
                  itemBuilder: (context, index) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: _buildOnboardingPage(_onboardingData[index]),
                      ),
                    );
                  },
                ),
              ),
              
              // Navigation Buttons
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Previous Button
                    if (_currentPage > 0)
                      TextButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text(
                          'Previous',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 80),
                    
                    // Next/Get Started Button
                    ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.w,
                          vertical: 16.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        elevation: 8,
                        shadowColor: AppTheme.primaryColor.withOpacity(0.3),
                      ),
                      child: Text(
                        _currentPage == _totalPages - 1 ? 'Get Started' : 'Next',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingData data) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Container
          Container(
            width: 200.w,
            height: 200.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: data.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: data.gradient.first.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              data.icon,
              size: 100.sp,
              color: Colors.white,
            ),
          ),
          
          SizedBox(height: 60.h),
          
          // Title
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Subtitle
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              color: data.gradient.first,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          SizedBox(height: 32.h),
          
          // Description
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
              height: 1.6,
            ),
          ),
          
          SizedBox(height: 40.h),
          
          // Feature Highlights
          _buildFeatureHighlights(data),
        ],
      ),
    );
  }

  Widget _buildFeatureHighlights(OnboardingData data) {
    List<String> features = [];
    
    switch (data.title) {
      case 'Welcome to VIBE':
        features = ['Accessibility First', 'Visual Learning', 'Progress Tracking'];
        break;
      case 'Gesture Training':
        features = ['Real-time Feedback', 'Progress Tracking', 'Customizable Lessons'];
        break;
      case 'Interactive Games':
        features = ['Educational Content', 'Fun Learning', 'Skill Building'];
        break;
      case 'Audio-Visual Learning':
        features = ['Multi-sensory', 'Customizable', 'Adaptive Learning'];
        break;
    }

    return Column(
      children: features.map((feature) => Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 12.h,
        ),
        decoration: BoxDecoration(
          color: data.gradient.first.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(
            color: data.gradient.first.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: data.gradient.first,
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              feature,
              style: TextStyle(
                fontSize: 14.sp,
                color: data.gradient.first,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final List<Color> gradient;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.gradient,
  });
}
