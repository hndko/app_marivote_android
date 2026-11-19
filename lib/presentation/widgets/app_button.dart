import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

enum AppButtonVariant {
  primary,
  secondary,
  danger,
}

/// Komponen Reusable Tombol sesuai UI Kit Section 5.1 & 5.2
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final String? loadingLabel;
  final IconData? icon;
  final double height;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.loadingLabel,
    this.icon,
    this.height = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    final bool isInteractive = onPressed != null && !isLoading;

    if (variant == AppButtonVariant.primary) {
      return SizedBox(
        width: double.infinity,
        height: height,
        child: ElevatedButton(
          onPressed: isInteractive ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.disabled,
            disabledForegroundColor: Colors.white.withValues(alpha: 0.8),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: AppSpacing.roundedMedium,
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
          ),
          child: _buildContent(Colors.white),
        ),
      );
    } else if (variant == AppButtonVariant.secondary) {
      return SizedBox(
        width: double.infinity,
        height: height,
        child: OutlinedButton(
          onPressed: isInteractive ? onPressed : null,
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            disabledBackgroundColor: AppColors.surface,
            disabledForegroundColor: AppColors.disabled,
            side: const BorderSide(color: AppColors.border, width: 1),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: AppSpacing.roundedMedium,
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
          ),
          child: _buildContent(AppColors.textPrimary),
        ),
      );
    } else {
      // Danger variant
      return SizedBox(
        width: double.infinity,
        height: height,
        child: ElevatedButton(
          onPressed: isInteractive ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.danger,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.disabled,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: AppSpacing.roundedMedium,
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
          ),
          child: _buildContent(Colors.white),
        ),
      );
    }
  }

  Widget _buildContent(Color textColor) {
    if (isLoading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          ),
          const SizedBox(width: AppSpacing.space3),
          Text(
            loadingLabel ?? 'Memproses...',
            style: AppTypography.button.copyWith(color: textColor),
          ),
        ],
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: textColor),
          const SizedBox(width: AppSpacing.space2),
          Text(
            label,
            style: AppTypography.button.copyWith(color: textColor),
          ),
        ],
      );
    }

    return Text(
      label,
      style: AppTypography.button.copyWith(color: textColor),
    );
  }
}
