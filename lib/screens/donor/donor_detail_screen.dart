import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_fonts.dart';
import '../../models/user_profile.dart';
import '../../services/auth_service.dart';

class DonorDetailScreen extends StatelessWidget {
  final UserProfile donor;

  const DonorDetailScreen({super.key, required this.donor});

  Future<void> _contactDonor(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Action'),
        content: const Text('Are you sure you want to contact this donor?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await authService.contactDonor(donor.phoneNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Donor Details',
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
        color: AppColors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              donor.fullName,
              style: const TextStyle(
                fontFamily: AppFonts.raleway,
                fontSize: 24,
                fontWeight: AppFonts.bold,
                color: Color(0xFFE11E37),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Blood Type: ${donor.bloodType}',
              style: const TextStyle(
                fontFamily: AppFonts.sfPro,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Phone: ${donor.phoneNumber}',
              style: const TextStyle(
                fontFamily: AppFonts.sfPro,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Address: ${donor.address}',
              style: const TextStyle(
                fontFamily: AppFonts.sfPro,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            Consumer<AuthService>(
              builder: (context, authService, child) {
                return authService.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () => _contactDonor(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE11E37),
                          foregroundColor: AppColors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Contact Donor',
                          style: TextStyle(
                            fontFamily: AppFonts.sfPro,
                            fontSize: 18,
                            fontWeight: AppFonts.bold,
                          ),
                        ),
                      );
              },
            ),
            if (Provider.of<AuthService>(context).errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                Provider.of<AuthService>(context).errorMessage!,
                style: const TextStyle(
                  fontFamily: AppFonts.sfPro,
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}