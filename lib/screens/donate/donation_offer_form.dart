import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_fonts.dart';

class DonationOfferForm extends StatelessWidget {
  const DonationOfferForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Offer to Donate Blood',
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Offer to Donate Blood',
                    style: TextStyle(
                      fontFamily: AppFonts.raleway,
                      fontSize: 28,
                      fontWeight: AppFonts.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      // Implement donation offer logic later
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: const Color(0xFFE11E37),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Submit Offer',
                      style: TextStyle(
                        fontFamily: AppFonts.sfPro,
                        fontSize: 18,
                        fontWeight: AppFonts.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}