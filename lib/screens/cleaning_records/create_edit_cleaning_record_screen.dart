import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jsr_app/l10n/app_localizations.dart';
import '../../models/cleaning_record.dart';
import '../../services/cleaning_record_service.dart';
import '../../services/tank_service.dart';
import '../../services/whatsapp_receipt_service.dart';
import '../../services/notification_service.dart';
import '../../models/tank.dart';
import '../../utils/date_formatter.dart';
import '../../utils/platform_utils.dart';

class CreateEditCleaningRecordScreen extends StatefulWidget {
  final int? recordId;

  const CreateEditCleaningRecordScreen({super.key, this.recordId});

  @override
  State<CreateEditCleaningRecordScreen> createState() =>
      _CreateEditCleaningRecordScreenState();
}

class _CreateEditCleaningRecordScreenState
    extends State<CreateEditCleaningRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isEditMode = false;
  CleaningRecord? _existingRecord;
  List<Tank> _tanks = [];
  int? _selectedTankId;
  DateTime? _dateCleaned;
  DateTime? _nextExpectedDate;
  PaymentStatus _paymentStatus = PaymentStatus.unpaid;
  PaymentMode? _paymentMode;
  final _totalAmountController = TextEditingController();
  final _amountDueController = TextEditingController();
  final _transactionIdController = TextEditingController();
  final _chequeNumberController = TextEditingController();
  final _chequeBankNameController = TextEditingController();
  final _chequeDateController = TextEditingController();
  DateTime? _chequeDate;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.recordId != null;
    _loadTanks();
    if (_isEditMode) {
      _loadRecord();
    }
  }

  @override
  void dispose() {
    _totalAmountController.dispose();
    _amountDueController.dispose();
    _transactionIdController.dispose();
    _chequeNumberController.dispose();
    _chequeBankNameController.dispose();
    _chequeDateController.dispose();
    super.dispose();
  }

  Future<void> _loadTanks() async {
    final response = await TankService.getAllTanks(limit: 1000);
    if (response.success && response.data != null) {
      setState(() {
        _tanks = response.data!;
      });
    }
  }

  Future<void> _loadRecord() async {
    setState(() => _isLoading = true);

    final response = await CleaningRecordService.getCleaningRecordById(
      widget.recordId!,
    );

    if (response.success && response.data != null) {
      _existingRecord = response.data;
      _selectedTankId = _existingRecord!.tankId;
      _dateCleaned = _existingRecord!.dateOfTankCleaned;
      _nextExpectedDate = _existingRecord!.nextExpectedDateOfTankCleaning;
      _paymentStatus = _existingRecord!.paymentStatus;
      _paymentMode = _existingRecord!.paymentMode;
      _totalAmountController.text = _existingRecord!.totalAmount.toString();
      _amountDueController.text = _existingRecord!.amountDue.toString();
      _transactionIdController.text =
          _existingRecord!.transactionId?.toString() ?? '';
      _chequeNumberController.text =
          _existingRecord!.chequeNumber?.toString() ?? '';
      _chequeBankNameController.text =
          _existingRecord!.chequeBankName?.toString() ?? '';
      if (_existingRecord!.chequeDate != null) {
        _chequeDate = _existingRecord!.chequeDate;
        _chequeDateController.text = DateFormatter.formatDate(
          _existingRecord!.chequeDate,
        );
      }
    }

    setState(() => _isLoading = false);
  }

  void _updateAmountDue() {
    if (_paymentStatus == PaymentStatus.paid) {
      _amountDueController.text = '0';
    } else if (_paymentStatus == PaymentStatus.unpaid) {
      final total = double.tryParse(_totalAmountController.text) ?? 0;
      _amountDueController.text = total.toString();
    }
  }

  void _calculateNextExpectedDate() {
    if (_selectedTankId != null && _dateCleaned != null) {
      try {
        final selectedTank = _tanks.firstWhere(
          (tank) => tank.id == _selectedTankId,
        );

        setState(() {
          _nextExpectedDate = _dateCleaned!.add(
            Duration(days: selectedTank.frequencyOfCleaning),
          );
        });
      } catch (e) {
        // Tank not found in list, skip auto-calculation
      }
    }
  }

  void _handlePaymentModeChange(PaymentMode? value) {
    setState(() {
      _paymentMode = value;
      if (value != PaymentMode.upi) {
        _transactionIdController.clear();
      }
      if (value != PaymentMode.cheque) {
        _chequeNumberController.clear();
        _chequeBankNameController.clear();
        _chequeDate = null;
        _chequeDateController.clear();
      }
    });
  }

  Future<void> _saveRecord() async {
    final localizations = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTankId == null ||
        _dateCleaned == null ||
        _nextExpectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(localizations.commonRequired)));
      return;
    }

    setState(() => _isLoading = true);

    final totalAmount = double.parse(_totalAmountController.text);
    final amountDue = double.parse(_amountDueController.text);
    final transactionId =
        _paymentMode == PaymentMode.upi &&
            _transactionIdController.text.trim().isNotEmpty
        ? _transactionIdController.text.trim()
        : null;
    final chequeNumber = _paymentMode == PaymentMode.cheque
        ? _chequeNumberController.text.trim()
        : null;
    final chequeBankName = _paymentMode == PaymentMode.cheque
        ? _chequeBankNameController.text.trim()
        : null;
    final chequeDateString =
        _paymentMode == PaymentMode.cheque && _chequeDate != null
        ? _chequeDate!.toIso8601String().split('T')[0]
        : null;

    if (_isEditMode) {
      final updates = {
        'tankId': _selectedTankId,
        'dateOfTankCleaned': _dateCleaned!.toIso8601String().split('T')[0],
        'nextExpectedDateOfTankCleaning': _nextExpectedDate!
            .toIso8601String()
            .split('T')[0],
        'paymentStatus': _paymentStatus == PaymentStatus.paid
            ? 'paid'
            : _paymentStatus == PaymentStatus.partial
            ? 'partial'
            : 'unpaid',
        'paymentMode': _paymentMode?.toString().split('.').last,
        'totalAmount': totalAmount,
        'amountDue': amountDue,
        'transactionId': transactionId,
        'chequeNumber': chequeNumber,
        'chequeBankName': chequeBankName,
        'chequeDate': chequeDateString,
      };

      final response = await CleaningRecordService.updateCleaningRecord(
        widget.recordId!,
        updates,
      );

      if (response.success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.cleaningRecordUpdateSuccess)),
        );
        context.pop(true);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.message ?? localizations.cleaningRecordUpdateFailed,
            ),
          ),
        );
      }
    } else {
      final record = CleaningRecord(
        id: 0,
        tankId: _selectedTankId!,
        dateOfTankCleaned: _dateCleaned!,
        nextExpectedDateOfTankCleaning: _nextExpectedDate!,
        paymentStatus: _paymentStatus,
        paymentMode: _paymentMode,
        totalAmount: totalAmount,
        amountDue: amountDue,
        transactionId: transactionId,
        chequeNumber: chequeNumber,
        chequeBankName: chequeBankName,
        chequeDate: _paymentMode == PaymentMode.cheque ? _chequeDate : null,
      );

      final response = await CleaningRecordService.createCleaningRecord(record);

      if (response.success && mounted) {
        // Show success message immediately
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.cleaningRecordCreateSuccess)),
        );

        // Load the created record to get full details including society info
        if (response.data != null) {
          final createdRecord = response.data!;

          // Get the selected tank to access society info
          Tank? selectedTank;
          try {
            selectedTank = _tanks.firstWhere((t) => t.id == _selectedTankId);
          } catch (e) {
            // Tank not found in list
          }

          // Send email notification in background (non-blocking)
          if (selectedTank != null &&
              selectedTank.society != null &&
              (selectedTank.society!.chairmanEmail.isNotEmpty ||
                  selectedTank.society!.secretaryEmail.isNotEmpty)) {
            // Send notification asynchronously without blocking UI
            NotificationService.sendCleaningRecordNotification(createdRecord.id)
                .then((_) {
                  // Notification sent successfully (handled silently)
                })
                .catchError((e) {
                  // Email notification failure is handled silently in background
                  // User already sees success message, so no need to show error
                  if (mounted) {
                    debugPrint('Failed to send email notification: $e');
                  }
                });
          }

          // Show dialog to share via WhatsApp if society info is available
          if (selectedTank != null &&
              selectedTank.society != null &&
              (selectedTank.society!.chairmanPhone.isNotEmpty ||
                  selectedTank.society!.secretaryPhone.isNotEmpty)) {
            // Create a record with full tank and society info for sharing
            final recordWithSociety = CleaningRecord(
              id: createdRecord.id,
              tankId: createdRecord.tankId,
              dateOfTankCleaned: createdRecord.dateOfTankCleaned,
              nextExpectedDateOfTankCleaning:
                  createdRecord.nextExpectedDateOfTankCleaning,
              paymentStatus: createdRecord.paymentStatus,
              paymentMode: createdRecord.paymentMode,
              totalAmount: createdRecord.totalAmount,
              amountDue: createdRecord.amountDue,
              transactionId: createdRecord.transactionId,
              chequeNumber: createdRecord.chequeNumber,
              chequeBankName: createdRecord.chequeBankName,
              chequeDate: createdRecord.chequeDate,
              tank: selectedTank, // Include tank with society info
            );

            _showWhatsAppShareDialog(context, recordWithSociety, localizations);
          } else {
            context.pop(true);
          }
        } else {
          context.pop(true);
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.message ?? localizations.cleaningRecordCreateFailed,
            ),
          ),
        );
      }
    }

    setState(() => _isLoading = false);
  }

  void _showWhatsAppShareDialog(
    BuildContext context,
    CleaningRecord record,
    AppLocalizations localizations,
  ) {
    final society = record.tank?.society;
    if (society == null) {
      context.pop(true);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Receipt via WhatsApp'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Would you like to share the receipt with Chairman and Secretary?',
            ),
            const SizedBox(height: 16),
            if (society.chairmanPhone.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.person, color: Colors.blue),
                title: Text('Chairman: ${society.chairmanName}'),
                subtitle: Text(society.chairmanPhone),
              ),
            if (society.secretaryPhone.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.person, color: Colors.green),
                title: Text('Secretary: ${society.secretaryName}'),
                subtitle: Text(society.secretaryPhone),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop(true);
            },
            child: const Text('Skip'),
          ),
          if (society.chairmanPhone.isNotEmpty)
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                await _shareToChairman(record, society, localizations);
                if (mounted) {
                  context.pop(true);
                }
              },
              icon: const Icon(Icons.chat, color: Colors.green),
              label: const Text('Share to Chairman'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[50],
                foregroundColor: Colors.green[700],
              ),
            ),
          if (society.secretaryPhone.isNotEmpty)
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                await _shareToSecretary(record, society, localizations);
                if (mounted) {
                  context.pop(true);
                }
              },
              icon: const Icon(Icons.chat, color: Colors.green),
              label: const Text('Share to Secretary'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[50],
                foregroundColor: Colors.green[700],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _shareToChairman(
    CleaningRecord record,
    dynamic society,
    AppLocalizations localizations,
  ) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sharing receipt to Chairman via WhatsApp...'),
          duration: Duration(seconds: 2),
        ),
      );

      await WhatsAppReceiptService.shareReceiptViaWhatsApp(
        record: record,
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

  Future<void> _shareToSecretary(
    CleaningRecord record,
    dynamic society,
    AppLocalizations localizations,
  ) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sharing receipt to Secretary via WhatsApp...'),
          duration: Duration(seconds: 2),
        ),
      );

      await WhatsAppReceiptService.shareReceiptViaWhatsApp(
        record: record,
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
        title: Text(
          _isEditMode
              ? localizations.cleaningRecordEditTitle
              : localizations.cleaningRecordCreateTitle,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: _isLoading && _isEditMode
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      DropdownButtonFormField<int>(
                        initialValue: _selectedTankId,
                        decoration: InputDecoration(
                          labelText: localizations.cleaningRecordTankLabel,
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        isExpanded: true,
                        selectedItemBuilder: (BuildContext context) {
                          return _tanks.map((tank) {
                            return Text(
                              '${tank.society?.name ?? localizations.commonUnknown} - ${tank.location}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 16),
                            );
                          }).toList();
                        },
                        items: _tanks.map((tank) {
                          return DropdownMenuItem<int>(
                            value: tank.id,
                            child: Text(
                              '${tank.society?.name ?? localizations.commonUnknown} - ${tank.location}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTankId = value;
                          });
                          // Auto-calculate next expected date if date cleaned is already set
                          if (_dateCleaned != null) {
                            _calculateNextExpectedDate();
                          }
                        },
                        validator: (value) => value == null
                            ? localizations.validationSelectTank
                            : null,
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        title: Text(
                          _dateCleaned == null
                              ? localizations.cleaningRecordDateCleanedLabel
                              : DateFormatter.formatDate(_dateCleaned),
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final picked =
                              await PlatformUtils.showAdaptiveDatePicker(
                                context: context,
                                initialDate: _dateCleaned ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );
                          if (picked != null) {
                            setState(() {
                              _dateCleaned = picked;
                            });
                            // Auto-calculate next expected date if tank is already selected
                            if (_selectedTankId != null) {
                              _calculateNextExpectedDate();
                            }
                          }
                        },
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        title: Text(
                          _nextExpectedDate == null
                              ? localizations.cleaningRecordNextExpectedLabel
                              : DateFormatter.formatDate(_nextExpectedDate),
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final picked =
                              await PlatformUtils.showAdaptiveDatePicker(
                                context: context,
                                initialDate:
                                    _nextExpectedDate ??
                                    (_dateCleaned ?? DateTime.now()).add(
                                      const Duration(days: 90),
                                    ),
                                firstDate: _dateCleaned ?? DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                          if (picked != null) {
                            setState(() {
                              _nextExpectedDate = picked;
                            });
                          }
                        },
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<PaymentStatus>(
                        initialValue: _paymentStatus,
                        decoration: InputDecoration(
                          labelText:
                              localizations.cleaningRecordPaymentStatusLabel,
                          border: const OutlineInputBorder(),
                        ),
                        items: PaymentStatus.values.map((status) {
                          return DropdownMenuItem<PaymentStatus>(
                            value: status,
                            child: Text(
                              _mapPaymentStatusLabel(status, localizations),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _paymentStatus = value!;
                            _updateAmountDue();
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<PaymentMode?>(
                        initialValue: _paymentMode,
                        decoration: InputDecoration(
                          labelText:
                              localizations.cleaningRecordPaymentModeLabel,
                          border: const OutlineInputBorder(),
                        ),
                        items: [
                          DropdownMenuItem<PaymentMode?>(
                            value: null,
                            child: Text(localizations.commonNone),
                          ),
                          ...PaymentMode.values.map((mode) {
                            return DropdownMenuItem<PaymentMode?>(
                              value: mode,
                              child: Text(
                                _mapPaymentModeLabel(mode, localizations),
                              ),
                            );
                          }),
                        ],
                        onChanged: _handlePaymentModeChange,
                      ),
                      if (_paymentMode == PaymentMode.upi) ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _transactionIdController,
                          decoration: InputDecoration(
                            labelText:
                                localizations.cleaningRecordTransactionIdLabel,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ],
                      if (_paymentMode == PaymentMode.cheque) ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _chequeNumberController,
                          decoration: InputDecoration(
                            labelText:
                                localizations.cleaningRecordChequeNumberLabel,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (_paymentMode == PaymentMode.cheque &&
                                (value?.isEmpty ?? true)) {
                              return localizations.commonRequired;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _chequeBankNameController,
                          decoration: InputDecoration(
                            labelText:
                                localizations.cleaningRecordChequeBankLabel,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (_paymentMode == PaymentMode.cheque &&
                                (value?.isEmpty ?? true)) {
                              return localizations.commonRequired;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _chequeDateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText:
                                localizations.cleaningRecordChequeDateLabel,
                            border: const OutlineInputBorder(),
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                          onTap: () async {
                            final picked =
                                await PlatformUtils.showAdaptiveDatePicker(
                                  context: context,
                                  initialDate: _chequeDate ?? DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                            if (picked != null) {
                              setState(() {
                                _chequeDate = picked;
                                _chequeDateController.text =
                                    DateFormatter.formatDate(picked);
                              });
                            }
                          },
                          validator: (value) {
                            if (_paymentMode == PaymentMode.cheque &&
                                (value?.isEmpty ?? true)) {
                              return localizations.commonRequired;
                            }
                            return null;
                          },
                        ),
                      ],
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _totalAmountController,
                        decoration: InputDecoration(
                          labelText:
                              localizations.cleaningRecordTotalAmountLabel,
                          prefixText: 'RS. ',
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return localizations.commonRequired;
                          }
                          final num = double.tryParse(value!);
                          if (num == null || num < 0) {
                            return localizations.commonPositiveNumber;
                          }
                          return null;
                        },
                        onChanged: (_) => _updateAmountDue(),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _amountDueController,
                        decoration: InputDecoration(
                          labelText: localizations.cleaningRecordAmountDueLabel,
                          prefixText: 'RS. ',
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return localizations.commonRequired;
                          }
                          final num = double.tryParse(value!);
                          if (num == null || num < 0) {
                            return localizations.commonPositiveNumber;
                          }
                          final total =
                              double.tryParse(_totalAmountController.text) ?? 0;
                          if (num > total) {
                            return localizations.validationAmountExceeds;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: PlatformUtils.adaptiveButton(
                          context: context,
                          onPressed: _isLoading ? null : _saveRecord,
                          child: _isLoading
                              ? PlatformUtils.adaptiveLoadingIndicator()
                              : Text(
                                  _isEditMode
                                      ? localizations.buttonUpdateRecord
                                      : localizations.buttonCreateRecord,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  String _mapPaymentStatusLabel(
    PaymentStatus status,
    AppLocalizations localizations,
  ) {
    switch (status) {
      case PaymentStatus.paid:
        return localizations.paymentStatusPaid;
      case PaymentStatus.partial:
        return localizations.paymentStatusPartial;
      case PaymentStatus.unpaid:
        return localizations.paymentStatusUnpaid;
    }
  }

  String _mapPaymentModeLabel(
    PaymentMode mode,
    AppLocalizations localizations,
  ) {
    switch (mode) {
      case PaymentMode.cash:
        return localizations.paymentModeCash;
      case PaymentMode.cheque:
        return localizations.paymentModeCheque;
      case PaymentMode.upi:
        return localizations.paymentModeUpi;
      case PaymentMode.card:
        return localizations.paymentModeCard;
    }
  }
}
