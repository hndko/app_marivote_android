import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/candidate.dart';
import 'app_button.dart';

/// Dialog konfirmasi pilihan sesuai UI Kit Section 5.5 & Section 10
class ConfirmationDialog extends StatelessWidget {
  final CandidateWithNumber candidateWithNumber;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final bool isProcessing;

  const ConfirmationDialog({
    super.key,
    required this.candidateWithNumber,
    required this.onCancel,
    required this.onConfirm,
    this.isProcessing = false,
  });

  @override
  Widget build(BuildContext context) {
    final candidate = candidateWithNumber.candidate;

    return PopScope(
      canPop: !isProcessing,
      child: Dialog(
        backgroundColor: AppColors.surface,
        elevation: AppSpacing.elevationDialog,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.roundedXLarge,
        ),
        insetPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space5,
          vertical: AppSpacing.space6,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.space6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Dialog
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.space2),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.help_outline_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.space3),
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(
                        'Konfirmasi Pilihan',
                        style: AppTypography.h2.copyWith(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.space4),

              // Highlight Box Calon Terpilih
              Container(
                padding: const EdgeInsets.all(AppSpacing.space3),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: AppSpacing.roundedMedium,
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Row(
                  children: [
                    // Foto thumbnail
                    ClipRRect(
                      borderRadius: AppSpacing.roundedSmall,
                      child: SizedBox(
                        width: 52,
                        height: 65,
                        child: Image.asset(
                          candidate.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, error, stackTrace) => Container(
                            color: AppColors.primarySoft,
                            child: const Icon(
                              Icons.person_rounded,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.space3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.space2,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft,
                              borderRadius: AppSpacing.roundedFull,
                            ),
                            child: Text(
                              'Nomor Urut ${candidateWithNumber.formattedNumber}',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.space1),
                          Text(
                            candidate.name,
                            style: AppTypography.h3.copyWith(fontSize: 15),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.space4),

              // Teks Penjelasan (Sesuai Microcopy UI Kit)
              Text(
                'Apakah Anda yakin ingin memilih ${candidate.name} dengan nomor urut ${candidateWithNumber.formattedNumber}? '
                'Pastikan pilihan Anda sudah benar. Setelah dikonfirmasi, pilihan akan ditetapkan pada aplikasi ini.',
                style: AppTypography.bodySecondary,
              ),

              const SizedBox(height: AppSpacing.space6),

              // Tombol Tindakan
              Row(
                children: [
                  // Tombol Kembali
                  Expanded(
                    child: AppButton(
                      label: 'Kembali',
                      variant: AppButtonVariant.secondary,
                      onPressed: isProcessing ? null : onCancel,
                      height: 48,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.space3),
                  // Tombol Ya, Pilih
                  Expanded(
                    child: AppButton(
                      label: 'Ya, Pilih',
                      variant: AppButtonVariant.primary,
                      isLoading: isProcessing,
                      loadingLabel: 'Memproses...',
                      onPressed: isProcessing ? null : onConfirm,
                      height: 48,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
