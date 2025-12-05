import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/cleaning_record.dart';
import '../../services/cleaning_record_service.dart';
import '../../utils/date_formatter.dart';

class UpcomingCleaningsScreen extends StatefulWidget {
  const UpcomingCleaningsScreen({super.key});

  @override
  State<UpcomingCleaningsScreen> createState() =>
      _UpcomingCleaningsScreenState();
}

class _UpcomingCleaningsScreenState extends State<UpcomingCleaningsScreen> {
  List<CleaningRecord> _records = [];
  bool _isLoading = true;
  String? _error;
  int _days = 7;

  @override
  void initState() {
    super.initState();
    _loadUpcoming();
  }

  Future<void> _loadUpcoming() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final response = await CleaningRecordService.getUpcomingCleanings(
      days: _days,
    );

    if (response.success && response.data != null) {
      setState(() {
        _records = response.data!;
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = response.message ?? 'Failed to load upcoming cleanings';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Cleanings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text('Days ahead: '),
                  DropdownButton<int>(
                    value: _days,
                    items: [7, 14, 30, 60].map((d) {
                      return DropdownMenuItem<int>(
                        value: d,
                        child: Text('$d days'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _days = value;
                        });
                        _loadUpcoming();
                      }
                    },
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
                          Text(_error!),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadUpcoming,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : _records.isEmpty
                  ? const Center(child: Text('No upcoming cleanings'))
                  : ListView.builder(
                      itemCount: _records.length,
                      itemBuilder: (context, index) {
                        final record = _records[index];
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
                              ],
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () =>
                                context.push('/cleaning-records/${record.id}'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
