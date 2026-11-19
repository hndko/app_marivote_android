import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/candidate.dart';

/// Repositori data calon lokal dan logika pengacakan nomor urut
class CandidateRepository {
  List<Candidate> _candidates;
  final Random _random;

  static const List<Candidate> defaultFallbackCandidates = [
    Candidate(
      id: 'candidate_a',
      name: 'Ahmad Pratama',
      image: 'assets/images/calon_a.png',
      description: 'Calon Pertama',
    ),
    Candidate(
      id: 'candidate_b',
      name: 'Siti Rahmawati',
      image: 'assets/images/calon_b.png',
      description: 'Calon Kedua',
    ),
  ];

  CandidateRepository({
    List<Candidate>? candidates,
    Random? random,
  })  : _candidates = candidates ?? defaultFallbackCandidates,
        _random = random ?? Random();

  /// Mengambil daftar calon mentah (tepat dua calon)
  List<Candidate> getRawCandidates() {
    return List.unmodifiable(_candidates);
  }

  /// Memuat data calon dari file JSON asset (misal: `assets/candidates.json`)
  /// Jika file tidak ditemukan atau format tidak sesuai, repositori mempertahankan data default.
  Future<void> loadFromAsset({
    AssetBundle? bundle,
    String assetPath = 'assets/candidates.json',
  }) async {
    try {
      final actualBundle = bundle ?? rootBundle;
      final jsonString = await actualBundle.loadString(assetPath);
      final dynamic decoded = jsonDecode(jsonString);

      if (decoded is List && decoded.length == 2) {
        _candidates = decoded
            .map((item) => Candidate.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Fallback tetap menggunakan _candidates yang sudah ada
    }
  }

  /// Mengacak nomor urut (1 dan 2) untuk kedua calon tanpa duplikasi
  /// Mengembalikan list [CandidateWithNumber] berurutan berdasarkan nomor urut (01 lalu 02)
  List<CandidateWithNumber> randomizeCandidateNumbers() {
    if (_candidates.length != 2) {
      throw StateError('Aplikasi mewajibkan tepat dua calon untuk pemilihan.');
    }

    final candidateA = _candidates[0];
    final candidateB = _candidates[1];

    // Acak siapa yang mendapat nomor 1 dan 2 (50% kemungkinan)
    final bool candidateAIsFirst = _random.nextBool();

    final item1 = CandidateWithNumber(
      candidate: candidateAIsFirst ? candidateA : candidateB,
      number: 1,
    );

    final item2 = CandidateWithNumber(
      candidate: candidateAIsFirst ? candidateB : candidateA,
      number: 2,
    );

    return [item1, item2];
  }
}
