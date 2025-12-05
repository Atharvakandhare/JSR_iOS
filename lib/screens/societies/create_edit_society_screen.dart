import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jsr_app/l10n/app_localizations.dart';
import '../../models/society.dart';
import '../../services/society_service.dart';
import '../../services/notification_service.dart';

class CreateEditSocietyScreen extends StatefulWidget {
  final int? societyId;

  const CreateEditSocietyScreen({super.key, this.societyId});

  @override
  State<CreateEditSocietyScreen> createState() =>
      _CreateEditSocietyScreenState();
}

class _CreateEditSocietyScreenState extends State<CreateEditSocietyScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isEditMode = false;
  Society? _existingSociety;

  final _nameController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _fullAddressController = TextEditingController();
  final _chairmanNameController = TextEditingController();
  final _chairmanPhoneController = TextEditingController();
  final _chairmanEmailController = TextEditingController();
  final _secretaryNameController = TextEditingController();
  final _secretaryPhoneController = TextEditingController();
  final _secretaryEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.societyId != null;
    if (_isEditMode) {
      _loadSociety();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _fullAddressController.dispose();
    _chairmanNameController.dispose();
    _chairmanPhoneController.dispose();
    _chairmanEmailController.dispose();
    _secretaryNameController.dispose();
    _secretaryPhoneController.dispose();
    _secretaryEmailController.dispose();
    super.dispose();
  }

  Future<void> _loadSociety() async {
    setState(() => _isLoading = true);

    final response = await SocietyService.getSocietyById(widget.societyId!);

    if (response.success && response.data != null) {
      _existingSociety = response.data;
      _nameController.text = _existingSociety!.name;
      _stateController.text = _existingSociety!.state;
      _cityController.text = _existingSociety!.city;
      _pincodeController.text = _existingSociety!.pincode;
      _fullAddressController.text = _existingSociety!.fullAddress;
      _chairmanNameController.text = _existingSociety!.chairmanName;
      _chairmanPhoneController.text = _existingSociety!.chairmanPhone;
      _chairmanEmailController.text = _existingSociety!.chairmanEmail;
      _secretaryNameController.text = _existingSociety!.secretaryName;
      _secretaryPhoneController.text = _existingSociety!.secretaryPhone;
      _secretaryEmailController.text = _existingSociety!.secretaryEmail;
    }

    setState(() => _isLoading = false);
  }

  Future<void> _saveSociety() async {
    final localizations = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    if (_isEditMode) {
      final updates = {
        'name': _nameController.text.trim(),
        'state': _stateController.text.trim(),
        'city': _cityController.text.trim(),
        'pincode': _pincodeController.text.trim(),
        'fullAddress': _fullAddressController.text.trim(),
        'chairmanName': _chairmanNameController.text.trim(),
        'chairmanPhone': _chairmanPhoneController.text.trim(),
        'chairmanEmail': _chairmanEmailController.text.trim(),
        'secretaryName': _secretaryNameController.text.trim(),
        'secretaryPhone': _secretaryPhoneController.text.trim(),
        'secretaryEmail': _secretaryEmailController.text.trim(),
      };

      final response = await SocietyService.updateSociety(
        widget.societyId!,
        updates,
      );

      if (response.success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.societyUpdateSuccess)),
        );
        context.pop(true);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.message ?? localizations.societyUpdateFailed,
            ),
          ),
        );
      }
    } else {
      final society = Society(
        id: 0,
        name: _nameController.text.trim(),
        state: _stateController.text.trim(),
        city: _cityController.text.trim(),
        pincode: _pincodeController.text.trim(),
        fullAddress: _fullAddressController.text.trim(),
        chairmanName: _chairmanNameController.text.trim(),
        chairmanPhone: _chairmanPhoneController.text.trim(),
        chairmanEmail: _chairmanEmailController.text.trim(),
        secretaryName: _secretaryNameController.text.trim(),
        secretaryPhone: _secretaryPhoneController.text.trim(),
        secretaryEmail: _secretaryEmailController.text.trim(),
      );

      final response = await SocietyService.createSociety(society);

      if (response.success && mounted) {
        // Show success message immediately
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.societyCreateSuccess)),
        );
        context.pop(true);

        // Send email notification in background (non-blocking)
        // Check if chairman and secretary have valid emails
        final chairmanEmail = _chairmanEmailController.text.trim();
        final secretaryEmail = _secretaryEmailController.text.trim();
        final hasValidEmails =
            chairmanEmail.contains('@') && secretaryEmail.contains('@');

        if (hasValidEmails && response.data != null) {
          // Send notification asynchronously without blocking UI
          NotificationService.sendSocietyNotification(response.data!.id)
              .then((_) {
                // Notification sent successfully (handled silently)
              })
              .catchError((e) {
                // Notification failure is handled silently in background
                // User already sees success message, so no need to show error
              });
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.message ?? localizations.societyCreateFailed,
            ),
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
              ? localizations.editSocietyTitle
              : localizations.createSocietyTitle,
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
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: localizations.societyNameLabel,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) => value?.isEmpty ?? true
                            ? localizations.commonRequired
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _stateController,
                        decoration: InputDecoration(
                          labelText: localizations.societyStateLabel,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) => value?.isEmpty ?? true
                            ? localizations.commonRequired
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          labelText: localizations.societyCityLabel,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) => value?.isEmpty ?? true
                            ? localizations.commonRequired
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _pincodeController,
                        decoration: InputDecoration(
                          labelText: localizations.societyPincodeLabel,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => value?.isEmpty ?? true
                            ? localizations.commonRequired
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _fullAddressController,
                        decoration: InputDecoration(
                          labelText: localizations.societyAddressLabel,
                          border: const OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) => value?.isEmpty ?? true
                            ? localizations.commonRequired
                            : null,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        localizations.chairmanDetails,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _chairmanNameController,
                        decoration: InputDecoration(
                          labelText: localizations.chairmanNameLabel,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) => value?.isEmpty ?? true
                            ? localizations.commonRequired
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _chairmanPhoneController,
                        decoration: InputDecoration(
                          labelText: localizations.chairmanPhoneLabel,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return localizations.commonRequired;
                          }
                          if (value!.length != 10 ||
                              !RegExp(r'^\d+$').hasMatch(value)) {
                            return localizations.validationInvalidPhone;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _chairmanEmailController,
                        decoration: InputDecoration(
                          labelText: localizations.chairmanEmailLabel,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              !value.contains('@')) {
                            return localizations.validationInvalidEmail;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      Text(
                        localizations.secretaryDetails,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _secretaryNameController,
                        decoration: InputDecoration(
                          labelText: localizations.secretaryNameLabel,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) => value?.isEmpty ?? true
                            ? localizations.commonRequired
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _secretaryPhoneController,
                        decoration: InputDecoration(
                          labelText: localizations.secretaryPhoneLabel,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return localizations.commonRequired;
                          }
                          if (value!.length != 10 ||
                              !RegExp(r'^\d+$').hasMatch(value)) {
                            return localizations.validationInvalidPhone;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _secretaryEmailController,
                        decoration: InputDecoration(
                          labelText: localizations.secretaryEmailLabel,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              !value.contains('@')) {
                            return localizations.validationInvalidEmail;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveSociety,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : Text(
                                  _isEditMode
                                      ? localizations.buttonUpdateSociety
                                      : localizations.buttonCreateSociety,
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
