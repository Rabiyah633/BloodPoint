import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_fonts.dart';
import '../../models/user_profile.dart';
import '../../services/auth_service.dart';
import '../donor/donor_detail_screen.dart';

class DonorsTab extends StatelessWidget {
  const DonorsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Donors',
            style: TextStyle(
              fontFamily: AppFonts.raleway,
              fontSize: 24,
              fontWeight: AppFonts.bold,
              color: Color(0xFFE11E37),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Consumer<AuthService>(
              builder: (context, authService, child) {
                return FutureBuilder<List<UserProfile>>(
                  future: authService.getAllDonors(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No available donors',
                          style: TextStyle(
                            fontFamily: AppFonts.sfPro,
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }

                    final donors = snapshot.data!;
                    return ListView.builder(
                      itemCount: donors.length,
                      itemBuilder: (context, index) {
                        final donor = donors[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.person, color: Color(0xFFE11E37)),
                            title: Text(
                              donor.fullName,
                              style: const TextStyle(
                                fontFamily: AppFonts.raleway,
                                fontSize: 18,
                                fontWeight: AppFonts.bold,
                                color: Color(0xFFE11E37),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Blood Type: ${donor.bloodType}',
                                  style: const TextStyle(
                                    fontFamily: AppFonts.sfPro,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Phone: ${donor.phoneNumber}',
                                  style: const TextStyle(
                                    fontFamily: AppFonts.sfPro,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Address: ${donor.address}',
                                  style: const TextStyle(
                                    fontFamily: AppFonts.sfPro,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DonorDetailScreen(
                                    donor: donor,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}