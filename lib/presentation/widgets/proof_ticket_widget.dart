import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/candidate.dart';

/// Template visual bukti pilihan sesuai UI Kit Section 7
/// Di-render menjadi PNG beresolusi tinggi (acuan 1080 x 1350 px)
class ProofTicketWidget extends StatelessWidget {
  final CandidateWithNumber candidateWithNumber;
  final DateTime votedAt;
  final double width;

  const ProofTicketWidget({
    super.key,
    required this.candidateWithNumber,
    required this.votedAt,
    this.width = 540, // Skala render 540x675 (pada pixelRatio 2.0 menghasilkan 1080x1350 px)
  });

  static String formatDateIndonesian(DateTime dt) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  static String formatTimeIndonesian(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final candidate = candidateWithNumber.candidate;

    return Semantics(
      container: true,
      label: 'Bukti Pilihan: Calon terpilih ${candidate.name}, ${candidateWithNumber.accessibilityLabel}. Dicatat pada ${formatDateIndonesian(votedAt)}, pukul ${formatTimeIndonesian(votedAt)}.',
      child: Container(
        width: width,
        color: AppColors.background,
        padding: const EdgeInsets.all(AppSpacing.space6),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x10172033),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space6,
          vertical: AppSpacing.space8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo / Header Icon
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.how_to_vote_rounded,
                color: AppColors.primary,
                size: 28,
              ),
            ),

            const SizedBox(height: AppSpacing.space3),

            // Judul Bukti
            Text(
              'BUKTI PILIHAN',
              style: AppTypography.display.copyWith(
                fontSize: 22,
                letterSpacing: 1.2,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.space1),
            Text(
              'SIMULASI PEMILIHAN CALON',
              style: AppTypography.bodySmall.copyWith(
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: AppSpacing.space4),
            const Divider(color: AppColors.border, thickness: 1),
            const SizedBox(height: AppSpacing.space4),

            // Foto Calon Terpilih (Rasio 4:5)
            ClipRRect(
              borderRadius: AppSpacing.roundedLarge,
              child: SizedBox(
                width: 220,
                height: 275,
                child: Image.asset(
                  candidate.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, error, stackTrace) => Container(
                    color: AppColors.primarySoft,
                    child: const Icon(
                      Icons.person_rounded,
                      size: 80,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.space4),

            // Badge Nomor Urut
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space5,
                vertical: AppSpacing.space2,
              ),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: AppSpacing.roundedFull,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.space2),
                  Text(
                    'NOMOR URUT ${candidateWithNumber.formattedNumber}',
                    style: AppTypography.candidateNumber.copyWith(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.space3),

            // Nama Calon
            Text(
              candidate.name,
              style: AppTypography.h1.copyWith(fontSize: 22),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.space2),

            // Status Konfirmasi
            Text(
              'Pilihan berhasil dicatat pada perangkat ini.',
              style: AppTypography.body.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.space4),

            // Info Tanggal & Waktu Box (Menggunakan Wrap agar aman dari overflow pada berbagai ukuran layar)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space3,
                vertical: AppSpacing.space3,
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: AppSpacing.roundedMedium,
                border: Border.all(color: AppColors.border),
              ),
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: AppSpacing.space3,
                runSpacing: AppSpacing.space2,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 15, color: AppColors.textSecondary),
                      const SizedBox(width: AppSpacing.space1),
                      Text(
                        'Tanggal: ${formatDateIndonesian(votedAt)}',
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time_rounded, size: 15, color: AppColors.textSecondary),
                      const SizedBox(width: AppSpacing.space1),
                      Text(
                        'Waktu: ${formatTimeIndonesian(votedAt)}',
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.space5),

            // Catatan Disclaimer Simulasi Statis (UI Kit 7.2)
            Text(
              'Dokumen ini merupakan bukti simulasi dari aplikasi statis.',
              style: AppTypography.bodySmall.copyWith(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
  }
}
