import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jsr_app/l10n/app_localizations.dart';
import '../../models/tank.dart';
import '../../services/tank_service.dart';
import '../../services/society_service.dart';
import '../../models/society.dart';

class CreateEditTankScreen extends StatefulWidget {
  final int? tankId;
  final int? initialSocietyId;

  const CreateEditTankScreen({super.key, this.tankId, this.initialSocietyId});

  @override
  State<CreateEditTankScreen> createState() => _CreateEditTankScreenState();
}

class _CreateEditTankScreenState extends State<CreateEditTankScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isEditMode = false;
  Tank? _existingTank;
  List<Society> _societies = [];
  int? _selectedSocietyId;
  final _locationController = TextEditingController();
  final _frequencyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.tankId != null;
    if (widget.initialSocietyId != null) {
      _selectedSocietyId = widget.initialSocietyId;
    }
    _loadSocieties();
    if (_isEditMode) {
      _loadTank();
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  Future<void> _loadSocieties() async {
    final response = await SocietyService.getAllSocieties(limit: 1000);
    if (response.success && response.data != null) {
      setState(() {
        _societies = response.data!;
      });
    }
  }

  Future<void> _loadTank() async {
    setState(() => _isLoading = true);

    final response = await TankService.getTankById(widget.tankId!);

    if (response.success && response.data != null) {
      _existingTank = response.data;
      _selectedSocietyId = _existingTank!.societyId;
      _locationController.text = _existingTank!.location;
      _frequencyController.text = _existingTank!.frequencyOfCleaning.toString();
    }

    setState(() => _isLoading = false);
  }

  Future<void> _saveTank() async {
    final localizations = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    if (_isEditMode) {
      final updates = {
        if (_selectedSocietyId != null) 'societyId': _selectedSocietyId,
        'location': _locationController.text.trim(),
        'frequencyOfCleaning': int.parse(_frequencyController.text),
      };

      final response = await TankService.updateTank(widget.tankId!, updates);

      if (response.success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.tankUpdateSuccess)),
        );
        context.pop(true);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? localizations.tankUpdateFailed),
          ),
        );
      }
    } else {
      final tank = Tank(
        id: 0,
        societyId: _selectedSocietyId!,
        location: _locationController.text.trim(),
        frequencyOfCleaning: int.parse(_frequencyController.text),
      );

      final response = await TankService.createTank(tank);

      if (response.success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.tankCreateSuccess)),
        );
        context.pop(true);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? localizations.tankCreateFailed),
          ),
        );
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditMode
              ? localizations.editTankTitle
              : localizations.createTankTitle,
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
                        initialValue: _selectedSocietyId,
                        decoration: InputDecoration(
                          labelText: localizations.tankSocietyLabel,
                          border: const OutlineInputBorder(),
                        ),
                        items: _societies.map((society) {
                          return DropdownMenuItem<int>(
                            value: society.id,
                            child: Text(society.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSocietyId = value;
                          });
                        },
                        validator: (value) => value == null
                            ? localizations.validationSelectSociety
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: localizations.tankLocationLabel,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) => value?.isEmpty ?? true
                            ? localizations.commonRequired
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _frequencyController,
                        decoration: InputDecoration(
                          labelText: localizations.tankFrequencyLabel,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return localizations.commonRequired;
                          }
                          final num = int.tryParse(value!);
                          if (num == null || num <= 0) {
                            return localizations.commonPositiveNumber;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveTank,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : Text(
                                  _isEditMode
                                      ? localizations.buttonUpdateTank
                                      : localizations.buttonCreateTank,
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
}
