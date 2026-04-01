import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // TODO: Initialize other services (e.g., Firebase, shared preferences if needed before app start)
  // Force portrait mode — landscape handled per-screen (code editor)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Transparent status bar — our design extends edge to edge
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    // ProviderScope is the Riverpod root — wraps entire widget tree
    const ProviderScope(
      child: JobGenesisApp(),
    ),
  );
}

class JobGenesisApp extends StatelessWidget {
  const JobGenesisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // Base iPhone screen size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'JobGenesis',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          routerConfig: appRouter,
        );
      },
    );
  }
}
