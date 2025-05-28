import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_fonts.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../auth/login_screen.dart';
import '../profile/user_profile_form.dart';
import '../request/blood_request_form.dart';
import '../donate/donation_offer_form.dart';
import '../tabs/requests_tab.dart';
import '../tabs/donors_tab.dart';
import '../tabs/donations_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<String> _bloodTypes = [
    'A+', 'A-', 'B+', 'B-',
    'AB+', 'AB-', 'O+', 'O-',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    final List<Widget> _tabs = [
      // Home Tab
      Container(
        color: AppColors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Blood Availability',
              style: TextStyle(
                fontFamily: AppFonts.raleway,
                fontSize: 24,
                fontWeight: AppFonts.bold,
                color: Color(0xFFE11E37),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<Map<String, int>>(
                future: authService.getRequestCounts(),
                builder: (context, requestSnapshot) {
                  return FutureBuilder<Map<String, int>>(
                    future: authService.getDonorCounts(),
                    builder: (context, donorSnapshot) {
                      if (requestSnapshot.connectionState == ConnectionState.waiting ||
                          donorSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (requestSnapshot.hasError || donorSnapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error loading data',
                            style: const TextStyle(
                              fontFamily: AppFonts.sfPro,
                              color: Colors.red,
                            ),
                          ),
                        );
                      }

                      final requestCounts = requestSnapshot.data ?? {};
                      final donorCounts = donorSnapshot.data ?? {};

                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: _bloodTypes.length,
                        itemBuilder: (context, index) {
                          final bloodType = _bloodTypes[index];
                          final requestCount = requestCounts[bloodType] ?? 0;
                          final donorCount = donorCounts[bloodType] ?? 0;

                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    bloodType,
                                    style: const TextStyle(
                                      fontFamily: AppFonts.raleway,
                                      fontSize: 20,
                                      fontWeight: AppFonts.bold,
                                      color: Color(0xFFE11E37),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Requests: $requestCount',
                                    style: const TextStyle(
                                      fontFamily: AppFonts.sfPro,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'Donors: $donorCount',
                                    style: const TextStyle(
                                      fontFamily: AppFonts.sfPro,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
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
      ),
      // Requests Tab
      const RequestsTab(),
      // Donors Tab
      const DonorsTab(),
      // Donations Tab
      const DonationsTab(),
    ];

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authService.user?.displayName ?? 'User',
                    style: const TextStyle(
                      fontFamily: AppFonts.raleway,
                      fontSize: 20,
                      fontWeight: AppFonts.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    authService.user?.email ?? '',
                    style: const TextStyle(
                      fontFamily: AppFonts.sfPro,
                      fontSize: 14,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(
                'Profile',
                style: TextStyle(fontFamily: AppFonts.sfPro),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UserProfileForm()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text(
                'Settings',
                style: TextStyle(fontFamily: AppFonts.sfPro),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings screen (to be implemented later)
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                'Logout',
                style: TextStyle(fontFamily: AppFonts.sfPro),
              ),
              onTap: () async {
                await authService.signOut();
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Donors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism),
            label: 'Donations',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.local_hospital, color: AppColors.white),
                        ),
                        title: const Text(
                          'Request for Blood',
                          style: TextStyle(fontFamily: AppFonts.sfPro),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const BloodRequestForm()),
                          );
                        },
                      ),
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.volunteer_activism, color: AppColors.white),
                        ),
                        title: const Text(
                          'Offer to Donate Blood',
                          style: TextStyle(fontFamily: AppFonts.sfPro),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const DonationOfferForm()),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: const Icon(Icons.add, color: AppColors.white),
        ),
      ),
    );
  }
}







