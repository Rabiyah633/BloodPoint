import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_fonts.dart';
import '../../core/constants/app_strings.dart';
import '../../models/donation.dart';
import '../../services/auth_service.dart';
import '../../services/donation_service.dart';

class DonationForm extends StatefulWidget {
  final Donation? donation;

  const DonationForm({super.key, this.donation});

  @override
  State<DonationForm> createState() => _DonationFormState();
}

class _DonationFormState extends State<DonationForm> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedBloodType;
  DateTime _selectedDate = DateTime.now();
  int _units = 1;

  @override
  void initState() {
    super.initState();
    if (widget.donation != null) {
      _locationController.text = widget.donation!.location;
      _notesController.text = widget.donation!.notes ?? '';
      _selectedBloodType = widget.donation!.bloodType;
      _selectedDate = widget.donation!.donationDate;
      _units = widget.donation!.units;
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveDonation() async {
    if (_formKey.currentState!.validate() && _selectedBloodType != null) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final donationService = DonationService();

      final donation = Donation(
        id: widget.donation?.id ?? const Uuid().v4(),
        donorId: authService.user!.uid,
        donorName: authService.user!.displayName ?? 'Anonymous',
        bloodType: _selectedBloodType!,
        donationDate: _selectedDate,
        location: _locationController.text.trim(),
        notes: _notesController.text.trim(),
        units: _units,
      );

      bool success;
      if (widget.donation != null) {
        success = await donationService.updateDonation(donation);
      } else {
        success = await donationService.createDonation(donation);
      }

      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.donation != null
                  ? 'Donation updated successfully'
                  : 'Donation recorded successfully',
            ),
          ),
        );
      }
    } else if (_selectedBloodType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select blood type')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.donation != null ? 'Edit Donation' : 'Record Donation',
          style: const TextStyle(
            fontFamily: AppFonts.raleway,
            fontSize: 20,
            fontWeight: AppFonts.bold,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blood Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedBloodType,
                decoration: const InputDecoration(
                  labelText: 'Blood Type',
                ),
                items: AppStrings.bloodTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBloodType = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Date Picker
              ListTile(
                title: const Text('Donation Date'),
                subtitle: Text(
                  _selectedDate.toString().split(' ')[0],
                  style: const TextStyle(fontFamily: AppFonts.sfPro),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),

              // Location
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Donation Location',
                  hintText: 'Enter the hospital or blood bank name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the donation location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Units
              Row(
                children: [
                  const Text('Units:'),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (_units > 1) {
                        setState(() {
                          _units--;
                        });
                      }
                    },
                  ),
                  Text('$_units'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _units++;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  hintText: 'Add any additional notes',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveDonation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    widget.donation != null ? 'Update Donation' : 'Record Donation',
                    style: const TextStyle(
                      fontFamily: AppFonts.sfPro,
                      fontSize: 16,
                      fontWeight: AppFonts.medium,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 