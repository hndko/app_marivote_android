import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/candidate.dart';
import 'app_button.dart';

/// Komponen Reusable Candidate Card sesuai UI Kit Section 5.3 & 5.4
class CandidateCard extends StatelessWidget {
  final CandidateWithNumber candidateWithNumber;
  final VoidCallback onSelect;
  final bool isSelected;
  final bool isSelectionDisabled;

  const CandidateCard({
    super.key,
    required this.candidateWithNumber,
    required this.onSelect,
    this.isSelected = false,
    this.isSelectionDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final candidate = candidateWithNumber.candidate;

    return Semantics(
      container: true,
      label: 'Calon ${candidateWithNumber.accessibilityLabel}, ${candidate.name}',
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppSpacing.roundedLarge,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08172033),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Foto Calon (Rasio 4:5, radius 12 dp)
            ClipRRect(
              borderRadius: AppSpacing.roundedMedium,
              child: AspectRatio(
                aspectRatio: 4 / 5,
                child: Image.asset(
                  candidate.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback sesuai UI Kit Section 5.8
                    return Container(
                      color: AppColors.primarySoft,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.person_rounded,
                              size: 64,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: AppSpacing.space2),
                            Text(
                              'Foto calon',
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.space3),

            // Badge Nomor Urut (UI Kit Section 5.4)
            Row(
              children: [
                Semantics(
                  label: candidateWithNumber.accessibilityLabel,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space3,
                      vertical: AppSpacing.space1,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: AppSpacing.roundedFull,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.how_to_vote_outlined,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.space1),
                        Text(
                          candidateWithNumber.formattedNumber,
                          style: AppTypography.candidateNumber.copyWith(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (candidate.description != null) ...[
                  const SizedBox(width: AppSpacing.space2),
                  Expanded(
                    child: Text(
                      candidate.description!,
                      style: AppTypography.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: AppSpacing.space2),

            // Nama Calon (H3 16 sp SemiBold, maks 2 baris)
            Text(
              candidate.name,
              style: AppTypography.h3,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: AppSpacing.space4),

            // Tombol Pilih
            AppButton(
              label: isSelected ? 'Terpilih' : 'Pilih',
              icon: isSelected ? Icons.check_circle_rounded : null,
              onPressed: isSelectionDisabled ? null : onSelect,
            ),
          ],
        ),
      ),
    );
  }
}
