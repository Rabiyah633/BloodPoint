import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_fonts.dart';
import '../../services/auth_service.dart';
import '../../models/blood_request_model.dart';
import '../home/home_screen.dart';

class BloodRequestForm extends StatefulWidget {
  const BloodRequestForm({super.key});

  @override
  State<BloodRequestForm> createState() => _BloodRequestFormState();
}

class _BloodRequestFormState extends State<BloodRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedBloodType;
  String? _selectedUrgency;

  final List<String> _bloodTypes = [
    'A+', 'A-', 'B+', 'B-',
    'AB+', 'AB-', 'O+', 'O-',
  ];

  final List<String> _urgencyLevels = [
    'low',
    'medium',
    'high',
  ];

  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate() && _selectedBloodType != null && _selectedUrgency != null) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = authService.user;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      final request = BloodRequest(
        userId: user.uid,
        bloodType: _selectedBloodType!,
        location: _locationController.text.trim(),
        urgency: _selectedUrgency!,
        createdAt: Timestamp.now(),
      );

      bool success = await authService.saveBloodRequest(request);
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Blood request submitted successfully!')),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      }
    } else if (_selectedBloodType == null || _selectedUrgency == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select blood type and urgency')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Blood Request',
          style: TextStyle(
            fontFamily: AppFonts.raleway,
            fontSize: 20,
            fontWeight: AppFonts.bold,
            color: AppColors.white,
          ),
        ),
        backgroundColor: const Color(0xFFE11E37),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE11E37), Color(0xFFE2465B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Consumer<AuthService>(
                builder: (context, authService, child) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Blood Type Dropdown
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: AppColors.white,
                            hintText: 'Select Blood Type',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          value: _selectedBloodType,
                          items: _bloodTypes.map((bloodType) {
                            return DropdownMenuItem(
                              value: bloodType,
                              child: Text(
                                bloodType,
                                style: const TextStyle(
                                  fontFamily: AppFonts.sfPro,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedBloodType = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a blood type';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Location Field
                        TextFormField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: AppColors.white,
                            hintText: 'Location (e.g., City)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a location';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Urgency Dropdown
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: AppColors.white,
                            hintText: 'Select Urgency',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          value: _selectedUrgency,
                          items: _urgencyLevels.map((urgency) {
                            return DropdownMenuItem(
                              value: urgency,
                              child: Text(
                                urgency,
                                style: const TextStyle(
                                  fontFamily: AppFonts.sfPro,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedUrgency = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select an urgency level';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Notes Field
                        TextFormField(
                          controller: _notesController,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: AppColors.white,
                            hintText: 'Additional Notes (Optional)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 24),
                        // Submit Button
                        authService.isLoading
                            ? const CircularProgressIndicator(
                                color: AppColors.white,
                              )
                            : ElevatedButton(
                                onPressed: _submitRequest,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.white,
                                  foregroundColor: const Color(0xFFE11E37),
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Submit Request',
                                  style: TextStyle(
                                    fontFamily: AppFonts.sfPro,
                                    fontSize: 18,
                                    fontWeight: AppFonts.bold,
                                  ),
                                ),
                              ),
                        if (authService.errorMessage != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            authService.errorMessage!,
                            style: const TextStyle(
                              fontFamily: AppFonts.sfPro,
                              color: AppColors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}