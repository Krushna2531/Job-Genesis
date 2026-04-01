import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/jobs/presentation/pages/job_feed_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/tracker/presentation/pages/tracker_page.dart';
import '../../features/interview/presentation/pages/mock_interview_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../shared/widgets/main_shell.dart';

/// Centralized route definitions.
/// All route names are constants — no magic strings scattered in widgets.
abstract class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String jobFeed = '/jobs';
  static const String jobDetail = '/jobs/:id';
  static const String search = '/search';
  static const String saved = '/saved';
  static const String tracker = '/tracker';
  static const String mockInterview = '/mock-interview';
  static const String codeEditor = '/code-editor';
  static const String profile = '/profile';
  static const String recruiterDashboard = '/recruiter';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: [
    // ─── Auth Flow ───────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.splash,
      pageBuilder: (context, state) => _buildPage(
        state: state,
        child: const SplashPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      pageBuilder: (context, state) => _buildPage(
        state: state,
        child: const OnboardingPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.login,
      pageBuilder: (context, state) => _buildPage(
        state: state,
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.register,
      pageBuilder: (context, state) => _buildPage(
        state: state,
        child: const RegisterPage(),
      ),
    ),

    // ─── Main Shell (Bottom Nav) ─────────────────────────────────
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          pageBuilder: (context, state) => _buildPage(
            state: state,
            child: const HomePage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.jobFeed,
          pageBuilder: (context, state) => _buildPage(
            state: state,
            child: const JobFeedPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.search,
          pageBuilder: (context, state) => _buildPage(
            state: state,
            child: const SearchPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.tracker,
          pageBuilder: (context, state) => _buildPage(
            state: state,
            child: const TrackerPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.mockInterview,
          pageBuilder: (context, state) => _buildPage(
            state: state,
            child: const MockInterviewPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.profile,
          pageBuilder: (context, state) => _buildPage(
            state: state,
            child: const ProfilePage(),
          ),
        ),
      ],
    ),
  ],
);

/// Custom page transition — smooth fade slide.
CustomTransitionPage<void> _buildPage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.03),
            end: Offset.zero,
          ).animate(CurveTween(curve: Curves.easeOut).animate(animation)),
          child: child,
        ),
      );
    },
  );
}
