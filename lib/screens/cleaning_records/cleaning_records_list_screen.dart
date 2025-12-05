import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jsr_app/l10n/app_localizations.dart';
import '../../models/cleaning_record.dart';
import '../../services/cleaning_record_service.dart';
import '../../services/pdf_receipt_service.dart';
import '../../services/whatsapp_receipt_service.dart';
import '../../services/tank_service.dart';
import '../../services/society_service.dart';
import '../../models/tank.dart';
import '../../models/society.dart';
import '../../widgets/app_drawer.dart';
import '../../utils/date_formatter.dart';

class CleaningRecordsListScreen extends StatefulWidget {
  const CleaningRecordsListScreen({super.key});

  @override
  State<CleaningRecordsListScreen> createState() =>
      _CleaningRecordsListScreenState();
}

class _CleaningRecordsListScreenState extends State<CleaningRecordsListScreen> {
  List<CleaningRecord> _records = [];
  List<Tank> _tanks = [];
  List<Society> _societies = [];
  bool _isLoading = true;
  String? _error;
  int _currentPage = 1;
  int _totalPages = 1;
  int? _selectedTankId;
  int? _selectedSocietyId;
  String? _selectedPaymentStatus;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _loadTanks();
    _loadSocieties();
    _loadRecords();
  }

  Future<void> _loadTanks() async {
    final response = await TankService.getAllTanks(limit: 1000);
    if (response.success && response.data != null) {
      setState(() {
        _tanks = response.data!;
      });
    }
  }

  Future<void> _loadSocieties() async {
    final response = await SocietyService.getAllSocieties(limit: 1000);
    if (response.success && response.data != null) {
      setState(() {
        _societies = response.data!;
      });
    }
  }

  Future<void> _loadRecords({bool resetPage = false}) async {
    if (resetPage) _currentPage = 1;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final serverPaymentStatus = _selectedPaymentStatus == 'partial'
        ? null
        : _selectedPaymentStatus;

    final response = await CleaningRecordService.getAllCleaningRecords(
      page: _currentPage,
      limit: 10,
      tankId: _selectedTankId,
      societyId: _selectedSocietyId,
      paymentStatus: serverPaymentStatus,
      startDate: _startDate?.toIso8601String().split('T')[0],
      endDate: _endDate?.toIso8601String().split('T')[0],
    );

    if (response.success && response.data != null) {
      setState(() {
        _records = response.data!;
        _totalPages = response.pagination?.pages ?? 1;
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = response.message;
        _isLoading = false;
      });
    }
  }

  // Delete functionality can be added to individual record details screen

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? _startDate ?? DateTime.now()
          : _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
      _loadRecords(resetPage: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.cleaningRecordsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await context.push('/cleaning-records/new');
              if (result == true) {
                _loadRecords(resetPage: true);
              }
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int?>(
                        initialValue: _selectedSocietyId,
                        decoration: InputDecoration(
                          labelText: localizations.filterSocietyLabel,
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          isDense: true,
                        ),
                        isExpanded: true,
                        selectedItemBuilder: (BuildContext context) {
                          return [
                            Text(
                              localizations.commonAll,
                              overflow: TextOverflow.ellipsis,
                            ),
                            ..._societies.map(
                              (s) =>
                                  Text(s.name, overflow: TextOverflow.ellipsis),
                            ),
                          ];
                        },
                        items: [
                          DropdownMenuItem<int?>(
                            value: null,
                            child: Text(
                              localizations.commonAll,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          ..._societies.map(
                            (s) => DropdownMenuItem<int?>(
                              value: s.id,
                              child: Text(
                                s.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedSocietyId = value;
                            _selectedTankId = null;
                          });
                          _loadRecords(resetPage: true);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<int?>(
                        initialValue: _selectedTankId,
                        decoration: InputDecoration(
                          labelText: localizations.filterTankLabel,
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          isDense: true,
                        ),
                        isExpanded: true,
                        selectedItemBuilder: (BuildContext context) {
                          final filteredTanks = _tanks
                              .where(
                                (t) =>
                                    _selectedSocietyId == null ||
                                    t.societyId == _selectedSocietyId,
                              )
                              .toList();
                          return [
                            Text(
                              localizations.commonAll,
                              overflow: TextOverflow.ellipsis,
                            ),
                            ...filteredTanks.map(
                              (t) => Text(
                                t.location,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ];
                        },
                        items: [
                          DropdownMenuItem<int?>(
                            value: null,
                            child: Text(
                              localizations.commonAll,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          ..._tanks
                              .where(
                                (t) =>
                                    _selectedSocietyId == null ||
                                    t.societyId == _selectedSocietyId,
                              )
                              .map(
                                (t) => DropdownMenuItem<int?>(
                                  value: t.id,
                                  child: Text(
                                    t.location,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedTankId = value;
                          });
                          _loadRecords(resetPage: true);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        initialValue: _selectedPaymentStatus,
                        decoration: InputDecoration(
                          labelText:
                              localizations.cleaningRecordPaymentStatusLabel,
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          isDense: true,
                        ),
                        isExpanded: true,
                        selectedItemBuilder: (BuildContext context) {
                          return [
                            Text(
                              localizations.commonAll,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              localizations.paymentStatusPaid,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              localizations.paymentStatusUnpaid,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              localizations.paymentStatusPartial,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ];
                        },
                        items: [
                          DropdownMenuItem<String?>(
                            value: null,
                            child: Text(
                              localizations.commonAll,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DropdownMenuItem<String?>(
                            value: 'paid',
                            child: Text(
                              localizations.paymentStatusPaid,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DropdownMenuItem<String?>(
                            value: 'unpaid',
                            child: Text(
                              localizations.paymentStatusUnpaid,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DropdownMenuItem<String?>(
                            value: 'partial',
                            child: Text(
                              localizations.paymentStatusPartial,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentStatus = value;
                          });
                          _loadRecords(resetPage: true);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _selectDate(context, true),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_today, size: 18),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                _startDate == null
                                    ? localizations.filterStartDate
                                    : DateFormatter.formatDate(_startDate),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _selectDate(context, false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_today, size: 18),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                _endDate == null
                                    ? localizations.filterEndDate
                                    : DateFormatter.formatDate(_endDate),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            context.push('/cleaning-records/upcoming'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_today, size: 18),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                localizations.buttonUpcoming,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            context.push('/cleaning-records/overdue'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.warning, size: 18),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                localizations.buttonOverdue,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_error ?? localizations.cleaningRecordsLoadError),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _loadRecords(),
                          child: Text(localizations.commonRetry),
                        ),
                      ],
                    ),
                  )
                : () {
                    final visibleRecords = _records
                        .where(_matchesPaymentFilter)
                        .toList(growable: false);
                    if (visibleRecords.isEmpty) {
                      return Center(
                        child: Text(localizations.cleaningRecordsEmpty),
                      );
                    }
                    return ListView.builder(
                      itemCount: visibleRecords.length,
                      itemBuilder: (context, index) {
                        final record = visibleRecords[index];
                        final PaymentStatus displayStatus =
                            _resolveDisplayStatus(record);
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: InkWell(
                            onTap: () async {
                              final result = await context.push(
                                '/cleaning-records/${record.id}',
                              );
                              if (result == true) {
                                _loadRecords();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.blue[400],
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.business,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              record.tank?.society?.name ??
                                                  localizations.commonUnknown,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              record.tank?.location ??
                                                  localizations.commonUnknown,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              localizations
                                                  .cleaningRecordsDateLabel(
                                                    DateFormatter.formatDate(
                                                      record.dateOfTankCleaned,
                                                    ),
                                                  ),
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              localizations.commonAmountLabel(
                                                record.totalAmount
                                                    .toStringAsFixed(2),
                                              ),
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                            if (record.amountDue > 0) ...[
                                              const SizedBox(height: 4),
                                              Text(
                                                localizations.commonDueLabel(
                                                  record.amountDue
                                                      .toStringAsFixed(2),
                                                ),
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Chip(
                                            label: Text(
                                              _paymentStatusLabel(
                                                displayStatus,
                                                localizations,
                                              ),
                                              style: const TextStyle(
                                                fontSize: 11,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            backgroundColor:
                                                displayStatus ==
                                                    PaymentStatus.paid
                                                ? Colors.green
                                                : displayStatus ==
                                                      PaymentStatus.partial
                                                ? Colors.orange
                                                : Colors.red,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.download,
                                                  size: 20,
                                                ),
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                                onPressed: () async {
                                                  try {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          localizations
                                                              .receiptGenerating,
                                                        ),
                                                        duration:
                                                            const Duration(
                                                              seconds: 2,
                                                            ),
                                                      ),
                                                    );
                                                    await PdfReceiptService.generateAndDownloadReceipt(
                                                      record,
                                                      localizations,
                                                    );
                                                    if (mounted) {
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            localizations
                                                                .receiptGenerated,
                                                          ),
                                                          backgroundColor:
                                                              Colors.green,
                                                        ),
                                                      );
                                                    }
                                                  } catch (e) {
                                                    if (mounted) {
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            '${localizations.receiptGenerationFailed}: $e',
                                                          ),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },
                                                tooltip: localizations
                                                    .buttonDownloadReceipt,
                                              ),
                                              // WhatsApp share buttons
                                              if (record.tank?.society !=
                                                      null &&
                                                  record
                                                      .tank!
                                                      .society!
                                                      .chairmanPhone
                                                      .isNotEmpty) ...[
                                                const SizedBox(width: 4),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.chat,
                                                    size: 20,
                                                    color: Colors.green,
                                                  ),
                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      const BoxConstraints(),
                                                  onPressed: () =>
                                                      _shareToChairman(
                                                        record,
                                                        localizations,
                                                      ),
                                                  tooltip: 'Share to Chairman',
                                                ),
                                              ],
                                              if (record.tank?.society !=
                                                      null &&
                                                  record
                                                      .tank!
                                                      .society!
                                                      .secretaryPhone
                                                      .isNotEmpty) ...[
                                                const SizedBox(width: 4),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.chat,
                                                    size: 20,
                                                    color: Colors.green,
                                                  ),
                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      const BoxConstraints(),
                                                  onPressed: () =>
                                                      _shareToSecretary(
                                                        record,
                                                        localizations,
                                                      ),
                                                  tooltip: 'Share to Secretary',
                                                ),
                                              ],
                                              const SizedBox(width: 4),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                ),
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                                onPressed: () async {
                                                  final result = await context.push(
                                                    '/cleaning-records/${record.id}/edit',
                                                  );
                                                  if (result == true) {
                                                    _loadRecords();
                                                  }
                                                },
                                                tooltip: localizations
                                                    .buttonEditRecord,
                                              ),
                                              const SizedBox(width: 4),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  size: 20,
                                                ),
                                                color: Colors.red,
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                                onPressed: () async {
                                                  final confirmed = await showDialog<bool>(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      title: Text(
                                                        localizations
                                                            .deleteCleaningRecordTitle,
                                                      ),
                                                      content: Text(
                                                        localizations
                                                            .deleteCleaningRecordMessage,
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                context,
                                                                false,
                                                              ),
                                                          child: Text(
                                                            localizations
                                                                .commonCancel,
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                context,
                                                                true,
                                                              ),
                                                          style:
                                                              TextButton.styleFrom(
                                                                foregroundColor:
                                                                    Colors.red,
                                                              ),
                                                          child: Text(
                                                            localizations
                                                                .commonDelete,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                  if (confirmed == true) {
                                                    final response =
                                                        await CleaningRecordService.deleteCleaningRecord(
                                                          record.id,
                                                        );
                                                    if (response.success &&
                                                        mounted) {
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            localizations
                                                                .cleaningRecordDeleted,
                                                          ),
                                                        ),
                                                      );
                                                      _loadRecords();
                                                    } else if (mounted) {
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            response.message ??
                                                                localizations
                                                                    .cleaningRecordDeleteFailed,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },
                                                tooltip:
                                                    localizations.commonDelete,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }(),
          ),
          if (_totalPages > 1)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _currentPage > 1
                        ? () {
                            setState(() {
                              _currentPage--;
                            });
                            _loadRecords();
                          }
                        : null,
                  ),
                  Text(
                    localizations.paginationLabel(_currentPage, _totalPages),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _currentPage < _totalPages
                        ? () {
                            setState(() {
                              _currentPage++;
                            });
                            _loadRecords();
                          }
                        : null,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  PaymentStatus _resolveDisplayStatus(CleaningRecord record) {
    const double epsilon = 0.01;
    final double total = record.totalAmount;
    final double due = record.amountDue;

    if (due >= total - epsilon && due > 0) {
      // Nothing has been paid yet
      return PaymentStatus.unpaid;
    }

    if (due > epsilon) {
      // Partially paid
      return PaymentStatus.partial;
    }

    if (record.paymentStatus == PaymentStatus.unpaid) {
      return PaymentStatus.unpaid;
    }

    return PaymentStatus.paid;
  }

  bool _matchesPaymentFilter(CleaningRecord record) {
    final filter = _selectedPaymentStatus;
    if (filter == null) return true;
    final status = _resolveDisplayStatus(record);
    switch (filter) {
      case 'paid':
        return status == PaymentStatus.paid;
      case 'partial':
        return status == PaymentStatus.partial;
      case 'unpaid':
        return status == PaymentStatus.unpaid;
      default:
        return true;
    }
  }

  String _paymentStatusLabel(
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

  Future<void> _shareToChairman(
    CleaningRecord record,
    AppLocalizations localizations,
  ) async {
    final society = record.tank?.society;
    if (society == null || society.chairmanPhone.isEmpty) {
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
    AppLocalizations localizations,
  ) async {
    final society = record.tank?.society;
    if (society == null || society.secretaryPhone.isEmpty) {
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
}
