import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_fonts.dart';
import '../auth/sign_up_screen.dart'; // We'll create this next

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _navigateToSignUp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE11E37), Color(0xFFE2465B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button (optional)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton(
                    onPressed: _navigateToSignUp,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontFamily: AppFonts.sfPro,
                        fontSize: 16,
                        color: AppColors.white,
                        fontWeight: AppFonts.regular,
                      ),
                    ),
                  ),
                ),
              ),
              // PageView for onboarding pages
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  children: const [
                    OnboardingPage(
                      title: 'Welcome to ${AppStrings.appName}',
                      description:
                          'Join us in saving lives by donating blood or requesting blood when in need.',
                      image: Icons.bloodtype_rounded,
                    ),
                    OnboardingPage(
                      title: 'Donate Blood, Save Lives',
                      description:
                          'Your blood donation can make a difference. Be a hero today!',
                      image: Icons.favorite,
                    ),
                    OnboardingPage(
                      title: 'Find Donors Easily',
                      description:
                          'Connect with donors and request blood anytime, anywhere.',
                      image: Icons.people,
                    ),
                  ],
                ),
              ),
              // Page indicator
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: const WormEffect(
                    dotColor: AppColors.white,
                    activeDotColor: Color(0xFFE11E37),
                    dotHeight: 8,
                    dotWidth: 8,
                  ),
                ),
              ),
              // Get Started button on the last page
              if (_currentPage == 2)
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0, left: 16.0, right: 16.0),
                  child: ElevatedButton(
                    onPressed: _navigateToSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: const Color(0xFFE11E37),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontFamily: AppFonts.sfPro,
                        fontSize: 18,
                        fontWeight: AppFonts.bold,
                        color: Color(0xFFE11E37),
                      ),
                    ),
                  ),
                )
              else
                const SizedBox(height: 82), // Placeholder space for consistency
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData image;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Placeholder for image/icon
          Icon(
            image,
            size: 120,
            color: AppColors.white,
          ),
          const SizedBox(height: 32),
          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.raleway,
              fontSize: 28,
              fontWeight: AppFonts.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 16),
          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.sfPro,
              fontSize: 16,
              fontWeight: AppFonts.regular,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}