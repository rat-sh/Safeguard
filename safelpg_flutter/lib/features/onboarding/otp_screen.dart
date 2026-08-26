import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/safe_lpg_button.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppTheme.textPrimary, size: 28),
          onPressed: () {
            if (context.canPop()) context.pop();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFCCFBF1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(
                    Icons.phone_outlined,
                    color: AppTheme.primary,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Verify your number',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 15,
                    color: AppTheme.textSecondary,
                  ),
                  children: [
                    TextSpan(text: 'Enter the 6-digit code sent to\n'),
                    TextSpan(
                      text: '+91 98765 43210',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // OTP Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildOtpBox('4', true),
                  const SizedBox(width: 12),
                  _buildOtpBox('2', true),
                  const SizedBox(width: 12),
                  _buildOtpBox('7', true),
                  const SizedBox(width: 12),
                  _buildOtpBox('1', true),
                  const SizedBox(width: 12),
                  _buildOtpBox('', false),
                  const SizedBox(width: 12),
                  _buildOtpBox('', false),
                ],
              ),
              const SizedBox(height: 32),
              
              // Timer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.access_time, size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 4),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                      children: [
                        TextSpan(text: 'Resend OTP in '),
                        TextSpan(
                          text: '0:42',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              SafeLPGButton(
                text: 'Verify & Continue',
                onPressed: () => context.go('/dashboard'),
                variant: ButtonVariant.primary,
              ),
              
              const SizedBox(height: 16),
              Center(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                    children: [
                      TextSpan(text: 'Having trouble? '),
                      TextSpan(
                        text: 'Contact support',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(String digit, bool filled) {
    return Container(
      width: 48,
      height: 56,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: filled ? AppTheme.primary : AppTheme.border,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          digit.isEmpty ? '·' : digit,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: filled ? AppTheme.textPrimary : AppTheme.disabled,
          ),
        ),
      ),
    );
  }
}
