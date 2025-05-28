import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_fonts.dart';
import '../../services/auth_service.dart';
import '../auth/sign_up_screen.dart';
import '../home/home_screen.dart';
import '../profile/user_profile_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
  if (_formKey.currentState!.validate()) {
    final authService = Provider.of<AuthService>(context, listen: false);
    bool success = await authService.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    if (success && mounted) {
      await Future.delayed(const Duration(milliseconds: 500));
      final user = authService.user;
      if (user != null) {
        final profile = await authService.getUserProfile(user.uid);
        if (profile == null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const UserProfileForm()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      }
    }
  }
}

Future<void> _signInWithGoogle() async {
  final authService = Provider.of<AuthService>(context, listen: false);
  bool success = await authService.signInWithGoogle();
  if (success && mounted) {
    await Future.delayed(const Duration(milliseconds: 500));
    final user = authService.user;
    if (user != null) {
      final profile = await authService.getUserProfile(user.uid);
      if (profile == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const UserProfileForm()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    }
  }
}

  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email to reset password')),
      );
      return;
    }
    final authService = Provider.of<AuthService>(context, listen: false);
    bool success = await authService.resetPassword(_emailController.text.trim());
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent! Check your inbox.')),
      );
    }
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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Consumer<AuthService>(
                builder: (context, authService, child) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // App Logo or Title
                        Text(
                          AppStrings.appName,
                          style: const TextStyle(
                            fontFamily: AppFonts.raleway,
                            fontSize: 36,
                            fontWeight: AppFonts.bold,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: AppColors.white,
                            hintText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: AppColors.white,
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        // Forgot Password Link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _resetPassword,
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontFamily: AppFonts.sfPro,
                                color: AppColors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Login Button
                        authService.isLoading
                            ? const CircularProgressIndicator(
                                color: AppColors.white,
                              )
                            : ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.white,
                                  foregroundColor: const Color(0xFFE11E37),
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontFamily: AppFonts.sfPro,
                                    fontSize: 18,
                                    fontWeight: AppFonts.bold,
                                  ),
                                ),
                              ),
                        const SizedBox(height: 16),
                        // Google Sign-In Button
                        authService.isLoading
                            ? const SizedBox.shrink()
                            : OutlinedButton.icon(
                                onPressed: _signInWithGoogle,
                                icon: const Icon(Icons.g_mobiledata,
                                    color: Color(0xFFE11E37)),
                                label: const Text(
                                  'Login with Google',
                                  style: TextStyle(
                                    fontFamily: AppFonts.sfPro,
                                    fontSize: 16,
                                    color: Color(0xFFE11E37),
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFE11E37)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  minimumSize: const Size(double.infinity, 50),
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
                        const SizedBox(height: 16),
                        // Navigate to Sign Up
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don’t have an account? ',
                              style: TextStyle(
                                fontFamily: AppFonts.sfPro,
                                color: AppColors.white,
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => const SignUpScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontFamily: AppFonts.sfPro,
                                  color: AppColors.white,
                                  fontSize: 14,
                                  fontWeight: AppFonts.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}