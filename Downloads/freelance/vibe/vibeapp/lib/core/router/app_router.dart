import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens/splash_screen.dart';
import '../../screens/onboarding_screen.dart';
import '../../screens/main_layout.dart';
import '../../screens/settings_screen.dart';
import '../../screens/story_screen.dart';
import '../../screens/accessibility_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const MainLayout(initialIndex: 0),
      ),
      GoRoute(
        path: '/',
        redirect: (context, state) => '/home',
      ),
      GoRoute(
        path: '/games',
        name: 'games',
        builder: (context, state) => const MainLayout(initialIndex: 1),
      ),
      GoRoute(
        path: '/gesture-training',
        name: 'gesture-training',
        builder: (context, state) => const MainLayout(initialIndex: 2),
      ),
      GoRoute(
        path: '/audio-visual',
        name: 'audio-visual',
        builder: (context, state) => const MainLayout(initialIndex: 3),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const MainLayout(initialIndex: 4),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/story/:storyId',
        name: 'story',
        builder: (context, state) {
          final storyId = state.pathParameters['storyId']!;
          return StoryScreen(storyId: storyId);
        },
      ),
      GoRoute(
        path: '/accessibility',
        name: 'accessibility',
        builder: (context, state) => const AccessibilityScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
