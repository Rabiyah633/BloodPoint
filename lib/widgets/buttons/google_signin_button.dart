import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_fonts.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE11E37)),
              ),
            )
          : const FaIcon(
              FontAwesomeIcons.google,
              color: Color(0xFFE11E37),
              size: 20,
            ),
      label: Text(
        text,
        style: TextStyle(
          fontFamily: AppFonts.sfPro,
          fontSize: 16,
          color: isLoading ? Colors.grey : const Color(0xFFE11E37),
          fontWeight: AppFonts.medium,
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.white,
        side: BorderSide(
          color: isLoading ? Colors.grey : const Color(0xFFE11E37),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(double.infinity, 50),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }
}