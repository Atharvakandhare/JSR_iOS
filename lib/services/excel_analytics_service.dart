import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../utils/file_utils_stub.dart'
    if (dart.library.io) '../utils/file_utils_io.dart'
    as file_utils;
import 'package:excel/excel.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import '../models/analytics.dart';
import '../models/cleaning_record.dart';
import '../l10n/app_localizations.dart';
import '../utils/date_formatter.dart';

class ExcelAnalyticsService {
  static Future<void> generateAndDownloadAnalytics({
    required List<CleaningRecord> cleaningRecords,
    required List<RevenueAnalytics>? revenueAnalytics,
    required List<PaymentModeStat>? paymentModeStats,
    required String selectedPeriod,
    required int? selectedYear,
    required AppLocalizations localizations,
  }) async {
    try {
      // Create Excel workbook with a single consolidated sheet
      final excel = Excel.createExcel();
      excel.delete('Sheet1'); // Delete default sheet
      final consolidatedSheet = excel[localizations.analyticsTitle];
      _addConsolidatedSheet(
        sheet: consolidatedSheet,
        cleaningRecords: cleaningRecords,
        revenueAnalytics: revenueAnalytics,
        paymentModeStats: paymentModeStats,
        localizations: localizations,
      );

      // Save Excel file
      final excelBytes = excel.save();
      if (excelBytes == null) {
        throw Exception('Failed to generate Excel file');
      }

      // Handle web platform - share directly
      if (kIsWeb) {
        final uint8List = Uint8List.fromList(excelBytes);
        final periodLabel = _getPeriodLabel(selectedPeriod, selectedYear);
        final fileName =
            'Analytics_$periodLabel${DateTime.now().millisecondsSinceEpoch}.xlsx';
        final xFile = XFile.fromData(
          uint8List,
          mimeType:
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
          name: fileName,
        );
        await Share.shareXFiles([xFile]);
        return;
      }

      // Mobile platforms - use file system
      final periodLabel = _getPeriodLabel(selectedPeriod, selectedYear);
      final fileName =
          'Analytics_$periodLabel${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final uint8List = Uint8List.fromList(excelBytes);
      final filePath = await file_utils.FileUtils.saveFile(
        bytes: uint8List,
        fileName: fileName,
      );

      // Create XFile for sharing
      final xFile = XFile(
        filePath,
        mimeType:
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      );

      // Try to open the file first
      try {
        final result = await OpenFile.open(
          filePath,
          type:
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        );

        // If opening failed or no app found, show share dialog
        if (result.type != ResultType.done) {
          // Show share dialog so user can choose an app to open the file
          await Share.shareXFiles(
            [xFile],
            text: '${localizations.analyticsTitle} - $periodLabel',
            subject: localizations.analyticsTitle,
          );
        }
      } catch (openError) {
        // If open fails, try sharing from file path
        try {
          await Share.shareXFiles(
            [xFile],
            text: '${localizations.analyticsTitle} - $periodLabel',
            subject: localizations.analyticsTitle,
          );
        } catch (shareError) {
          // If file sharing fails, try sharing from memory
          try {
            final uint8List = Uint8List.fromList(excelBytes);
            final xFileFromMemory = XFile.fromData(
              uint8List,
              mimeType:
                  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
              name: fileName,
            );
            await Share.shareXFiles(
              [xFileFromMemory],
              text: '${localizations.analyticsTitle} - $periodLabel',
              subject: localizations.analyticsTitle,
            );
          } catch (memoryShareError) {
            throw Exception(
              'Failed to open or share Excel file: $openError. Share error: $shareError. Memory share error: $memoryShareError',
            );
          }
        }
      }
    } catch (e) {
      throw Exception('Failed to generate analytics Excel: $e');
    }
  }

  static void _addConsolidatedSheet({
    required Sheet sheet,
    required List<CleaningRecord> cleaningRecords,
    required List<RevenueAnalytics>? revenueAnalytics,
    required List<PaymentModeStat>? paymentModeStats,
    required AppLocalizations localizations,
  }) {
    final headers = [
      'Society Name',
      'Tank',
      'Cleanings Done',
      'Date of Cleaning',
      'Payment Mode',
      'Payment Received (₹)',
      'Payment Pending (₹)',
      'Date of Next Cleaning',
      'Year',
      'Revenue (₹)',
      'UPI Received Amount (₹)',
      'Cash Amount (₹)',
      'Cheque Amount (₹)',
      'Cheque Date',
      'Card Amount (₹)',
    ];
    sheet.appendRow(headers.map(TextCellValue.new).toList());
    _styleHeaderRow(sheet, headers.length, rowIndex: 0);

    final societyCleaningCounter = <String, int>{};
    final yearlySummary = <int, _YearlySummary>{};

    for (final record in cleaningRecords) {
      final societyName =
          record.tank?.society?.name ?? localizations.commonUnknown;
      final tankName = record.tank?.location ?? localizations.commonUnknown;
      final cleaningsDone = (societyCleaningCounter[societyName] ?? 0) + 1;
      societyCleaningCounter[societyName] = cleaningsDone;

      final paymentMode = (record.paymentModeString ?? 'N/A').toUpperCase();
      final paymentReceived =
          (record.totalAmount - record.amountDue).clamp(0, double.infinity)
              as double;
      final paymentPending =
          record.amountDue.clamp(0, double.infinity) as double;
      final cleaningDate = DateFormatter.formatDate(record.dateOfTankCleaned);
      final nextCleaningDate = DateFormatter.formatDate(
        record.nextExpectedDateOfTankCleaning,
      );
      final year = record.dateOfTankCleaned.year;

      final upiAmount = paymentMode == 'UPI' ? paymentReceived : 0.0;
      final cashAmount = paymentMode == 'CASH' ? paymentReceived : 0.0;
      final chequeAmount = paymentMode == 'CHEQUE' ? paymentReceived : 0.0;
      final cardAmount = paymentMode == 'CARD' ? paymentReceived : 0.0;
      final chequeDate = paymentMode == 'CHEQUE'
          ? DateFormatter.formatDate(record.chequeDate)
          : '';

      sheet.appendRow([
        TextCellValue(societyName),
        TextCellValue(tankName),
        IntCellValue(cleaningsDone),
        TextCellValue(cleaningDate),
        TextCellValue(paymentMode),
        DoubleCellValue(paymentReceived),
        DoubleCellValue(paymentPending),
        TextCellValue(nextCleaningDate),
        IntCellValue(year),
        DoubleCellValue(record.totalAmount),
        DoubleCellValue(upiAmount),
        DoubleCellValue(cashAmount),
        DoubleCellValue(chequeAmount),
        TextCellValue(chequeDate),
        DoubleCellValue(cardAmount),
      ]);

      final highlightSociety =
          record.paymentModeString == null ||
          record.paymentModeString!.isEmpty ||
          record.paymentModeString!.toLowerCase() == 'pending';
      if (highlightSociety) {
        final rowIndex = sheet.maxRows - 1;
        final cell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex),
        );
        cell.cellStyle = CellStyle(bold: true);
      }

      final summary = yearlySummary.putIfAbsent(
        year,
        () => _YearlySummary(year),
      );
      summary.revenue += record.totalAmount;
      summary.pending += paymentPending;
      summary.upi += upiAmount;
      summary.cash += cashAmount;
      summary.cheque += chequeAmount;
      summary.card += cardAmount;
      final rowIndex = sheet.maxRows - 1;

      // Center align Date of Cleaning column (column 3)
      final cleaningDateCell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex),
      );
      cleaningDateCell.cellStyle = CellStyle(
        horizontalAlign: HorizontalAlign.Center,
      );

      // Center align Date of Next Cleaning column (column 7)
      final nextCleaningCell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex),
      );
      nextCleaningCell.cellStyle = CellStyle(
        horizontalAlign: HorizontalAlign.Center,
      );
    }

    // Override revenue totals with analytics data if available
    if (revenueAnalytics != null) {
      for (final analytics in revenueAnalytics) {
        final year = _parseYearFromPeriod(analytics.period);
        if (year != null) {
          final summary = yearlySummary.putIfAbsent(
            year,
            () => _YearlySummary(year),
          );
          summary.revenue = analytics.totalRevenue;
          summary.pending = analytics.totalDue;
        }
      }
    }

    sheet.appendRow([]);
    final summaryHeaders = [
      'Year',
      'Revenue (₹)',
      'Pending Amount (₹)',
      'UPI Received Amount (₹)',
      'Cash Amount (₹)',
      'Cheque Amount (₹)',
      'Card Amount (₹)',
    ];
    sheet.appendRow(summaryHeaders.map(TextCellValue.new).toList());
    _styleHeaderRow(sheet, summaryHeaders.length, rowIndex: sheet.maxRows - 1);

    final sortedYears = yearlySummary.keys.toList()..sort();
    for (final year in sortedYears) {
      final summary = yearlySummary[year]!;
      sheet.appendRow([
        IntCellValue(year),
        DoubleCellValue(summary.revenue),
        DoubleCellValue(summary.pending),
        DoubleCellValue(summary.upi),
        DoubleCellValue(summary.cash),
        DoubleCellValue(summary.cheque),
        DoubleCellValue(summary.card),
      ]);
    }

    if (sortedYears.isEmpty && paymentModeStats != null) {
      double totalUpi = 0, totalCash = 0, totalCheque = 0, totalCard = 0;
      for (final stat in paymentModeStats) {
        switch ((stat.paymentMode ?? '').toLowerCase()) {
          case 'upi':
          case 'online':
            totalUpi += stat.totalAmount;
            break;
          case 'cash':
            totalCash += stat.totalAmount;
            break;
          case 'cheque':
            totalCheque += stat.totalAmount;
            break;
          case 'card':
            totalCard += stat.totalAmount;
            break;
        }
      }
      sheet.appendRow([
        TextCellValue('Overall'),
        DoubleCellValue(totalUpi + totalCash + totalCheque + totalCard),
        DoubleCellValue(0),
        DoubleCellValue(totalUpi),
        DoubleCellValue(totalCash),
        DoubleCellValue(totalCheque),
        DoubleCellValue(totalCard),
      ]);
    }

    for (var i = 0; i < headers.length; i++) {
      sheet.setColumnWidth(i, 22);
    }
  }

  static void _styleHeaderRow(
    Sheet sheet,
    int columnCount, {
    required int rowIndex,
  }) {
    for (var i = 0; i < columnCount; i++) {
      final cell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: i, rowIndex: rowIndex),
      );
      cell.cellStyle = CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.fromHexString('#E0E0E0'),
        horizontalAlign: HorizontalAlign.Center,
      );
    }
  }

  static int? _parseYearFromPeriod(String period) {
    final parts = period.split('-');
    if (parts.isEmpty) return null;
    return int.tryParse(parts.first);
  }

  static String _getPeriodLabel(String period, int? year) {
    final yearLabel = year != null ? '_$year' : '';
    return '$period$yearLabel';
  }
}

class _YearlySummary {
  _YearlySummary(this.year);

  final int year;
  double revenue = 0;
  double pending = 0;
  double upi = 0;
  double cash = 0;
  double cheque = 0;
  double card = 0;
}
