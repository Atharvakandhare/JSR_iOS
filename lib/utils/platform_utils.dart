import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;

class PlatformUtils {
  static bool get isIOS {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.iOS;
  }

  static bool get isAndroid {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android;
  }

  static bool get isWeb => kIsWeb;

  /// Shows a platform-adaptive date picker
  static Future<DateTime?> showAdaptiveDatePicker({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? currentDate,
  }) async {
    if (isIOS) {
      return showCupertinoModalPopup<DateTime>(
        context: context,
        builder: (context) => _CupertinoDatePickerDialog(
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
          currentDate: currentDate,
        ),
      );
    } else {
      return showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        currentDate: currentDate,
      );
    }
  }

  /// Returns a platform-adaptive button
  static Widget adaptiveButton({
    required BuildContext context,
    required VoidCallback? onPressed,
    required Widget child,
    Color? backgroundColor,
    Color? foregroundColor,
    EdgeInsetsGeometry? padding,
  }) {
    if (isIOS) {
      return CupertinoButton(
        onPressed: onPressed,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
        color: backgroundColor ?? CupertinoColors.systemBlue,
        child: DefaultTextStyle(
          style: TextStyle(
            color: foregroundColor ?? CupertinoColors.white,
            fontWeight: FontWeight.w600,
          ),
          child: child,
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
        ),
        child: child,
      );
    }
  }

  /// Returns a platform-adaptive loading indicator
  static Widget adaptiveLoadingIndicator() {
    if (isIOS) {
      return const CupertinoActivityIndicator();
    } else {
      return const CircularProgressIndicator();
    }
  }
}

class _CupertinoDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? currentDate;

  const _CupertinoDatePickerDialog({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.currentDate,
  });

  @override
  State<_CupertinoDatePickerDialog> createState() =>
      _CupertinoDatePickerDialogState();
}

class _CupertinoDatePickerDialogState
    extends State<_CupertinoDatePickerDialog> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.only(top: 6.0),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 5.0,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 5.0,
                  ),
                  onPressed: () => Navigator.of(context).pop(selectedDate),
                  child: const Text('Done'),
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                initialDateTime: widget.initialDate,
                minimumDate: widget.firstDate,
                maximumDate: widget.lastDate,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    selectedDate = newDate;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
