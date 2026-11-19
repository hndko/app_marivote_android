import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/candidate.dart';
import '../controllers/election_controller.dart';
import '../widgets/candidate_card.dart';
import '../widgets/confirmation_dialog.dart';
import 'election_result_screen.dart';

/// Halaman Utama Pemilihan sesuai UI Kit Section 6.1
class HomeElectionScreen extends StatefulWidget {
  final ElectionController controller;

  const HomeElectionScreen({
    super.key,
    required this.controller,
  });

  @override
  State<HomeElectionScreen> createState() => _HomeElectionScreenState();
}

class _HomeElectionScreenState extends State<HomeElectionScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerUpdate);
    if (!widget.controller.isInitialized) {
      widget.controller.initialize();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerUpdate);
    super.dispose();
  }

  void _onControllerUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  void _showConfirmationDialog(CandidateWithNumber candidate) {
    widget.controller.selectCandidateForConfirmation(candidate);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return ListenableBuilder(
          listenable: widget.controller,
          builder: (context, _) {
            final isProcessing =
                widget.controller.state == ElectionState.processingSelection;

            return ConfirmationDialog(
              candidateWithNumber: candidate,
              isProcessing: isProcessing,
              onCancel: () {
                widget.controller.cancelConfirmation();
                Navigator.of(dialogContext).pop();
              },
              onConfirm: () async {
                await widget.controller.confirmSelection();
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.controller.isInitialized) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      );
    }

    // Jika pengguna sudah menetapkan pilihan, tampilkan Halaman Hasil secara reaktif
    if (widget.controller.hasVoted) {
      return ElectionResultScreen(controller: widget.controller);
    }

    final candidates = widget.controller.candidates;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pemilihan Calon'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.space4),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space2,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: AppSpacing.roundedFull,
                ),
                child: Text(
                  'Simulasi Statis',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWideScreen = constraints.maxWidth >= 600;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space5,
                vertical: AppSpacing.space4,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Section (UI Kit 6.1)
                      Text(
                        'Pilih Calon Anda',
                        style: AppTypography.h1,
                      ),
                      const SizedBox(height: AppSpacing.space2),
                      Text(
                        'Silakan perhatikan informasi calon sebelum menentukan pilihan.',
                        style: AppTypography.bodySecondary,
                      ),

                      const SizedBox(height: AppSpacing.space5),

                      // Daftar Calon (Responsif: Vertikal di mobile, 2 kolom di layar lebar)
                      if (isWideScreen)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CandidateCard(
                                candidateWithNumber: candidates[0],
                                onSelect: () => _showConfirmationDialog(candidates[0]),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.space4),
                            Expanded(
                              child: CandidateCard(
                                candidateWithNumber: candidates[1],
                                onSelect: () => _showConfirmationDialog(candidates[1]),
                              ),
                            ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            CandidateCard(
                              candidateWithNumber: candidates[0],
                              onSelect: () => _showConfirmationDialog(candidates[0]),
                            ),
                            const SizedBox(height: AppSpacing.space4),
                            CandidateCard(
                              candidateWithNumber: candidates[1],
                              onSelect: () => _showConfirmationDialog(candidates[1]),
                            ),
                          ],
                        ),

                      const SizedBox(height: AppSpacing.space6),

                      // Catatan Bawah (UI Kit 6.1)
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.space3),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft.withValues(alpha: 0.5),
                          borderRadius: AppSpacing.roundedMedium,
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: AppSpacing.space2),
                            Expanded(
                              child: Text(
                                'Pastikan pilihan Anda sudah benar sebelum menekan tombol konfirmasi.',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.space4),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
