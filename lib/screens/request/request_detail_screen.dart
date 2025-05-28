import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_fonts.dart';
import '../../models/blood_request_model.dart';
import '../../services/auth_service.dart';

class RequestDetailScreen extends StatelessWidget {
  final String requestId;
  final BloodRequest request;
  final String requesterName;

  const RequestDetailScreen({
    super.key,
    required this.requestId,
    required this.request,
    required this.requesterName,
  });

  Future<void> _markAsFulfilled(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Action'),
        content: const Text('Are you sure you want to mark this request as fulfilled?'),
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
      final success = await authService.updateBloodRequestStatus(requestId, 'fulfilled');
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request marked as fulfilled')),
        );
        Navigator.pop(context); // Navigate back to RequestsTab
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Blood Request Details',
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
              'Blood Type: ${request.bloodType}',
              style: const TextStyle(
                fontFamily: AppFonts.raleway,
                fontSize: 24,
                fontWeight: AppFonts.bold,
                color: Color(0xFFE11E37),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Requested by: $requesterName',
              style: const TextStyle(
                fontFamily: AppFonts.sfPro,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Location: ${request.location}',
              style: const TextStyle(
                fontFamily: AppFonts.sfPro,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Urgency: ${request.urgency}',
              style: TextStyle(
                fontFamily: AppFonts.sfPro,
                fontSize: 16,
                color: request.urgency == 'high'
                    ? Colors.red
                    : request.urgency == 'medium'
                        ? Colors.orange
                        : Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Created At: ${request.createdAt.toDate().toString()}',
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
                        onPressed: () => _markAsFulfilled(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE11E37),
                          foregroundColor: AppColors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Mark as Fulfilled',
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