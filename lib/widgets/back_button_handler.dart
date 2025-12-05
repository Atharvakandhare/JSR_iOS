import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// Global back button handler that ensures users navigate to dashboard
/// before closing the app. If user is on any screen other than dashboard,
/// it redirects to dashboard. Only from dashboard can the app be closed.
class BackButtonHandler extends StatelessWidget {
  final Widget child;

  const BackButtonHandler({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final router = GoRouter.of(context);
        // Get current location from router
        final currentLocation =
            router.routerDelegate.currentConfiguration.uri.path;

        // Skip handling for login page (let it work normally)
        if (currentLocation == '/login') {
          return true;
        }

        // If already on dashboard, show exit confirmation
        if (currentLocation == '/dashboard') {
          final shouldExit = await _showExitConfirmation(context);
          if (shouldExit == true && context.mounted) {
            SystemNavigator.pop();
            return false; // Prevent default back button behavior
          }
          return false; // Prevent default back button behavior
        } else {
          // If not on dashboard, navigate to dashboard
          if (context.mounted) {
            router.go('/dashboard');
          }
          return false; // Prevent default back button behavior
        }
      },
      child: child,
    );
  }

  Future<bool?> _showExitConfirmation(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit the application?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}
