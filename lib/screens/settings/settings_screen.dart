import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:jsr_app/l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_drawer.dart';
import '../../utils/date_formatter.dart';
import '../../providers/settings_provider.dart';
import '../../models/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _twoFactorTokenController = TextEditingController();
  final _twoFactorVerificationController = TextEditingController();
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isChangingPassword = false;
  bool _isSettingUp2FA = false;
  bool _isVerifying2FA = false;
  String? _qrCodeData;
  String? _twoFactorSecret;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _twoFactorTokenController.dispose();
    _twoFactorVerificationController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    // Validate fields are not empty
    if (_currentPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your current password')),
      );
      return;
    }

    if (_newPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a new password')),
      );
      return;
    }

    if (_confirmPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please confirm your new password')),
      );
      return;
    }

    // Validate password length
    if (_newPasswordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New password must be at least 6 characters long'),
        ),
      );
      return;
    }

    // Validate passwords match
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    // Validate new password is different from current password
    if (_currentPasswordController.text == _newPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New password must be different from current password'),
        ),
      );
      return;
    }

    setState(() => _isChangingPassword = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.changePassword(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully')),
      );
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'Failed to change password'),
        ),
      );
    }

    setState(() => _isChangingPassword = false);
  }

  Future<void> _setup2FA() async {
    setState(() => _isSettingUp2FA = true);

    final response = await AuthService.setup2FA();

    if (response.success && response.data != null && mounted) {
      final qrCodeString = response.data!['qrCode'] as String?;
      final secret = response.data!['secret'] as String?;
      if (qrCodeString != null && secret != null) {
        setState(() {
          _qrCodeData = qrCodeString;
          _twoFactorSecret = secret;
          // Pre-fill the token field with the secret
          _twoFactorTokenController.text = secret;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'QR code generated. Copy the token to your authenticator app.',
            ),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('QR code or secret data not received')),
        );
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? 'Failed to setup 2FA')),
      );
    }

    setState(() => _isSettingUp2FA = false);
  }

  Future<void> _copySecretToken() async {
    if (_twoFactorSecret != null) {
      await Clipboard.setData(ClipboardData(text: _twoFactorSecret!));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Token copied to clipboard! Paste it in your authenticator app.',
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _verify2FA() async {
    if (_twoFactorVerificationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter 6-digit 2FA code')),
      );
      return;
    }

    setState(() => _isVerifying2FA = true);

    final response = await AuthService.verify2FA(
      _twoFactorVerificationController.text,
    );

    if (response.success && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('2FA enabled successfully')));
      setState(() {
        _qrCodeData = null;
        _twoFactorSecret = null;
        _twoFactorTokenController.clear();
        _twoFactorVerificationController.clear();
      });
      // Refresh user data
      Provider.of<AuthProvider>(context, listen: false).init();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? 'Failed to verify 2FA')),
      );
    }

    setState(() => _isVerifying2FA = false);
  }

  Future<void> _disable2FA() async {
    final tokenController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disable 2FA'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your 2FA token to disable:'),
            const SizedBox(height: 16),
            TextField(
              controller: tokenController,
              decoration: const InputDecoration(
                labelText: '2FA Token',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Disable'),
          ),
        ],
      ),
    );

    if (confirmed == true && tokenController.text.isNotEmpty) {
      final response = await AuthService.disable2FA(tokenController.text);
      if (response.success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('2FA disabled successfully')),
        );
        Provider.of<AuthProvider>(context, listen: false).init();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? 'Failed to disable 2FA')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.settingsTitle)),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Consumer2<AuthProvider, SettingsProvider>(
          builder: (context, authProvider, settingsProvider, _) {
            final selectedLocaleCode =
                settingsProvider.locale?.languageCode ?? 'en';
            final languageOptions = [
              {'code': 'en', 'label': localizations.languageEnglish},
              {'code': 'hi', 'label': localizations.languageHindi},
              {'code': 'mr', 'label': localizations.languageMarathi},
            ];
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Username: ${authProvider.user?.username ?? 'N/A'}',
                          ),
                          if (authProvider.user?.createdAt != null)
                            Text(
                              'Created: ${DateFormatter.formatDate(authProvider.user!.createdAt)}',
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.themeSectionTitle,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            localizations.themeSectionDescription,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          _buildThemeOption(
                            context,
                            localizations.themeLight,
                            AppThemeMode.light,
                            settingsProvider.themeMode,
                            Icons.light_mode,
                            () => settingsProvider.setTheme(AppThemeMode.light),
                          ),
                          const SizedBox(height: 12),
                          _buildThemeOption(
                            context,
                            localizations.themeDark,
                            AppThemeMode.dark,
                            settingsProvider.themeMode,
                            Icons.dark_mode,
                            () => settingsProvider.setTheme(AppThemeMode.dark),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.languageSectionTitle,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            localizations.languageSectionDescription,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            initialValue: selectedLocaleCode,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: localizations.languageSectionTitle,
                            ),
                            items: languageOptions
                                .map(
                                  (option) => DropdownMenuItem<String>(
                                    value: option['code'],
                                    child: Text(option['label']!),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                settingsProvider.setLocale(Locale(value));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Change Password',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _currentPasswordController,
                            obscureText: _obscureCurrentPassword,
                            decoration: InputDecoration(
                              labelText: 'Current Password',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureCurrentPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureCurrentPassword =
                                        !_obscureCurrentPassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _newPasswordController,
                            obscureText: _obscureNewPassword,
                            decoration: InputDecoration(
                              labelText: 'New Password',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureNewPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureNewPassword = !_obscureNewPassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            decoration: InputDecoration(
                              labelText: 'Confirm New Password',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isChangingPassword
                                  ? null
                                  : _changePassword,
                              child: _isChangingPassword
                                  ? const CircularProgressIndicator()
                                  : const Text('Change Password'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Two-Factor Authentication',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                authProvider.user?.twoFactorEnabled == true
                                    ? 'Enabled'
                                    : 'Disabled',
                                style: TextStyle(
                                  color:
                                      authProvider.user?.twoFactorEnabled ==
                                          true
                                      ? Colors.green
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (authProvider.user?.twoFactorEnabled == true)
                            ElevatedButton(
                              onPressed: _disable2FA,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Disable 2FA'),
                            )
                          else ...[
                            if (_qrCodeData == null)
                              ElevatedButton(
                                onPressed: _isSettingUp2FA ? null : _setup2FA,
                                child: _isSettingUp2FA
                                    ? const CircularProgressIndicator()
                                    : const Text('Setup 2FA'),
                              )
                            else ...[
                              const Text(
                                'Setup 2FA using one of these methods:',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Option 1: Scan the QR code below with your authenticator app (Google Authenticator, Authy, or Microsoft Authenticator)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Option 2: Copy the secret token and paste it manually in your authenticator app',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              if (_qrCodeData != null) ...[
                                const SizedBox(height: 16),
                                Center(child: _buildQRCodeImage(_qrCodeData!)),
                              ],
                              const SizedBox(height: 16),
                              Text(
                                '2FA Secret Token (Copy this to your authenticator app):',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _twoFactorTokenController,
                                decoration: InputDecoration(
                                  labelText: '2FA Secret Token',
                                  hintText: 'Enter or paste 2FA token',
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.security),
                                  suffixIcon: _twoFactorSecret != null
                                      ? IconButton(
                                          icon: const Icon(Icons.copy),
                                          tooltip: 'Copy token',
                                          onPressed: _copySecretToken,
                                        )
                                      : null,
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                ),
                                readOnly: _twoFactorSecret != null,
                                keyboardType: TextInputType.text,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'monospace',
                                  letterSpacing: 1.5,
                                  color: Colors.blue[700],
                                ),
                              ),
                              if (_twoFactorSecret != null) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 16,
                                      color: Colors.blue[700],
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        'Copy the token above and paste it in your authenticator app (or scan the QR code). Then enter the 6-digit code generated by the app below.',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 16),
                              Text(
                                'Enter 6-digit code from your authenticator app:',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _twoFactorVerificationController,
                                decoration: const InputDecoration(
                                  labelText: 'Enter 6-digit 2FA Token',
                                  hintText: '123456',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.lock),
                                ),
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  letterSpacing: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          _qrCodeData = null;
                                          _twoFactorSecret = null;
                                          _twoFactorTokenController.clear();
                                          _twoFactorVerificationController
                                              .clear();
                                        });
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _isVerifying2FA
                                          ? null
                                          : _verify2FA,
                                      child: _isVerifying2FA
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Text('Verify & Enable'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String title,
    AppThemeMode mode,
    AppThemeMode selectedMode,
    IconData icon,
    VoidCallback onTap,
  ) {
    final isSelected = mode == selectedMode;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[600],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRCodeImage(String qrCodeData) {
    try {
      // Handle base64 data URL: "data:image/png;base64,..."
      String base64String = qrCodeData;
      if (qrCodeData.contains(',')) {
        base64String = qrCodeData.split(',')[1];
      }

      final bytes = base64Decode(base64String);
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Image.memory(
          Uint8List.fromList(bytes),
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      );
    } catch (e) {
      return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Failed to load QR code',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }
  }
}
