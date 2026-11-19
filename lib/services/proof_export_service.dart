import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ProofExportResult {
  final bool isSuccess;
  final String message;
  final String? savedPath;

  const ProofExportResult({
    required this.isSuccess,
    required this.message,
    this.savedPath,
  });

  factory ProofExportResult.success({String? path, String? message}) {
    return ProofExportResult(
      isSuccess: true,
      message: message ?? 'Bukti pilihan berhasil disimpan ke perangkat.',
      savedPath: path,
    );
  }

  factory ProofExportResult.failure({String? message}) {
    return ProofExportResult(
      isSuccess: false,
      message: message ?? 'Bukti belum berhasil disimpan. Silakan coba lagi.',
    );
  }
}

/// Service untuk mengekspor, menyimpan ke galeri, dan membagikan bukti pilihan
class ProofExportService {
  /// Format penamaan file sesuai PRD Section 10.3: bukti-pilihan-YYYYMMDD-HHmmss.png
  static String generateFileName(DateTime dt) {
    final year = dt.year.toString().padLeft(4, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    final second = dt.second.toString().padLeft(2, '0');

    return 'bukti-pilihan-$year$month$day-$hour$minute$second.png';
  }

  /// Mengambil tangkapan pixel dari widget RepaintBoundary menjadi byte PNG
  Future<Uint8List?> captureWidget(GlobalKey boundaryKey, {double pixelRatio = 2.0}) async {
    try {
      final boundary = boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  /// Menyimpan byte gambar ke Galeri / Pictures Android
  Future<ProofExportResult> saveToGallery(Uint8List imageBytes, DateTime votedAt) async {
    try {
      final fileName = generateFileName(votedAt);

      // Pastikan izin akses galeri tersedia
      final hasAccess = await Gal.hasPermission();
      if (!hasAccess) {
        final granted = await Gal.requestPermission();
        if (!granted) {
          return ProofExportResult.failure(
            message: 'Izin penyimpanan ditolak. Harap izinkan akses untuk menyimpan bukti.',
          );
        }
      }

      final rawName = fileName.replaceAll('.png', '');
      await Gal.putImageBytes(imageBytes, name: rawName);

      return ProofExportResult.success(
        path: fileName,
        message: 'Bukti pilihan berhasil disimpan ke perangkat.',
      );
    } on GalException catch (e) {
      return ProofExportResult.failure(
        message: 'Gagal menyimpan bukti: ${e.type.message}',
      );
    } catch (e) {
      return ProofExportResult.failure(
        message: 'Bukti belum berhasil disimpan. Silakan coba lagi.',
      );
    }
  }

  /// Membagikan gambar bukti melalui Android native share sheet
  Future<bool> shareProof(Uint8List imageBytes, DateTime votedAt) async {
    try {
      final fileName = generateFileName(votedAt);
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$fileName');
      await tempFile.writeAsBytes(imageBytes);

      final xFile = XFile(tempFile.path, mimeType: 'image/png');
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [xFile],
          text: 'Bukti Pilihan - Simulasi Pemilihan Calon',
          subject: 'Bukti Pilihan Calon',
        ),
      );

      return result.status == ShareResultStatus.success ||
          result.status == ShareResultStatus.dismissed;
    } catch (_) {
      return false;
    }
  }
}
