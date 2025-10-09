import 'package:flutter/material.dart';
import 'package:myapp/core/constants/colors.dart';
import 'package:myapp/core/constants/typography.dart';
import 'package:myapp/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';



class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo Section
                Center(
                  child: Image.asset(
                    'assets/images/butcheelogo.png',
                    height: 120,
                    width: 120,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 60),

                // Email/Phone Input
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightGray.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Email / Phone',
                      labelStyle: AppTypography.caption.copyWith(
                        color: AppColors.textGrey,
                        fontSize: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.lightGray.withOpacity(0.5),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Password Input
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightGray.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: AppTypography.caption.copyWith(
                        color: AppColors.textGrey,
                        fontSize: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.lightGray.withOpacity(0.5),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Login Button
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.home);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Login',
                      style: AppTypography.button.copyWith(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Forgot Password
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.forgotPassword);


                  },
                  child: Text(
                    'Forgot Password?',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primaryRed.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Divider with "or"
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppColors.neutralGray.withOpacity(0.5),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'or',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textGrey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppColors.neutralGray.withOpacity(0.5),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Social Login Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Apple Login
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.lightGray.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          // Replace with your actual Apple Sign In URL or account
                          _launchUrl('https://appleid.apple.com/');
                        },
                        icon: Icon(
                          Icons.apple,
                          color: AppColors.primaryRed.withOpacity(0.7),
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Google Login
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.lightGray.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          // Replace with your actual Google account URL
                          _launchUrl('https://accounts.google.com/');
                        },
                        icon: Text(
                          'G',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryRed.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Phone Login
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.lightGray.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          // Replace with your actual phone auth URL or functionality
                          _launchUrl('tel:');
                        },
                        icon: Icon(
                          Icons.phone,
                          color: AppColors.primaryRed.withOpacity(0.7),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Create Account
                TextButton(
                  onPressed: () {
                   Navigator.pushNamed(context, AppRoutes.register);

                  },
                  child: Text(
                    'Create Account',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primaryRed.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
