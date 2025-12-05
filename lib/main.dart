import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:jsr_app/l10n/app_localizations.dart';
import 'providers/auth_provider.dart';
import 'providers/settings_provider.dart';
import 'models/app_theme.dart';
import 'services/storage_service.dart';
import 'services/api_service.dart';
import 'router/app_router.dart';
import 'utils/platform_utils.dart';
import 'widgets/back_button_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await StorageService.init();
  await ApiService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..init()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()..init()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, _) {
          final isIOS = PlatformUtils.isIOS;
          final theme = settingsProvider.theme;
          final themeMode = settingsProvider.themeMode;

          // For iOS, use Cupertino theme only for light mode
          final lightTheme = isIOS && themeMode == AppThemeMode.light
              ? ThemeData(
                  useMaterial3: true,
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: CupertinoColors.systemBlue,
                    brightness: Brightness.light,
                  ),
                  cupertinoOverrideTheme: const CupertinoThemeData(
                    primaryColor: CupertinoColors.systemBlue,
                  ),
                )
              : theme;

          return BackButtonHandler(
            child: MaterialApp.router(
              onGenerateTitle: (context) =>
                  AppLocalizations.of(context)?.appTitle ??
                  'Water Tank Management',
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: themeMode == AppThemeMode.dark
                  ? theme
                  : ThemeData(
                      useMaterial3: true,
                      colorScheme: ColorScheme.fromSeed(
                        seedColor: Colors.blue,
                        brightness: Brightness.dark,
                      ),
                    ),
              themeMode: themeMode == AppThemeMode.dark
                  ? ThemeMode.dark
                  : ThemeMode.light,
              locale: settingsProvider.locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: AppRouter.router,
            ),
          );
        },
      ),
    );
  }
}
