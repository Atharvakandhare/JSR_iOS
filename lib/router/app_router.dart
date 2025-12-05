import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/societies/societies_list_screen.dart';
import '../screens/societies/society_details_screen.dart';
import '../screens/societies/create_edit_society_screen.dart';
import '../screens/tanks/tanks_list_screen.dart';
import '../screens/tanks/tank_details_screen.dart';
import '../screens/tanks/create_edit_tank_screen.dart';
import '../screens/cleaning_records/cleaning_records_list_screen.dart';
import '../screens/cleaning_records/cleaning_record_details_screen.dart';
import '../screens/cleaning_records/create_edit_cleaning_record_screen.dart';
import '../screens/cleaning_records/upcoming_cleanings_screen.dart';
import '../screens/cleaning_records/overdue_cleanings_screen.dart';
import '../screens/analytics/analytics_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../providers/auth_provider.dart';
import '../services/storage_service.dart';

class AppRouter {
  static GoRouter get router => _router;

  static final _router = GoRouter(
    initialLocation: StorageService.getToken() != null
        ? '/dashboard'
        : '/login',
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Page Not Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Error: ${state.error}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Location: ${state.uri}',
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/dashboard'),
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    ),
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isLoggedIn = authProvider.isAuthenticated;
      final isGoingToLogin = state.matchedLocation == '/login';

      if (!isLoggedIn && !isGoingToLogin) {
        return '/login';
      }
      if (isLoggedIn && isGoingToLogin) {
        return '/dashboard';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      // Societies routes
      GoRoute(
        path: '/societies',
        builder: (context, state) => const SocietiesListScreen(),
      ),
      GoRoute(
        path: '/societies/:id(\\d+)',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return SocietyDetailsScreen(societyId: id);
        },
      ),
      GoRoute(
        path: '/societies/new',
        builder: (context, state) => const CreateEditSocietyScreen(),
      ),
      GoRoute(
        path: '/societies/:id(\\d+)/edit',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return CreateEditSocietyScreen(societyId: id);
        },
      ),
      // Tanks routes
      GoRoute(
        path: '/tanks',
        builder: (context, state) => const TanksListScreen(),
      ),
      GoRoute(
        path: '/tanks/:id(\\d+)',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return TankDetailsScreen(tankId: id);
        },
      ),
      GoRoute(
        path: '/tanks/new',
        builder: (context, state) {
          final societyIdStr = state.uri.queryParameters['societyId'];
          final societyId = societyIdStr != null
              ? int.tryParse(societyIdStr)
              : null;
          return CreateEditTankScreen(initialSocietyId: societyId);
        },
      ),
      GoRoute(
        path: '/tanks/:id(\\d+)/edit',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return CreateEditTankScreen(tankId: id);
        },
      ),
      // Cleaning records routes
      GoRoute(
        path: '/cleaning-records',
        builder: (context, state) => const CleaningRecordsListScreen(),
      ),
      GoRoute(
        path: '/cleaning-records/new',
        builder: (context, state) => const CreateEditCleaningRecordScreen(),
      ),
      GoRoute(
        path: '/cleaning-records/upcoming',
        builder: (context, state) => const UpcomingCleaningsScreen(),
      ),
      GoRoute(
        path: '/cleaning-records/overdue',
        builder: (context, state) => const OverdueCleaningsScreen(),
      ),
      GoRoute(
        path: '/cleaning-records/:id(\\d+)/edit',
        builder: (context, state) {
          final idStr = state.pathParameters['id'] ?? '';
          final id = int.tryParse(idStr);
          if (id == null) {
            return const Scaffold(
              body: Center(child: Text('Invalid record ID')),
            );
          }
          return CreateEditCleaningRecordScreen(recordId: id);
        },
      ),
      GoRoute(
        path: '/cleaning-records/:id(\\d+)',
        builder: (context, state) {
          final idStr = state.pathParameters['id'] ?? '';
          final id = int.tryParse(idStr);
          if (id == null) {
            return const Scaffold(
              body: Center(child: Text('Invalid record ID')),
            );
          }
          return CleaningRecordDetailsScreen(recordId: id);
        },
      ),
      // Analytics route
      GoRoute(
        path: '/analytics',
        builder: (context, state) => const AnalyticsScreen(),
      ),
      // Settings route
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
