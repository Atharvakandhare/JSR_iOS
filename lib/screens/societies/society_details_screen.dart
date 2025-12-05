import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/cleaning_record.dart';
import '../../models/society.dart';
import '../../models/tank.dart';
import '../../services/society_service.dart';
import '../../widgets/app_drawer.dart';
import '../../utils/date_formatter.dart';

class SocietyDetailsScreen extends StatefulWidget {
  final int societyId;

  const SocietyDetailsScreen({super.key, required this.societyId});

  @override
  State<SocietyDetailsScreen> createState() => _SocietyDetailsScreenState();
}

class _SocietyDetailsScreenState extends State<SocietyDetailsScreen> {
  Society? _society;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSociety();
  }

  Future<void> _loadSociety() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final response = await SocietyService.getSocietyById(widget.societyId);

    if (response.success && response.data != null) {
      setState(() {
        _society = response.data;
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = response.message ?? 'Failed to load society';
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
              context.go('/societies');
            }
          },
        ),
        title: const Text('Society Details'),
        actions: [
          if (_society != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final result = await context.push(
                  '/societies/${_society!.id}/edit',
                );
                if (result == true) {
                  _loadSociety();
                }
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
                    Text(_error!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadSociety,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : _society == null
            ? const Center(child: Text('Society not found'))
            : RefreshIndicator(
                onRefresh: _loadSociety,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSocietyInfoCard(),
                      const SizedBox(height: 16),
                      _buildTanksSection(),
                      const SizedBox(height: 16),
                      _buildRecentCleanings(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildSocietyInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _society!.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Address', _society!.fullAddress),
            _buildInfoRow('State', _society!.state),
            _buildInfoRow('City', _society!.city),
            _buildInfoRow('Pincode', _society!.pincode),
            const Divider(),
            const Text(
              'Chairman Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildInfoRow('Name', _society!.chairmanName),
            _buildInfoRow('Phone', _society!.chairmanPhone),
            _buildInfoRow('Email', _society!.chairmanEmail),
            const Divider(),
            const Text(
              'Secretary Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildInfoRow('Name', _society!.secretaryName),
            _buildInfoRow('Phone', _society!.secretaryPhone),
            _buildInfoRow('Email', _society!.secretaryEmail),
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
            width: 100,
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

  Widget _buildTanksSection() {
    // Parse tanks from dynamic list
    final tanksList = _society!.tanks ?? [];
    final tanks = tanksList.map((t) {
      if (t is Map<String, dynamic>) {
        return Tank.fromJson(t);
      }
      return t as Tank;
    }).toList();
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
                  'Tanks',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await context.push(
                      '/tanks/new?societyId=${_society!.id}',
                    );
                    if (result == true) {
                      _loadSociety();
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Tank'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (tanks.isEmpty)
              const Text('No tanks found')
            else
              ...tanks.map((tank) {
                return ListTile(
                  title: Text(tank.location),
                  subtitle: Text('Frequency: ${tank.frequencyOfCleaning} days'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/tanks/${tank.id}'),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentCleanings() {
    // Get recent cleanings from tanks
    final allCleanings = <dynamic>[];
    final tanksList = _society!.tanks ?? [];
    for (final tankData in tanksList) {
      final tank = tankData is Map<String, dynamic>
          ? Tank.fromJson(tankData)
          : tankData as Tank;
      if (tank.cleaningRecords != null) {
        allCleanings.addAll(tank.cleaningRecords!);
      }
    }
    allCleanings.sort(
      (a, b) => b.dateOfTankCleaned.compareTo(a.dateOfTankCleaned),
    );
    final recentCleanings = allCleanings.take(5).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Cleaning Records',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (recentCleanings.isEmpty)
              const Text('No cleaning records found')
            else
              ...recentCleanings.map(
                (record) => ListTile(
                  title: Text(record.tank?.location ?? _society!.name),
                  subtitle: Text(
                    'Date: ${DateFormatter.formatDate(record.dateOfTankCleaned)}',
                  ),
                  trailing: _buildPaymentStatusBadge(record),
                  onTap: () => context.push('/cleaning-records/${record.id}'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentStatusBadge(CleaningRecord record) {
    final status = _resolveDisplayStatus(record);
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
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
