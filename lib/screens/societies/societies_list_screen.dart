import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jsr_app/l10n/app_localizations.dart';
import '../../models/society.dart';
import '../../services/society_service.dart';
import '../../services/notification_service.dart';
import '../../widgets/app_drawer.dart';

class SocietiesListScreen extends StatefulWidget {
  const SocietiesListScreen({super.key});

  @override
  State<SocietiesListScreen> createState() => _SocietiesListScreenState();
}

class _SocietiesListScreenState extends State<SocietiesListScreen> {
  List<Society> _societies = [];
  bool _isLoading = true;
  String? _error;
  int _currentPage = 1;
  int _totalPages = 1;
  final _searchController = TextEditingController();
  String? _selectedState;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _loadSocieties();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSocieties({bool resetPage = false}) async {
    if (resetPage) _currentPage = 1;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final response = await SocietyService.getAllSocieties(
      page: _currentPage,
      limit: 10,
      search: _searchController.text.isEmpty ? null : _searchController.text,
      state: _selectedState,
      city: _selectedCity,
    );

    if (response.success && response.data != null) {
      setState(() {
        _societies = response.data!;
        _totalPages = response.pagination?.pages ?? 1;
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = response.message ?? 'Failed to load societies';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteSociety(int id) async {
    final localizations = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.societiesDeleteTitle),
        content: Text(localizations.societiesDeleteMessage),
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
      final response = await SocietyService.deleteSociety(id);
      if (response.success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.societyDeletedSuccess)),
        );
        _loadSocieties();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.message ?? localizations.societyDeleteFailed,
            ),
          ),
        );
      }
    }
  }

  Future<void> _sendSocietyNotification(int societyId) async {
    final response = await NotificationService.sendSocietyNotification(
      societyId,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.success
                ? 'Notification sent successfully'
                : response.message ?? 'Failed to send notification',
          ),
          backgroundColor: response.success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  Future<void> _sendBulkCleaningReminders() async {
    final response = await NotificationService.sendBulkCleaningReminders();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.success
                ? 'Bulk cleaning reminders sent successfully'
                : response.message ?? 'Failed to send bulk cleaning reminders',
          ),
          backgroundColor: response.success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  Future<void> _sendBulkPaymentReminders() async {
    final response = await NotificationService.sendBulkPaymentReminders();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.success
                ? 'Bulk payment reminders sent successfully'
                : response.message ?? 'Failed to send bulk payment reminders',
          ),
          backgroundColor: response.success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.societiesTitle),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.notifications),
            onSelected: (value) {
              switch (value) {
                case 'bulk_cleaning':
                  _sendBulkCleaningReminders();
                  break;
                case 'bulk_payment':
                  _sendBulkPaymentReminders();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'bulk_cleaning',
                child: Row(
                  children: [
                    Icon(Icons.cleaning_services, size: 20),
                    SizedBox(width: 8),
                    Text('Send Bulk Cleaning Reminders'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'bulk_payment',
                child: Row(
                  children: [
                    Icon(Icons.payment, size: 20),
                    SizedBox(width: 8),
                    Text('Send Bulk Payment Reminders'),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await context.push('/societies/new');
              if (result == true) {
                _loadSocieties(resetPage: true);
              }
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: localizations.societiesSearchLabel,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _loadSocieties(resetPage: true);
                              },
                            )
                          : null,
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _loadSocieties(resetPage: true),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedState,
                          decoration: InputDecoration(
                            labelText: localizations.societiesStateLabel,
                            border: const OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: null,
                              child: Text(localizations.societiesAllStates),
                            ),
                            const DropdownMenuItem(
                              value: 'Maharashtra',
                              child: Text('Maharashtra'),
                            ),
                            const DropdownMenuItem(
                              value: 'Gujarat',
                              child: Text('Gujarat'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedState = value;
                              _selectedCity = null;
                            });
                            _loadSocieties(resetPage: true);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedCity,
                          decoration: InputDecoration(
                            labelText: localizations.societiesCityLabel,
                            border: const OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: null,
                              child: Text(localizations.societiesAllCities),
                            ),
                            const DropdownMenuItem(
                              value: 'Mumbai',
                              child: Text('Mumbai'),
                            ),
                            const DropdownMenuItem(
                              value: 'Pune',
                              child: Text('Pune'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCity = value;
                            });
                            _loadSocieties(resetPage: true);
                          },
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
                          Text(_error ?? localizations.societiesLoadError),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _loadSocieties(),
                            child: Text(localizations.commonRetry),
                          ),
                        ],
                      ),
                    )
                  : _societies.isEmpty
                  ? Center(child: Text(localizations.societiesEmpty))
                  : ListView.builder(
                      itemCount: _societies.length,
                      itemBuilder: (context, index) {
                        final society = _societies[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
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
                            title: Text(society.name),
                            subtitle: Text('${society.city}, ${society.state}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.notifications),
                                  color: Colors.blue,
                                  onPressed: () =>
                                      _sendSocietyNotification(society.id),
                                  tooltip: 'Send Notification',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () async {
                                    final result = await context.push(
                                      '/societies/${society.id}/edit',
                                    );
                                    if (result == true) {
                                      _loadSocieties();
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () => _deleteSociety(society.id),
                                  tooltip: localizations.commonDelete,
                                ),
                              ],
                            ),
                            onTap: () =>
                                context.push('/societies/${society.id}'),
                          ),
                        );
                      },
                    ),
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
                              _loadSocieties();
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
                              _loadSocieties();
                            }
                          : null,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
