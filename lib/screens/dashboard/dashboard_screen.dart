import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:jsr_app/l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../services/analytics_service.dart';
import '../../models/analytics.dart';
import '../../widgets/app_drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardStats? _stats;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDashboardStats();
  }

  Future<void> _loadDashboardStats() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final response = await AnalyticsService.getDashboardStats();

    if (response.success && response.data != null) {
      setState(() {
        _stats = response.data;
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = response.message ?? 'Failed to load dashboard';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.dashboardTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthProvider>(context, listen: false).logout();
              if (mounted) context.go('/login');
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_error ?? localizations.dashboardLoadError),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadDashboardStats,
                      child: Text(localizations.commonRetry),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: _loadDashboardStats,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOverviewCards(localizations),
                      const SizedBox(height: 24),
                      _buildPaymentStats(localizations),
                      const SizedBox(height: 24),
                      _buildRevenueSummary(localizations),
                      const SizedBox(height: 24),
                      _buildQuickActions(localizations),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildOverviewCards(AppLocalizations localizations) {
    if (_stats == null) return const SizedBox.shrink();

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1,
      children: [
        _buildStatCard(
          localizations.dashboardTotalSocieties,
          _stats!.overview.totalSocieties.toString(),
          Icons.apartment,
          Colors.blue,
        ),
        _buildStatCard(
          localizations.dashboardTotalTanks,
          _stats!.overview.totalTanks.toString(),
          Icons.water_drop,
          Colors.cyan,
        ),
        _buildStatCard(
          localizations.dashboardTotalCleanings,
          _stats!.overview.totalCleanings.toString(),
          Icons.cleaning_services,
          Colors.green,
        ),
        _buildStatCard(
          localizations.dashboardRecentCleanings,
          _stats!.overview.recentCleanings.toString(),
          Icons.history,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentStats(AppLocalizations localizations) {
    if (_stats == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.dashboardPaymentStats,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ..._stats!.payments.map(
              (payment) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        _mapPaymentStatus(
                          payment.paymentStatus,
                          localizations,
                        ).toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        localizations.dashboardRecordsCount(payment.count),
                        style: const TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        '₹${payment.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueSummary(AppLocalizations localizations) {
    if (_stats == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.dashboardRevenueSummary,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildRevenueRow(
              localizations.dashboardTotalRevenue,
              _stats!.revenue.totalRevenue,
            ),
            _buildRevenueRow(
              localizations.dashboardTotalCollected,
              _stats!.revenue.totalCollected,
            ),
            _buildRevenueRow(
              localizations.dashboardTotalDue,
              _stats!.revenue.totalDue,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueRow(String label, double amount, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(AppLocalizations localizations) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.dashboardQuickActions,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildActionButton(
                  localizations.dashboardCreateSociety,
                  Icons.add_business,
                  () => context.push('/societies/new'),
                ),
                _buildActionButton(
                  localizations.dashboardCreateTank,
                  Icons.add_circle,
                  () => context.push('/tanks/new'),
                ),
                _buildActionButton(
                  localizations.dashboardCreateCleaning,
                  Icons.add_task,
                  () => context.push('/cleaning-records/new'),
                ),
                _buildActionButton(
                  localizations.dashboardUpcoming,
                  Icons.calendar_today,
                  () => context.push('/cleaning-records/upcoming'),
                ),
                _buildActionButton(
                  localizations.dashboardOverdue,
                  Icons.warning,
                  () => context.push('/cleaning-records/overdue'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  String _mapPaymentStatus(String status, AppLocalizations localizations) {
    switch (status.toLowerCase()) {
      case 'paid':
        return localizations.paymentStatusPaid;
      case 'partial':
        return localizations.paymentStatusPartial;
      case 'unpaid':
      default:
        return localizations.paymentStatusUnpaid;
    }
  }
}
