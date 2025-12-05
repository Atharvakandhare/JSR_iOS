import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jsr_app/l10n/app_localizations.dart';
import '../../models/tank.dart';
import '../../services/tank_service.dart';
import '../../services/society_service.dart';
import '../../models/society.dart';
import '../../widgets/app_drawer.dart';

class TanksListScreen extends StatefulWidget {
  const TanksListScreen({super.key});

  @override
  State<TanksListScreen> createState() => _TanksListScreenState();
}

class _TanksListScreenState extends State<TanksListScreen> {
  List<Tank> _tanks = [];
  List<Society> _societies = [];
  bool _isLoading = true;
  String? _error;
  int? _selectedSocietyId;
  int _currentPage = 1;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _loadSocieties();
    _loadTanks();
  }

  Future<void> _loadSocieties() async {
    final response = await SocietyService.getAllSocieties(limit: 1000);
    if (response.success && response.data != null) {
      setState(() {
        _societies = response.data!;
      });
    }
  }

  Future<void> _loadTanks({bool resetPage = false}) async {
    if (resetPage) _currentPage = 1;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final response = await TankService.getAllTanks(
      page: _currentPage,
      limit: 10,
      societyId: _selectedSocietyId,
    );

    if (response.success && response.data != null) {
      setState(() {
        _tanks = response.data!;
        _totalPages = response.pagination?.pages ?? 1;
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = response.message ?? 'Failed to load tanks';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteTank(int id) async {
    final localizations = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.tanksDeleteTitle),
        content: Text(localizations.tanksDeleteMessage),
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
      final response = await TankService.deleteTank(id);
      if (response.success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.tankDeletedSuccess)),
        );
        _loadTanks();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? localizations.tankDeleteFailed),
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
        title: Text(localizations.tanksTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await context.push('/tanks/new');
              if (result == true) {
                _loadTanks(resetPage: true);
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
              child: DropdownButtonFormField<int?>(
                initialValue: _selectedSocietyId,
                decoration: InputDecoration(
                  labelText: localizations.filterBySociety,
                  border: const OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem<int?>(
                    value: null,
                    child: Text(localizations.filterAllSocieties),
                  ),
                  ..._societies.map(
                    (s) => DropdownMenuItem<int?>(
                      value: s.id,
                      child: Text(s.name),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedSocietyId = value;
                  });
                  _loadTanks(resetPage: true);
                },
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
                          Text(_error ?? localizations.tanksLoadError),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _loadTanks(),
                            child: Text(localizations.commonRetry),
                          ),
                        ],
                      ),
                    )
                  : _tanks.isEmpty
                  ? Center(child: Text(localizations.tanksEmpty))
                  : ListView.builder(
                      itemCount: _tanks.length,
                      itemBuilder: (context, index) {
                        final tank = _tanks[index];
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
                                Icons.water_drop,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            title: Text(tank.location),
                            subtitle: Text(
                              '${tank.society?.name ?? localizations.commonUnknown} - ${localizations.tankFrequencyValue(tank.frequencyOfCleaning)}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () async {
                                    final result = await context.push(
                                      '/tanks/${tank.id}/edit',
                                    );
                                    if (result == true) {
                                      _loadTanks();
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () => _deleteTank(tank.id),
                                  tooltip: localizations.commonDelete,
                                ),
                              ],
                            ),
                            onTap: () => context.push('/tanks/${tank.id}'),
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
                              _loadTanks();
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
                              _loadTanks();
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
