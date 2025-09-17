import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../core/providers/accessibility_provider.dart';
import 'home_screen.dart';
import 'games_screen.dart';
import 'gesture_training_screen.dart';
import 'audio_visual_screen.dart';
import 'profile_screen.dart';

class MainLayout extends ConsumerStatefulWidget {
  final int initialIndex;
  
  const MainLayout({
    super.key,
    this.initialIndex = 0,
  });

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;
  
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const GamesScreen(),
    const GestureTrainingScreen(),
    const AudioVisualScreen(),
    const ProfileScreen(),
  ];

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home_rounded,
      activeIcon: Icons.home_rounded,
      label: 'Home',
      color: const Color(0xFF667eea),
    ),
    NavigationItem(
      icon: Icons.games_rounded,
      activeIcon: Icons.games_rounded,
      label: 'Games',
      color: const Color(0xFFf093fb),
    ),
    NavigationItem(
      icon: Icons.gesture_rounded,
      activeIcon: Icons.gesture_rounded,
      label: 'Gestures',
      color: const Color(0xFF764ba2),
    ),
    NavigationItem(
      icon: Icons.volume_up_rounded,
      activeIcon: Icons.volume_up_rounded,
      label: 'Audio-Visual',
      color: const Color(0xFF4facfe),
    ),
    NavigationItem(
      icon: Icons.person_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
      color: const Color(0xFF43e97b),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeInOut,
    ));
    
    _fabController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;
    
    setState(() {
      _currentIndex = index;
    });
    
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final accessibilitySettings = ref.watch(accessibilityProvider);
    
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.95),
              Colors.white,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 80.h,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _navigationItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isActive = index == _currentIndex;
                
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onItemTapped(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: isActive 
                            ? item.color.withOpacity(0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: isActive 
                                  ? item.color
                                  : Colors.grey.withOpacity(0.3),
                              shape: BoxShape.circle,
                              boxShadow: isActive ? [
                                BoxShadow(
                                  color: item.color.withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ] : null,
                            ),
                            child: Icon(
                              isActive ? item.activeIcon : item.icon,
                              color: isActive ? Colors.white : Colors.grey[600],
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                              color: isActive ? item.color : Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fabAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _fabAnimation.value,
            child: FloatingActionButton(
              onPressed: () {
                // Add quick action functionality
                _showQuickActions(context);
              },
              backgroundColor: const Color(0xFF667eea),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _QuickActionButton(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  color: const Color(0xFF4facfe),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to camera
                  },
                ),
                _QuickActionButton(
                  icon: Icons.mic_rounded,
                  label: 'Voice',
                  color: const Color(0xFFf093fb),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to voice
                  },
                ),
                _QuickActionButton(
                  icon: Icons.text_fields_rounded,
                  label: 'Text',
                  color: const Color(0xFF43e97b),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to text
                  },
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Color color;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.color,
  });
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 24.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
