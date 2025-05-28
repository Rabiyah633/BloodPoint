import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_fonts.dart';
import '../../services/auth_service.dart';
import '../../models/user_profile.dart';
import '../home/home_screen.dart';

class UserProfileForm extends StatefulWidget {
  const UserProfileForm({super.key});

  @override
  State<UserProfileForm> createState() => _UserProfileFormState();
}

class _UserProfileFormState extends State<UserProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String? _selectedBloodType;
  UserProfile? _existingProfile;

  final List<String> _bloodTypes = [
    'A+', 'A-', 'B+', 'B-',
    'AB+', 'AB-', 'O+', 'O-',
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  Future<void> _loadExistingProfile() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.user;
    if (user != null) {
      final profile = await authService.getUserProfile(user.uid);
      if (profile != null) {
        setState(() {
          _existingProfile = profile;
          _selectedBloodType = profile.bloodType;
          _phoneController.text = profile.phoneNumber;
          _addressController.text = profile.address;
        });
      }
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate() && _selectedBloodType != null) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = authService.user;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      final profile = UserProfile(
        uid: user.uid,
        fullName: user.displayName ?? '',
        bloodType: _selectedBloodType!,
        phoneNumber: _phoneController.text.trim(),
        address: _addressController.text.trim(),
      );

      bool success = await authService.saveUserProfile(profile);
      if (success) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      }
    } else if (_selectedBloodType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your blood type')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withOpacity(0.2),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: AppColors.white,
                size: 24,
              ),
              onPressed: () => Navigator.of(context).pop(),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE11E37), Color(0xFFE2465B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Consumer<AuthService>(
              builder: (context, authService, child) {
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        _existingProfile == null ? 'Complete Your Profile' : 'Update Your Profile',
                        style: const TextStyle(
                          fontFamily: AppFonts.raleway,
                          fontSize: 28,
                          fontWeight: AppFonts.bold,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 32),
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
                            return 'Please select your blood type';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: AppColors.white,
                          hintText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(value)) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: AppColors.white,
                          hintText: 'Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      authService.isLoading
                          ? const CircularProgressIndicator(
                              color: AppColors.white,
                            )
                          : ElevatedButton(
                              onPressed: _saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.white,
                                foregroundColor: const Color(0xFFE11E37),
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                _existingProfile == null ? 'Save Profile' : 'Update Profile',
                                style: const TextStyle(
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
    );
  }
}