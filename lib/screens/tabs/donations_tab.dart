import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_fonts.dart';
import '../../models/donation.dart';
import '../../services/auth_service.dart';
import '../../services/donation_service.dart';
import '../donation/donation_form.dart';

class DonationsTab extends StatelessWidget {
  const DonationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final donationService = DonationService();

    return Scaffold(
      body: StreamBuilder<List<Donation>>(
        stream: donationService.getDonationsForUser(authService.user?.uid ?? ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Check if the error is related to indexing
            if (snapshot.error.toString().contains('indexes')) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    const Text(
                      'Setting up the database...',
                      style: TextStyle(
                        fontFamily: AppFonts.sfPro,
                        fontSize: 18,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This may take a few minutes',
                      style: TextStyle(
                        fontFamily: AppFonts.sfPro,
                        fontSize: 14,
                        color: AppColors.grey.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              );
            }
            // For other errors, show the error message
            return Center(
              child: Text(
                'Error loading donations: ${snapshot.error}',
                style: const TextStyle(
                  fontFamily: AppFonts.sfPro,
                  color: Colors.red,
                ),
              ),
            );
          }

          final donations = snapshot.data ?? [];

          if (donations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.volunteer_activism,
                    size: 64,
                    color: AppColors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No donations recorded yet',
                    style: TextStyle(
                      fontFamily: AppFonts.sfPro,
                      fontSize: 18,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DonationForm(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                    ),
                    child: const Text('Record New Donation'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: donations.length,
            itemBuilder: (context, index) {
              final donation = donations[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(
                    'Blood Type: ${donation.bloodType}',
                    style: const TextStyle(
                      fontFamily: AppFonts.sfPro,
                      fontWeight: AppFonts.medium,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date: ${donation.donationDate.toString().split(' ')[0]}',
                        style: const TextStyle(fontFamily: AppFonts.sfPro),
                      ),
                      Text(
                        'Location: ${donation.location}',
                        style: const TextStyle(fontFamily: AppFonts.sfPro),
                      ),
                      if (donation.notes != null && donation.notes!.isNotEmpty)
                        Text(
                          'Notes: ${donation.notes}',
                          style: const TextStyle(fontFamily: AppFonts.sfPro),
                        ),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                    onSelected: (value) async {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DonationForm(donation: donation),
                          ),
                        );
                      } else if (value == 'delete') {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text(
                              'Are you sure you want to delete this donation record?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await donationService.deleteDonation(donation.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Donation record deleted'),
                              ),
                            );
                          }
                        }
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DonationForm()),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
} 