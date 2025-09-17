import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/providers/accessibility_provider.dart';
import 'core/providers/gesture_provider.dart';
import 'core/providers/audio_visual_provider.dart';
import 'core/providers/database_provider.dart';
import 'core/providers/onboarding_provider.dart';

void main() {
  runApp(
    ProviderScope(
      child: VibeApp(),
    ),
  );
}

class VibeApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilitySettings = ref.watch(accessibilityProvider);
    
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'VIBE - Visual Interactive Experience',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: accessibilitySettings.themeMode,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('es', 'ES'),
            Locale('fr', 'FR'),
          ],
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
