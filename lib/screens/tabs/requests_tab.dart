import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_fonts.dart';
import '../../services/auth_service.dart';
import '../request/request_detail_screen.dart';

class RequestsTab extends StatelessWidget {
  const RequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pending Blood Requests',
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
                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: authService.getPendingBloodRequests(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No pending requests',
                          style: TextStyle(
                            fontFamily: AppFonts.sfPro,
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }

                    final requests = snapshot.data!;
                    return ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final requestData = requests[index];
                        final request = requestData['request'];
                        final requesterName = requestData['requesterName'];
                        final requestId = requestData['id'];

                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              'Blood Type: ${request.bloodType}',
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
                                  'Requested by: $requesterName',
                                  style: const TextStyle(
                                    fontFamily: AppFonts.sfPro,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Location: ${request.location}',
                                  style: const TextStyle(
                                    fontFamily: AppFonts.sfPro,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Urgency: ${request.urgency}',
                                  style: TextStyle(
                                    fontFamily: AppFonts.sfPro,
                                    fontSize: 14,
                                    color: request.urgency == 'high'
                                        ? Colors.red
                                        : request.urgency == 'medium'
                                            ? Colors.orange
                                            : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RequestDetailScreen(
                                    requestId: requestId,
                                    request: request,
                                    requesterName: requesterName,
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