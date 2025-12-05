import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:jsr_app/l10n/app_localizations.dart';
import '../../models/analytics.dart';
import '../../models/cleaning_record.dart';
import '../../services/analytics_service.dart';
import '../../services/excel_analytics_service.dart';
import '../../services/cleaning_record_service.dart';
import '../../widgets/app_drawer.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<RevenueAnalytics>? _revenueAnalytics;
  List<SocietyStat>? _societyStats;
  List<CleaningFrequencyStat>? _frequencyStats;
  List<PaymentModeStat>? _paymentModeStats;
  List<LocationStat>? _locationStats;
  bool _isLoading = true;
  String _selectedPeriod = 'monthly';
  int? _selectedYear;
  String _groupBy = 'state';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _selectedYear = DateTime.now().year;
    _loadAllData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);

    await Future.wait([
      _loadRevenueAnalytics(),
      _loadSocietyStats(),
      _loadFrequencyStats(),
      _loadPaymentModeStats(),
      _loadLocationStats(),
    ]);

    setState(() => _isLoading = false);
  }

  Future<void> _loadRevenueAnalytics() async {
    final response = await AnalyticsService.getRevenueAnalytics(
      period: _selectedPeriod,
      year: _selectedYear,
    );
    if (response.success && response.data != null) {
      // Sort data by period to ensure proper ordering
      final sortedData = List<RevenueAnalytics>.from(response.data!);
      sortedData.sort((a, b) => a.period.compareTo(b.period));
      setState(() {
        _revenueAnalytics = sortedData;
      });
    }
  }

  Future<void> _loadSocietyStats() async {
    final response = await AnalyticsService.getSocietyWiseStats();
    if (response.success && response.data != null) {
      setState(() {
        _societyStats = response.data;
      });
    }
  }

  Future<void> _loadFrequencyStats() async {
    final response = await AnalyticsService.getCleaningFrequencyStats();
    if (response.success && response.data != null) {
      setState(() {
        _frequencyStats = response.data;
      });
    }
  }

  Future<void> _loadPaymentModeStats() async {
    final response = await AnalyticsService.getPaymentModeStats();
    if (response.success && response.data != null) {
      setState(() {
        _paymentModeStats = response.data;
      });
    }
  }

  Future<void> _loadLocationStats() async {
    final response = await AnalyticsService.getLocationWiseStats(
      groupBy: _groupBy,
    );
    if (response.success && response.data != null) {
      setState(() {
        _locationStats = response.data;
      });
    }
  }

  Future<List<CleaningRecord>> _fetchAllCleaningRecordsForExport() async {
    final records = <CleaningRecord>[];
    int page = 1;
    const limit = 100;
    while (true) {
      final response = await CleaningRecordService.getAllCleaningRecords(
        page: page,
        limit: limit,
      );
      if (!(response.success && response.data != null)) {
        throw Exception(
          response.message ?? 'Failed to fetch cleaning records for export',
        );
      }
      final currentBatch = response.data!;
      records.addAll(currentBatch);
      final totalPages = response.pagination?.pages ?? page;
      if (page >= totalPages || currentBatch.isEmpty) {
        break;
      }
      page++;
    }
    return records;
  }

  Future<void> _exportToExcel() async {
    final localizations = AppLocalizations.of(context)!;
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.analyticsExcelGenerating),
          duration: const Duration(seconds: 2),
        ),
      );

      final cleaningRecords = await _fetchAllCleaningRecordsForExport();

      await ExcelAnalyticsService.generateAndDownloadAnalytics(
        cleaningRecords: cleaningRecords,
        revenueAnalytics: _revenueAnalytics,
        paymentModeStats: _paymentModeStats,
        selectedPeriod: _selectedPeriod,
        selectedYear: _selectedYear,
        localizations: localizations,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.analyticsExcelGenerated),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${localizations.analyticsExcelGenerationFailed}: $e',
            ),
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
        title: Text(localizations.analyticsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: localizations.buttonExportAnalytics,
            onPressed: _exportToExcel,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: localizations.analyticsTabRevenue),
            Tab(text: localizations.analyticsTabSocieties),
            Tab(text: localizations.analyticsTabFrequency),
            Tab(text: localizations.analyticsTabPaymentModes),
            Tab(text: localizations.analyticsTabLocations),
          ],
        ),
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildRevenueTab(),
                  _buildSocietyTab(),
                  _buildFrequencyTab(),
                  _buildPaymentModeTab(),
                  _buildLocationTab(),
                ],
              ),
      ),
    );
  }

  Widget _buildRevenueTab() {
    final localizations = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedPeriod,
                  decoration: InputDecoration(
                    labelText: localizations.analyticsPeriodLabel,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'daily',
                      child: Text(localizations.analyticsPeriodDaily),
                    ),
                    DropdownMenuItem(
                      value: 'monthly',
                      child: Text(localizations.analyticsPeriodMonthly),
                    ),
                    DropdownMenuItem(
                      value: 'yearly',
                      child: Text(localizations.analyticsPeriodYearly),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedPeriod = value;
                      });
                      _loadRevenueAnalytics();
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<int?>(
                  initialValue: _selectedYear,
                  decoration: InputDecoration(
                    labelText: localizations.analyticsYearLabel,
                    border: const OutlineInputBorder(),
                  ),
                  items: List.generate(5, (index) {
                    final year = DateTime.now().year - index;
                    return DropdownMenuItem<int?>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedYear = value;
                      });
                      _loadRevenueAnalytics();
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_revenueAnalytics != null && _revenueAnalytics!.isNotEmpty) ...[
            // Summary Statistics Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                      'Total Revenue',
                      '₹${_revenueAnalytics!.fold<double>(0, (sum, e) => sum + e.totalRevenue).toStringAsFixed(2)}',
                      Colors.blue,
                    ),
                    _buildStatCard(
                      'Avg/Period',
                      '₹${(_revenueAnalytics!.fold<double>(0, (sum, e) => sum + e.totalRevenue) / _revenueAnalytics!.length).toStringAsFixed(2)}',
                      Colors.green,
                    ),
                    _buildStatCard(
                      _selectedPeriod == 'daily'
                          ? 'Days'
                          : _selectedPeriod == 'monthly'
                          ? 'Months'
                          : 'Years',
                      '${_revenueAnalytics!.length}',
                      Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Chart with improved labels and tooltips
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Total Revenue',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 350,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            horizontalInterval: _getYAxisInterval(),
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.grey.withOpacity(0.2),
                                strokeWidth: 1,
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              axisNameWidget: Text(
                                _selectedPeriod == 'daily'
                                    ? 'Days'
                                    : _selectedPeriod == 'monthly'
                                    ? 'Months'
                                    : 'Years',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 50,
                                interval: _getXAxisInterval(),
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index >= 0 &&
                                      index < _revenueAnalytics!.length &&
                                      index % _getXAxisLabelInterval() == 0) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        _formatPeriodLabel(
                                          _revenueAnalytics![index].period,
                                        ),
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              axisNameWidget: Text(
                                'Revenue (₹)',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 65,
                                interval: _getYAxisInterval(),
                                getTitlesWidget: (value, meta) {
                                  if (value >= 1000) {
                                    return Text(
                                      '₹${(value / 1000).toStringAsFixed(1)}K',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  } else {
                                    return Text(
                                      '₹${value.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          minX: 0,
                          maxX: (_revenueAnalytics!.length - 1).toDouble(),
                          minY: 0,
                          maxY: _getMaxRevenue() * 1.15,
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                                return touchedSpots.map((
                                  LineBarSpot touchedSpot,
                                ) {
                                  final index = touchedSpot.x.toInt();
                                  if (index >= 0 &&
                                      index < _revenueAnalytics!.length) {
                                    final data = _revenueAnalytics![index];
                                    return LineTooltipItem(
                                      '${_formatPeriodLabel(data.period)}\n'
                                      'Revenue: ₹${data.totalRevenue.toStringAsFixed(2)}\n'
                                      'Cleanings: ${data.totalCleanings}\n'
                                      'Collected: ₹${data.totalCollected.toStringAsFixed(2)}\n'
                                      'Pending: ₹${data.totalDue.toStringAsFixed(2)}',
                                      const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    );
                                  }
                                  return null;
                                }).toList();
                              },
                              tooltipBgColor: Colors.blue.shade700,
                              tooltipRoundedRadius: 8,
                              tooltipPadding: const EdgeInsets.all(12),
                            ),
                            handleBuiltInTouches: true,
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: _revenueAnalytics!.asMap().entries.map((
                                e,
                              ) {
                                return FlSpot(
                                  e.key.toDouble(),
                                  e.value.totalRevenue,
                                );
                              }).toList(),
                              isCurved: true,
                              color: Colors.blue,
                              barWidth: 4,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 6,
                                    color: Colors.blue,
                                    strokeWidth: 3,
                                    strokeColor: Colors.white,
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.blue.withOpacity(0.15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Enhanced Data table showing detailed values
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localizations.analyticsRevenueDetailsTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_revenueAnalytics!.length} ${_selectedPeriod == 'daily'
                              ? 'Days'
                              : _selectedPeriod == 'monthly'
                              ? 'Months'
                              : 'Years'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Table header
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Period',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Revenue',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Cleanings',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Collected',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Table rows
                    ..._revenueAnalytics!.asMap().entries.map((entry) {
                      final data = entry.value;
                      final isEven = entry.key % 2 == 0;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isEven ? Colors.grey[50] : Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                _formatPeriodLabel(data.period),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '₹${(data.totalRevenue / 1000).toStringAsFixed(1)}K',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${data.totalCleanings}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '₹${(data.totalCollected / 1000).toStringAsFixed(1)}K',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Colors.green[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    if (_revenueAnalytics!.any((e) => e.totalDue > 0)) ...[
                      const Divider(height: 24),
                      Text(
                        'Outstanding Amounts',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._revenueAnalytics!
                          .where((e) => e.totalDue > 0)
                          .map(
                            (data) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatPeriodLabel(data.period),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Pending: ₹${data.totalDue.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                  ],
                ),
              ),
            ),
          ] else
            Center(child: Text(localizations.analyticsNoRevenueData)),
        ],
      ),
    );
  }

  Widget _buildSocietyTab() {
    final localizations = AppLocalizations.of(context)!;
    return _societyStats == null || _societyStats!.isEmpty
        ? Center(child: Text(localizations.analyticsNoData))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _societyStats!.length,
            itemBuilder: (context, index) {
              final stat = _societyStats![index];
              return Card(
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue[400],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.business,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  title: Text(stat.societyName),
                  subtitle: Text('${stat.city}, ${stat.state}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${stat.totalRevenue.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        localizations.commonDueLabel(
                          stat.totalDue.toStringAsFixed(2),
                        ),
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget _buildFrequencyTab() {
    final localizations = AppLocalizations.of(context)!;
    return _frequencyStats == null || _frequencyStats!.isEmpty
        ? Center(child: Text(localizations.analyticsNoData))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _frequencyStats!.length,
            itemBuilder: (context, index) {
              final stat = _frequencyStats![index];
              return Card(
                child: ListTile(
                  title: Text(
                    localizations.analyticsFrequencyDays(
                      stat.frequencyOfCleaning,
                    ),
                  ),
                  trailing: Text(
                    localizations.analyticsTankCount(stat.tankCount),
                  ),
                ),
              );
            },
          );
  }

  Widget _buildPaymentModeTab() {
    final localizations = AppLocalizations.of(context)!;
    return _paymentModeStats == null || _paymentModeStats!.isEmpty
        ? Center(child: Text(localizations.analyticsNoData))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _paymentModeStats!.length,
            itemBuilder: (context, index) {
              final stat = _paymentModeStats![index];
              return Card(
                child: ListTile(
                  title: Text(
                    stat.paymentMode?.toUpperCase() ??
                        localizations.commonUnknown,
                  ),
                  subtitle: Text(
                    localizations.analyticsTransactionsCount(stat.count),
                  ),
                  trailing: Text(
                    '₹${stat.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
  }

  Widget _buildLocationTab() {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: DropdownButtonFormField<String>(
            initialValue: _groupBy,
            decoration: InputDecoration(
              labelText: localizations.analyticsGroupByLabel,
              border: const OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem(
                value: 'state',
                child: Text(localizations.analyticsGroupByState),
              ),
              DropdownMenuItem(
                value: 'city',
                child: Text(localizations.analyticsGroupByCity),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _groupBy = value;
                });
                _loadLocationStats();
              }
            },
          ),
        ),
        Expanded(
          child: _locationStats == null || _locationStats!.isEmpty
              ? Center(child: Text(localizations.analyticsNoData))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _locationStats!.length,
                  itemBuilder: (context, index) {
                    final stat = _locationStats![index];
                    return Card(
                      child: ListTile(
                        title: Text(stat.state ?? localizations.commonUnknown),
                        subtitle: stat.city != null ? Text(stat.city!) : null,
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              localizations.analyticsSocietyCount(
                                stat.societyCount,
                              ),
                            ),
                            Text(
                              localizations.analyticsTankCount(stat.tankCount),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  double _getMaxRevenue() {
    if (_revenueAnalytics == null || _revenueAnalytics!.isEmpty) {
      return 1000;
    }
    return _revenueAnalytics!
        .map((e) => e.totalRevenue)
        .reduce((a, b) => a > b ? a : b);
  }

  double _getYAxisInterval() {
    final max = _getMaxRevenue();
    if (max < 10000) return 2000;
    if (max < 50000) return 10000;
    if (max < 100000) return 20000;
    if (max < 500000) return 50000;
    return 100000;
  }

  double _getXAxisInterval() {
    if (_revenueAnalytics == null || _revenueAnalytics!.isEmpty) {
      return 1;
    }
    final count = _revenueAnalytics!.length;
    if (count <= 5) return 1;
    if (count <= 12) return 1;
    return (count / 10).ceil().toDouble();
  }

  int _getXAxisLabelInterval() {
    if (_revenueAnalytics == null || _revenueAnalytics!.isEmpty) {
      return 1;
    }
    final count = _revenueAnalytics!.length;
    if (count <= 5) return 1;
    if (count <= 12) return 1;
    if (count <= 30) return 2;
    return (count / 10).ceil();
  }

  String _formatPeriodLabel(String period) {
    // Format period based on selected period type
    if (_selectedPeriod == 'monthly') {
      // period format: "2024-01" or "2025-10" -> "Jan 2024" or "Oct 2025"
      try {
        final parts = period.split('-');
        if (parts.length == 2) {
          final year = parts[0];
          final month = int.parse(parts[1]);
          if (month >= 1 && month <= 12) {
            final monthNames = [
              'Jan',
              'Feb',
              'Mar',
              'Apr',
              'May',
              'Jun',
              'Jul',
              'Aug',
              'Sep',
              'Oct',
              'Nov',
              'Dec',
            ];
            return '${monthNames[month - 1]}\n$year';
          }
        }
      } catch (e) {
        // Fall through to return period as is
      }
    } else if (_selectedPeriod == 'yearly') {
      // period format: "2024" -> "2024"
      // If format is "2025-10" for yearly, extract just the year
      try {
        final parts = period.split('-');
        if (parts.length == 1) {
          return period;
        } else if (parts.isNotEmpty) {
          // Extract year from "2025-10" format
          return parts[0];
        }
      } catch (e) {
        // Fall through
      }
      return period;
    } else if (_selectedPeriod == 'daily') {
      // period format: "2024-01-15" -> "15 Jan"
      try {
        final parts = period.split('-');
        if (parts.length == 3) {
          final month = int.parse(parts[1]);
          final day = parts[2];
          if (month >= 1 && month <= 12) {
            final monthNames = [
              'Jan',
              'Feb',
              'Mar',
              'Apr',
              'May',
              'Jun',
              'Jul',
              'Aug',
              'Sep',
              'Oct',
              'Nov',
              'Dec',
            ];
            return '$day\n${monthNames[month - 1]}';
          }
        }
      } catch (e) {
        // Fall through to return period as is
      }
    }
    return period;
  }
}
