import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/tank.dart';
import '../../models/cleaning_record.dart';
import '../../services/tank_service.dart';
import '../../widgets/app_drawer.dart';
import '../../utils/date_formatter.dart';

class TankDetailsScreen extends StatefulWidget {
  final int tankId;

  const TankDetailsScreen({super.key, required this.tankId});

  @override
  State<TankDetailsScreen> createState() => _TankDetailsScreenState();
}

class _TankDetailsScreenState extends State<TankDetailsScreen> {
  Tank? _tank;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTank();
  }

  Future<void> _loadTank() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final response = await TankService.getTankById(widget.tankId);

    if (response.success && response.data != null) {
      setState(() {
        _tank = response.data;
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = response.message ?? 'Failed to load tank';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              context.pop();
            } else {
              context.go('/tanks');
            }
          },
        ),
        title: const Text('Tank Details'),
        actions: [
          if (_tank != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => context.push('/tanks/${_tank!.id}/edit'),
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
                    Text(_error!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadTank,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : _tank == null
            ? const Center(child: Text('Tank not found'))
            : RefreshIndicator(
                onRefresh: _loadTank,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTankInfoCard(),
                      const SizedBox(height: 16),
                      _buildCleaningHistory(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildTankInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _tank!.location,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Society', _tank!.society?.name ?? 'Unknown'),
            _buildInfoRow(
              'Cleaning Frequency',
              '${_tank!.frequencyOfCleaning} days',
            ),
            if (_tank!.society != null)
              TextButton(
                onPressed: () =>
                    context.push('/societies/${_tank!.society!.id}'),
                child: const Text('View Society'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildCleaningHistory() {
    final records = _tank!.cleaningRecords ?? [];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Cleaning History',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () =>
                      context.push('/cleaning-records/new?tankId=${_tank!.id}'),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Record'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (records.isEmpty)
              const Text('No cleaning records found')
            else
              ...records.map((record) {
                final displayStatus = _resolveDisplayStatus(record);
                final statusColor = _statusColor(displayStatus);
                return ListTile(
                  title: Text(
                    DateFormatter.formatDate(record.dateOfTankCleaned),
                  ),
                  subtitle: Text(
                    'Next: ${DateFormatter.formatDate(record.nextExpectedDateOfTankCleaning)}',
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Chip(
                        label: Text(displayStatus.toUpperCase()),
                        backgroundColor: statusColor,
                      ),
                      Text('₹${record.totalAmount.toStringAsFixed(2)}'),
                    ],
                  ),
                  onTap: () => context.push('/cleaning-records/${record.id}'),
                );
              }),
          ],
        ),
      ),
    );
  }

  String _resolveDisplayStatus(CleaningRecord record) {
    if (record.amountDue > 0) {
      return 'unpaid';
    }
    return record.paymentStatusString;
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'paid':
        return Colors.green;
      case 'partial':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }
}
