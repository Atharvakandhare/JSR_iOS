import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:jsr_app/l10n/app_localizations.dart';
import '../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static Widget menuButton({IconData icon = Icons.menu}) {
    return Builder(
      builder: (context) => IconButton(
        icon: Icon(icon),
        onPressed: () => Scaffold.of(context).openDrawer(),
        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      ),
    );
  }

  void _navigate(BuildContext context, String route) {
    Navigator.pop(context);
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 160,
            decoration: const BoxDecoration(color: Colors.transparent),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/jsr_logo.jpg',
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: Text(localizations?.drawerDashboard ?? 'Dashboard'),
            onTap: () => _navigate(context, '/dashboard'),
          ),
          ListTile(
            leading: const Icon(Icons.apartment),
            title: Text(localizations?.drawerSocieties ?? 'Societies'),
            onTap: () => _navigate(context, '/societies'),
          ),
          ListTile(
            leading: const Icon(Icons.water_drop),
            title: Text(localizations?.drawerTanks ?? 'Tanks'),
            onTap: () => _navigate(context, '/tanks'),
          ),
          ListTile(
            leading: const Icon(Icons.cleaning_services),
            title: Text(
              localizations?.drawerCleaningRecords ?? 'Cleaning Records',
            ),
            onTap: () => _navigate(context, '/cleaning-records'),
          ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: Text(localizations?.drawerAnalytics ?? 'Analytics'),
            onTap: () => _navigate(context, '/analytics'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(localizations?.drawerSettings ?? 'Settings'),
            onTap: () => _navigate(context, '/settings'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              localizations?.drawerLogout ?? 'Logout',
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () async {
              Navigator.pop(context);
              final authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );
              await authProvider.logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
