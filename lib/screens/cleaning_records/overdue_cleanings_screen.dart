import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/cleaning_record.dart';
import '../../services/cleaning_record_service.dart';
import '../../utils/date_formatter.dart';

class OverdueCleaningsScreen extends StatefulWidget {
  const OverdueCleaningsScreen({super.key});

  @override
  State<OverdueCleaningsScreen> createState() => _OverdueCleaningsScreenState();
}

class _OverdueCleaningsScreenState extends State<OverdueCleaningsScreen> {
  List<CleaningRecord> _records = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOverdue();
  }

  Future<void> _loadOverdue() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final response = await CleaningRecordService.getOverdueCleanings();

    if (response.success && response.data != null) {
      setState(() {
        _records = response.data!;
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = response.message ?? 'Failed to load overdue cleanings';
        _isLoading = false;
      });
    }
  }

  int _daysOverdue(DateTime expectedDate) {
    return DateTime.now().difference(expectedDate).inDays;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overdue Cleanings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
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
                      onPressed: _loadOverdue,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : _records.isEmpty
            ? const Center(child: Text('No overdue cleanings'))
            : ListView.builder(
                itemCount: _records.length,
                itemBuilder: (context, index) {
                  final record = _records[index];
                  final daysOverdue = _daysOverdue(
                    record.nextExpectedDateOfTankCleaning,
                  );
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(record.tank?.location ?? 'Unknown'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(record.tank?.society?.name ?? 'Unknown'),
                          Text(
                            'Expected: ${DateFormatter.formatDate(record.nextExpectedDateOfTankCleaning)}',
                          ),
                          Text(
                            '$daysOverdue days overdue',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () => context.push(
                          '/cleaning-records/new?tankId=${record.tankId}',
                        ),
                        child: const Text('Create Record'),
                      ),
                      onTap: () =>
                          context.push('/cleaning-records/${record.id}'),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
