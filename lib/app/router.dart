import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/models/safezone_enums.dart';
import '../features/admin/admin_screens.dart';
import '../features/ai_calling/ai_calling_screen.dart';
import '../features/auth/auth_controller.dart';
import '../features/auth/auth_screens.dart';
import '../features/authority/authority_screens.dart';
import '../features/landing/landing_screen.dart';
import '../features/resident/resident_screens.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authControllerProvider);
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final path = state.uri.path;
      final public = path == '/' ||
          path == '/login' ||
          path == '/register' ||
          path == '/forgot' ||
          path == '/onboarding';
      if (!auth.authenticated && !public) return '/login';
      if (auth.authenticated && (path == '/login' || path == '/register')) {
        return _homeFor(auth.user!.role);
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LandingScreen()),
      GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen()),
      GoRoute(
          path: '/forgot',
          builder: (context, state) => const ForgotPasswordScreen()),
      GoRoute(
          path: '/resident',
          builder: (context, state) => const ResidentDashboardScreen()),
      GoRoute(
          path: '/resident/report',
          builder: (context, state) => const ReportIncidentScreen()),
      GoRoute(
          path: '/resident/fir',
          builder: (context, state) => const FirWizardScreen()),
      GoRoute(
          path: '/resident/sos',
          builder: (context, state) => const SosScreen()),
      GoRoute(
          path: '/resident/map',
          builder: (context, state) => const SafeMapScreen()),
      GoRoute(
          path: '/resident/incidents',
          builder: (context, state) => const MyIncidentsScreen()),
      GoRoute(
          path: '/resident/firs',
          builder: (context, state) => const MyFirsScreen()),
      GoRoute(
          path: '/resident/notifications',
          builder: (context, state) => const NotificationsScreen()),
      GoRoute(
          path: '/resident/profile',
          builder: (context, state) => const ProfileScreen()),
      GoRoute(
          path: '/authority',
          builder: (context, state) => const AuthorityDashboardScreen()),
      GoRoute(
          path: '/authority/reports',
          builder: (context, state) => const FieldReportsScreen()),
      GoRoute(
          path: '/authority/map',
          builder: (context, state) => const DispatchMapScreen()),
      GoRoute(
          path: '/authority/kanban',
          builder: (context, state) => const KanbanScreen()),
      GoRoute(
          path: '/authority/firs',
          builder: (context, state) => const FirManagementScreen()),
      GoRoute(
          path: '/authority/sos',
          builder: (context, state) => const SosLogsScreen()),
      GoRoute(
          path: '/authority/alerts',
          builder: (context, state) => const BroadcastAlertScreen()),
      GoRoute(
          path: '/authority/users',
          builder: (context, state) => const UserManagementScreen()),
      GoRoute(
          path: '/authority/ai',
          builder: (context, state) => const AiCallingScreen()),
      GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminCommandCenterScreen()),
    ],
    errorBuilder: (context, state) => const LandingScreen(),
  );
});

String _homeFor(UserRole role) {
  return switch (role) {
    UserRole.resident => '/resident',
    UserRole.authority => '/authority',
    UserRole.admin => '/authority',
    UserRole.superAdmin => '/admin',
  };
}

extension SafeZoneRouting on BuildContext {
  void goHomeFor(UserRole role) => go(_homeFor(role));
}
