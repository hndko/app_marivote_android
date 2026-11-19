import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../services/proof_export_service.dart';
import '../controllers/election_controller.dart';
import '../widgets/app_button.dart';
import '../widgets/proof_ticket_widget.dart';

/// Halaman Hasil Pemilihan & Unduh Bukti sesuai UI Kit Section 6.3 & 6.4
class ElectionResultScreen extends StatefulWidget {
  final ElectionController controller;
  final ProofExportService? proofExportService;

  const ElectionResultScreen({
    super.key,
    required this.controller,
    this.proofExportService,
  });

  @override
  State<ElectionResultScreen> createState() => _ElectionResultScreenState();
}

class _ElectionResultScreenState extends State<ElectionResultScreen> {
  final GlobalKey _proofBoundaryKey = GlobalKey();
  late final ProofExportService _proofExportService;

  bool _isDownloading = false;
  bool _isSharing = false;
  bool _hasDownloaded = false;
  Uint8List? _cachedProofBytes;

  @override
  void initState() {
    super.initState();
    _proofExportService = widget.proofExportService ?? ProofExportService();
  }

  Future<Uint8List?> _getOrCaptureProofBytes() async {
    if (_cachedProofBytes != null) return _cachedProofBytes;

    final bytes = await _proofExportService.captureWidget(_proofBoundaryKey);
    if (bytes != null) {
      _cachedProofBytes = bytes;
    }
    return bytes;
  }

  Future<void> _handleDownloadProof() async {
    if (_isDownloading) return;

    setState(() {
      _isDownloading = true;
    });

    widget.controller.updateProofState(ElectionState.generatingProof);

    try {
      final bytes = await _getOrCaptureProofBytes();
      if (bytes == null) {
        if (!mounted) return;
        _showSnackbar('Gagal membuat gambar bukti. Silakan coba lagi.', isError: true);
        widget.controller.updateProofState(ElectionState.proofSaveFailed);
        return;
      }

      widget.controller.updateProofState(ElectionState.savingProof);
      final votedAt = widget.controller.votedAt ?? DateTime.now();

      final result = await _proofExportService.saveToGallery(bytes, votedAt);

      if (!mounted) return;

      if (result.isSuccess) {
        setState(() {
          _hasDownloaded = true;
        });
        widget.controller.updateProofState(ElectionState.proofSaved);
        _showSnackbar(
          result.message,
          isError: false,
          actionLabel: 'Buka Galeri',
          onAction: () async {
            try {
              await Gal.open();
            } catch (_) {}
          },
        );
      } else {
        widget.controller.updateProofState(ElectionState.proofSaveFailed);
        _showSnackbar(result.message, isError: true);
      }
    } catch (_) {
      if (!mounted) return;
      widget.controller.updateProofState(ElectionState.proofSaveFailed);
      _showSnackbar('Bukti belum berhasil disimpan. Silakan coba lagi.', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  Future<void> _handleShareProof() async {
    if (_isSharing) return;

    setState(() {
      _isSharing = true;
    });

    try {
      final bytes = await _getOrCaptureProofBytes();
      if (bytes == null) {
        if (!mounted) return;
        _showSnackbar('Gagal menyiapkan gambar bukti untuk dibagikan.', isError: true);
        return;
      }

      final votedAt = widget.controller.votedAt ?? DateTime.now();
      await _proofExportService.shareProof(bytes, votedAt);
    } catch (_) {
      if (!mounted) return;
      _showSnackbar('Gagal membagikan bukti.', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  void _showSnackbar(
    String message, {
    required bool isError,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline_rounded : Icons.check_circle_rounded,
              color: isError ? AppColors.danger : AppColors.success,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.space2),
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: AppColors.primary,
                onPressed: onAction,
              )
            : null,
        backgroundColor: isError ? AppColors.dangerSoft : AppColors.successSoft,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _confirmResetSession() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Mulai Simulasi Baru?'),
        content: const Text(
          'Status pemilihan saat ini akan dihapus dan nomor urut kedua calon akan diacak ulang untuk simulasi baru.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await widget.controller.resetSessionForNewSimulation();
            },
            child: const Text('Mulai Baru'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.controller.selectedCandidate;
    final votedAt = widget.controller.votedAt ?? DateTime.now();

    if (selected == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Hasil Pilihan')),
        body: const Center(
          child: Text('Belum ada pilihan yang dicatat.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Hasil Pilihan'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Bagikan Bukti',
            icon: const Icon(Icons.share_outlined),
            onPressed: _isSharing ? null : _handleShareProof,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space5,
            vertical: AppSpacing.space4,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Ikon Check Sukses Lingkaran Hijau (UI Kit 6.3)
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: AppColors.successSoft,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.success,
                        size: 40,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.space4),

                  // Judul & Pesan Hasil (Microcopy UI Kit Section 10)
                  Text(
                    'Pilihan Berhasil Disimpan',
                    style: AppTypography.h1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.space2),
                  Text(
                    'Terima kasih. Pilihan Anda telah berhasil dicatat pada perangkat ini.',
                    style: AppTypography.bodySecondary,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.space6),

                  // Tampilan Template Bukti Gambar (Dipakai juga untuk Capture RepaintBoundary)
                  Center(
                    child: RepaintBoundary(
                      key: _proofBoundaryKey,
                      child: ProofTicketWidget(
                        candidateWithNumber: selected,
                        votedAt: votedAt,
                        width: 500,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.space6),

                  // Tombol Utama: Unduh Bukti (UI Kit 6.4)
                  AppButton(
                    label: _hasDownloaded ? 'Unduh Ulang Bukti' : 'Unduh Bukti',
                    icon: Icons.download_rounded,
                    isLoading: _isDownloading,
                    loadingLabel: 'Menyiapkan Bukti...',
                    onPressed: _isDownloading ? null : _handleDownloadProof,
                    height: 52,
                  ),

                  const SizedBox(height: AppSpacing.space3),

                  // Tombol Sekunder: Bagikan Bukti (FR-13 / Grill-me decision)
                  AppButton(
                    label: 'Bagikan Bukti',
                    variant: AppButtonVariant.secondary,
                    icon: Icons.share_rounded,
                    isLoading: _isSharing,
                    loadingLabel: 'Menyiapkan...',
                    onPressed: _isSharing ? null : _handleShareProof,
                    height: 48,
                  ),

                  const SizedBox(height: AppSpacing.space4),

                  const Divider(color: AppColors.border),

                  const SizedBox(height: AppSpacing.space4),

                  // Tombol Mulai Simulasi Baru / Reset
                  AppButton(
                    label: 'Mulai Simulasi Baru / Reset',
                    variant: AppButtonVariant.secondary,
                    icon: Icons.refresh_rounded,
                    onPressed: _confirmResetSession,
                    height: 48,
                  ),

                  const SizedBox(height: AppSpacing.space4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
