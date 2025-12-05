import 'package:flutter/foundation.dart' show kIsWeb;
import '../utils/file_utils_stub.dart'
    if (dart.library.io) '../utils/file_utils_io.dart'
    as file_utils;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/cleaning_record.dart';
import '../l10n/app_localizations.dart';

class PdfReceiptService {
  static Future<void> generateAndDownloadReceipt(
    CleaningRecord record,
    AppLocalizations localizations,
  ) async {
    try {
      // Generate PDF
      final pdf = await _generatePdf(record, localizations);
      final pdfBytes = await pdf.save();

      // Handle web platform - share directly
      if (kIsWeb) {
        final uint8List = Uint8List.fromList(pdfBytes);
        final fileName =
            'Receipt_${record.id}_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final xFile = XFile.fromData(
          uint8List,
          mimeType: 'application/pdf',
          name: fileName,
        );
        await Share.shareXFiles(
          [xFile],
          text:
              '${localizations.receiptTitle} - ${record.tank?.society?.name ?? "Cleaning Record"}',
          subject: localizations.receiptTitle,
        );
        return;
      }

      // Mobile platforms - use file system
      final fileName =
          'Receipt_${record.id}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final uint8List = Uint8List.fromList(pdfBytes);
      final filePath = await file_utils.FileUtils.saveFile(
        bytes: uint8List,
        fileName: fileName,
      );

      // Open the PDF file with default viewer (mobile only)
      final result = await OpenFile.open(filePath);

      // If opening failed, fall back to share dialog
      if (result.type != ResultType.done &&
          result.type != ResultType.noAppToOpen) {
        final xFile = XFile(filePath);
        await Share.shareXFiles(
          [xFile],
          text:
              '${localizations.receiptTitle} - ${record.tank?.society?.name ?? "Cleaning Record"}',
          subject: localizations.receiptTitle,
        );
      }
    } catch (e) {
      // If file operations fail, try sharing directly from memory
      try {
        final pdf = await _generatePdf(record, localizations);
        final pdfBytes = await pdf.save();
        final uint8List = Uint8List.fromList(pdfBytes);
        final fileName =
            'Receipt_${record.id}_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final xFile = XFile.fromData(
          uint8List,
          mimeType: 'application/pdf',
          name: fileName,
        );
        await Share.shareXFiles(
          [xFile],
          text:
              '${localizations.receiptTitle} - ${record.tank?.society?.name ?? "Cleaning Record"}',
          subject: localizations.receiptTitle,
        );
      } catch (shareError) {
        throw Exception(
          'Failed to generate receipt: $e. Share error: $shareError',
        );
      }
    }
  }

  static Future<pw.Document> _generatePdf(
    CleaningRecord record,
    AppLocalizations localizations,
  ) async {
    final baseFontData = await rootBundle.load(
      'assets/fonts/NotoSansDevanagari-Regular.ttf',
    );
    final boldFontData = await rootBundle.load(
      'assets/fonts/NotoSansDevanagari-Bold.ttf',
    );
    final latinFallbackData = await rootBundle.load(
      'assets/fonts/NotoSans-Regular.ttf',
    );
    final baseFont = pw.Font.ttf(baseFontData);
    final boldFont = pw.Font.ttf(boldFontData);
    final latinFont = pw.Font.ttf(latinFallbackData);
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: baseFont,
        bold: boldFont,
        fontFallback: [latinFont],
      ),
    );
    final dateFormat = DateFormat('dd/MM/yyyy');
    final dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');

    // Load logo if available
    ByteData? logoData;
    try {
      logoData = await rootBundle.load('assets/images/jsr_logo.jpg');
    } catch (e) {
      // Logo not found, continue without it
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            // Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                if (logoData != null)
                  pw.Image(
                    pw.MemoryImage(logoData.buffer.asUint8List()),
                    width: 80,
                    height: 80,
                    fit: pw.BoxFit.contain,
                  )
                else
                  pw.Text(
                    'JSR',
                    style: pw.TextStyle(
                      fontSize: 32,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      localizations.receiptTitle,
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      '${localizations.receiptNumber}: ${record.id}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.Text(
                      '${localizations.receiptDate}: ${dateTimeFormat.format(DateTime.now())}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 30),

            // Company/Service Info
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey700),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Jay Shri Ram Water Tank Cleaning Service & Plumbing Service',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Customer Information
            pw.Text(
              localizations.receiptCustomerInfo,
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (record.tank?.society != null) ...[
                    _buildInfoRow(
                      localizations.receiptSocietyName,
                      record.tank!.society!.name,
                    ),
                    _buildInfoRow(
                      localizations.receiptAddress,
                      record.tank!.society!.fullAddress,
                    ),
                    if (record.tank!.society!.city.isNotEmpty)
                      _buildInfoRow(
                        localizations.receiptCity,
                        '${record.tank!.society!.city}, ${record.tank!.society!.state} - ${record.tank!.society!.pincode}',
                      ),
                    if (record.tank!.society!.chairmanName.isNotEmpty)
                      _buildInfoRow(
                        localizations.receiptContactPerson,
                        record.tank!.society!.chairmanName,
                      ),
                    if (record.tank!.society!.chairmanPhone.isNotEmpty)
                      _buildInfoRow(
                        localizations.receiptPhone,
                        record.tank!.society!.chairmanPhone,
                      ),
                  ],
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Service Details
            pw.Text(
              localizations.receiptServiceDetails,
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey700),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (record.tank != null)
                    _buildInfoRow(
                      localizations.receiptTankLocation,
                      record.tank!.location,
                    ),
                  _buildInfoRow(
                    localizations.receiptCleaningDate,
                    dateFormat.format(record.dateOfTankCleaned),
                  ),
                  _buildInfoRow(
                    localizations.receiptNextCleaningDate,
                    dateFormat.format(record.nextExpectedDateOfTankCleaning),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Payment Information
            pw.Text(
              localizations.receiptPaymentInfo,
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey700),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    localizations.receiptPaymentStatus,
                    _getPaymentStatusText(record.paymentStatus, localizations),
                  ),
                  if (record.paymentModeString != null)
                    _buildInfoRow(
                      localizations.receiptPaymentMode,
                      _getPaymentModeText(
                        record.paymentModeString!,
                        localizations,
                      ),
                    ),
                  pw.Divider(),
                  _buildInfoRow(
                    localizations.receiptTotalAmount,
                    'Rs. ${record.totalAmount.toStringAsFixed(2)}',
                    isBold: true,
                    fontSize: 16,
                  ),
                  // Calculate received amount: Total Amount - Amount Due
                  _buildInfoRow(
                    localizations.receiptAmountReceived,
                    'Rs. ${(record.totalAmount - record.amountDue).toStringAsFixed(2)}',
                    color: PdfColors.green700,
                    isBold: true,
                  ),
                  if (record.amountDue > 0)
                    _buildInfoRow(
                      localizations.receiptAmountDue,
                      'Rs. ${record.amountDue.toStringAsFixed(2)}',
                      color: PdfColors.red700,
                      isBold: true,
                    ),
                ],
              ),
            ),
            pw.SizedBox(height: 30),

            // Footer
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Text(
              localizations.receiptThankYou,
              style: pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic),
              textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              localizations.receiptFooter,
              style: const pw.TextStyle(fontSize: 10),
              textAlign: pw.TextAlign.center,
            ),
          ];
        },
      ),
    );

    return pdf;
  }

  static pw.Widget _buildInfoRow(
    String label,
    String value, {
    bool isBold = false,
    double fontSize = 12,
    PdfColor? color,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(
                fontSize: fontSize,
                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: fontSize,
                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _getPaymentStatusText(
    PaymentStatus status,
    AppLocalizations localizations,
  ) {
    switch (status) {
      case PaymentStatus.paid:
        return localizations.paymentStatusPaid;
      case PaymentStatus.unpaid:
        return localizations.paymentStatusUnpaid;
      case PaymentStatus.partial:
        return localizations.paymentStatusPartial;
    }
  }

  static String _getPaymentModeText(
    String mode,
    AppLocalizations localizations,
  ) {
    switch (mode.toLowerCase()) {
      case 'cash':
        return localizations.paymentModeCash;
      case 'online':
        return localizations.paymentModeOnline;
      case 'cheque':
        return localizations.paymentModeCheque;
      case 'upi':
        return localizations.paymentModeUpi;
      case 'card':
        return localizations.paymentModeCard;
      default:
        return mode;
    }
  }
}
