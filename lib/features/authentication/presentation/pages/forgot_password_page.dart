import 'package:flutter/material.dart';
import 'package:myapp/core/constants/colors.dart';
import 'package:myapp/core/constants/typography.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo/Title Section
                Text(
                  'Butchee',
                  textAlign: TextAlign.center,
                  style: AppTypography.h1.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                // Subtitle
                Text(
                  'Forgot Password',
                  textAlign: TextAlign.center,
                  style: AppTypography.h2.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  'Enter your email address and we\'ll send you a link to reset your password',
                  textAlign: TextAlign.center,
                  style: AppTypography.caption.copyWith(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 40),

                // Email Input
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightGray.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
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

                // Reset Password Button
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle reset password
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Password reset link sent to your email',
                            style: AppTypography.body.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: AppColors.primaryRed,
                        ),
                      );
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
                      'Reset Password',
                      style: AppTypography.button.copyWith(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Back to Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Remember your password? ',
                      style: AppTypography.caption.copyWith(
                        fontSize: 14,
                        color: AppColors.textGrey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate back to login
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Sign In',
                        style: AppTypography.caption.copyWith(
                          fontSize: 14,
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
