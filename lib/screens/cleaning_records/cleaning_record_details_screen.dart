import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/cleaning_record.dart';
import '../../services/cleaning_record_service.dart';
import '../../services/pdf_receipt_service.dart';
import '../../services/whatsapp_receipt_service.dart';
import '../../utils/date_formatter.dart';
import '../../l10n/app_localizations.dart';

class CleaningRecordDetailsScreen extends StatefulWidget {
  final int recordId;

  const CleaningRecordDetailsScreen({super.key, required this.recordId});

  @override
  State<CleaningRecordDetailsScreen> createState() =>
      _CleaningRecordDetailsScreenState();
}

class _CleaningRecordDetailsScreenState
    extends State<CleaningRecordDetailsScreen> {
  CleaningRecord? _record;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRecord();
  }

  Future<void> _loadRecord() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final response = await CleaningRecordService.getCleaningRecordById(
      widget.recordId,
    );

    if (response.success && response.data != null) {
      setState(() {
        _record = response.data;
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = response.message ?? 'Failed to load record';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteRecord() async {
    final localizations = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.deleteCleaningRecordTitle),
        content: Text(localizations.deleteCleaningRecordMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(localizations.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(localizations.commonDelete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final response = await CleaningRecordService.deleteCleaningRecord(
        widget.recordId,
      );
      if (response.success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.cleaningRecordDeleted)),
        );
        context.pop(true);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.message ?? localizations.cleaningRecordDeleteFailed,
            ),
          ),
        );
      }
    }
  }

  Future<void> _downloadReceipt() async {
    if (_record == null) return;

    final localizations = AppLocalizations.of(context)!;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.receiptGenerating),
          duration: const Duration(seconds: 2),
        ),
      );

      await PdfReceiptService.generateAndDownloadReceipt(
        _record!,
        localizations,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.receiptGenerated),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${localizations.receiptGenerationFailed}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _shareToChairman() async {
    if (_record == null || _record!.tank?.society == null) return;

    final localizations = AppLocalizations.of(context)!;
    final society = _record!.tank!.society!;

    if (society.chairmanPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chairman phone number not available'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sharing receipt to Chairman...'),
          duration: const Duration(seconds: 2),
        ),
      );

      await WhatsAppReceiptService.shareReceiptViaWhatsApp(
        record: _record!,
        phoneNumber: society.chairmanPhone,
        recipientName: society.chairmanName.isNotEmpty
            ? society.chairmanName
            : 'Chairman',
        localizations: localizations,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Receipt shared to Chairman via WhatsApp'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share via WhatsApp: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _shareToSecretary() async {
    if (_record == null || _record!.tank?.society == null) return;

    final localizations = AppLocalizations.of(context)!;
    final society = _record!.tank!.society!;

    if (society.secretaryPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Secretary phone number not available'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sharing receipt to Secretary...'),
          duration: const Duration(seconds: 2),
        ),
      );

      await WhatsAppReceiptService.shareReceiptViaWhatsApp(
        record: _record!,
        phoneNumber: society.secretaryPhone,
        recipientName: society.secretaryName.isNotEmpty
            ? society.secretaryName
            : 'Secretary',
        localizations: localizations,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Receipt shared to Secretary via WhatsApp'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share via WhatsApp: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.cleaningRecordDetailsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (_record != null)
            IconButton(
              icon: const Icon(Icons.download),
              tooltip: localizations.buttonDownloadReceipt,
              onPressed: _downloadReceipt,
            ),
          if (_record != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final result = await context.push(
                  '/cleaning-records/${_record!.id}/edit',
                );
                if (result == true) {
                  _loadRecord();
                }
              },
            ),
          if (_record != null)
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              onPressed: _deleteRecord,
            ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_error!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadRecord,
                      child: Text(localizations.commonRetry),
                    ),
                  ],
                ),
              )
            : _record == null
            ? Center(child: Text(localizations.cleaningRecordDetailsNotFound))
            : RefreshIndicator(
                onRefresh: _loadRecord,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_record!.tank?.society != null)
                            TextButton(
                              onPressed: () => context.push(
                                '/societies/${_record!.tank!.society!.id}',
                              ),
                              child: Text(
                                _record!.tank!.society!.name,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          if (_record!.tank != null)
                            TextButton(
                              onPressed: () =>
                                  context.push('/tanks/${_record!.tank!.id}'),
                              child: Text(
                                _record!.tank!.location,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          const Divider(),
                          _buildInfoRow(
                            localizations.infoDateCleaned,
                            DateFormatter.formatDate(
                              _record!.dateOfTankCleaned,
                            ),
                          ),
                          _buildInfoRow(
                            localizations.infoNextExpectedDate,
                            DateFormatter.formatDate(
                              _record!.nextExpectedDateOfTankCleaning,
                            ),
                          ),
                          _buildInfoRow(
                            localizations.infoPaymentStatus,
                            _getPaymentStatusText(
                              _record!.paymentStatus,
                              localizations,
                            ),
                          ),
                          if (_record!.paymentModeString != null)
                            _buildInfoRow(
                              localizations.infoPaymentMode,
                              _getPaymentModeText(
                                _record!.paymentModeString!,
                                localizations,
                              ),
                            ),
                          if (_record!.paymentModeString == 'upi' &&
                              (_record!.transactionId?.isNotEmpty ?? false))
                            _buildInfoRow(
                              localizations.cleaningRecordTransactionIdLabel,
                              _record!.transactionId!,
                            ),
                          if (_record!.paymentModeString == 'cheque') ...[
                            if (_record!.chequeNumber?.isNotEmpty ?? false)
                              _buildInfoRow(
                                localizations.cleaningRecordChequeNumberLabel,
                                _record!.chequeNumber!,
                              ),
                            if (_record!.chequeBankName?.isNotEmpty ?? false)
                              _buildInfoRow(
                                localizations.cleaningRecordChequeBankLabel,
                                _record!.chequeBankName!,
                              ),
                            if (_record!.chequeDate != null)
                              _buildInfoRow(
                                localizations.cleaningRecordChequeDateLabel,
                                DateFormatter.formatDate(_record!.chequeDate),
                              ),
                          ],
                          _buildInfoRow(
                            localizations.infoTotalAmount,
                            '₹${_record!.totalAmount.toStringAsFixed(2)}',
                          ),
                          _buildInfoRow(
                            localizations.infoAmountDue,
                            '₹${_record!.amountDue.toStringAsFixed(2)}',
                            color: _record!.amountDue > 0
                                ? Colors.red
                                : Colors.green,
                          ),
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 16),
                          // WhatsApp Share Section
                          if (_record!.tank?.society != null &&
                              (_record!
                                      .tank!
                                      .society!
                                      .chairmanPhone
                                      .isNotEmpty ||
                                  _record!
                                      .tank!
                                      .society!
                                      .secretaryPhone
                                      .isNotEmpty)) ...[
                            Text(
                              'Share Receipt via WhatsApp:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                if (_record!
                                    .tank!
                                    .society!
                                    .chairmanPhone
                                    .isNotEmpty)
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => _shareToChairman(),
                                      icon: const Icon(
                                        Icons.chat,
                                        color: Colors.green,
                                      ),
                                      label: Text(
                                        'Chairman',
                                        style: TextStyle(
                                          color: Colors.green[700],
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        side: BorderSide(
                                          color: Colors.green[700]!,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (_record!
                                        .tank!
                                        .society!
                                        .chairmanPhone
                                        .isNotEmpty &&
                                    _record!
                                        .tank!
                                        .society!
                                        .secretaryPhone
                                        .isNotEmpty)
                                  const SizedBox(width: 12),
                                if (_record!
                                    .tank!
                                    .society!
                                    .secretaryPhone
                                    .isNotEmpty)
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => _shareToSecretary(),
                                      icon: const Icon(
                                        Icons.chat,
                                        color: Colors.green,
                                      ),
                                      label: Text(
                                        'Secretary',
                                        style: TextStyle(
                                          color: Colors.green[700],
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        side: BorderSide(
                                          color: Colors.green[700]!,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _downloadReceipt,
                                  icon: const Icon(Icons.download),
                                  label: Text(
                                    localizations.buttonDownloadReceipt,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final result = await context.push(
                                      '/cleaning-records/${_record!.id}/edit',
                                    );
                                    if (result == true) {
                                      _loadRecord();
                                    }
                                  },
                                  icon: const Icon(Icons.edit),
                                  label: Text(localizations.buttonEditRecord),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _deleteRecord,
                                  icon: const Icon(Icons.delete),
                                  label: Text(localizations.buttonDeleteRecord),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: color)),
          ),
        ],
      ),
    );
  }

  String _getPaymentStatusText(
    PaymentStatus status,
    AppLocalizations localizations,
  ) {
    switch (status) {
      case PaymentStatus.paid:
        return localizations.paymentStatusPaid.toUpperCase();
      case PaymentStatus.unpaid:
        return localizations.paymentStatusUnpaid.toUpperCase();
      case PaymentStatus.partial:
        return localizations.paymentStatusPartial.toUpperCase();
    }
  }

  String _getPaymentModeText(String mode, AppLocalizations localizations) {
    switch (mode.toLowerCase()) {
      case 'cash':
        return localizations.paymentModeCash.toUpperCase();
      case 'online':
        return localizations.paymentModeOnline.toUpperCase();
      case 'cheque':
        return localizations.paymentModeCheque.toUpperCase();
      case 'upi':
        return localizations.paymentModeUpi.toUpperCase();
      case 'card':
        return localizations.paymentModeCard.toUpperCase();
      default:
        return mode.toUpperCase();
    }
  }
}
