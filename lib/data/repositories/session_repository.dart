import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/candidate.dart';

/// Data sesi pemilihan yang disimpan secara lokal
class ElectionSessionData {
  final List<CandidateWithNumber> candidates;
  final CandidateWithNumber? selectedCandidate;
  final DateTime? votedAt;

  const ElectionSessionData({
    required this.candidates,
    this.selectedCandidate,
    this.votedAt,
  });

  bool get hasVoted => selectedCandidate != null;
}

/// Repositori untuk mengelola persistensi sesi pemilihan ke SharedPreferences
class SessionRepository {
  static const String _keyCandidates = 'marivote_session_candidates';
  static const String _keySelectedCandidate = 'marivote_selected_candidate';
  static const String _keyVotedAt = 'marivote_voted_at';

  final SharedPreferences? _prefs;

  SessionRepository({SharedPreferences? prefs}) : _prefs = prefs;

  Future<SharedPreferences> _getPrefs() async {
    return _prefs ?? await SharedPreferences.getInstance();
  }

  /// Membaca sesi yang tersimpan
  Future<ElectionSessionData?> loadSession() async {
    final prefs = await _getPrefs();
    final candidatesJson = prefs.getString(_keyCandidates);
    if (candidatesJson == null) return null;

    try {
      final List<dynamic> decodedList = jsonDecode(candidatesJson);
      final candidates = decodedList
          .map((item) => CandidateWithNumber.fromJson(item as Map<String, dynamic>))
          .toList();

      CandidateWithNumber? selected;
      final selectedJson = prefs.getString(_keySelectedCandidate);
      if (selectedJson != null) {
        selected = CandidateWithNumber.fromJson(jsonDecode(selectedJson));
      }

      DateTime? votedAt;
      final votedAtStr = prefs.getString(_keyVotedAt);
      if (votedAtStr != null) {
        votedAt = DateTime.tryParse(votedAtStr);
      }

      return ElectionSessionData(
        candidates: candidates,
        selectedCandidate: selected,
        votedAt: votedAt,
      );
    } catch (_) {
      return null;
    }
  }

  /// Menyimpan sesi pemilihan
  Future<void> saveSession({
    required List<CandidateWithNumber> candidates,
    CandidateWithNumber? selectedCandidate,
    DateTime? votedAt,
  }) async {
    final prefs = await _getPrefs();
    final candidatesJson = jsonEncode(candidates.map((c) => c.toJson()).toList());
    await prefs.setString(_keyCandidates, candidatesJson);

    if (selectedCandidate != null) {
      await prefs.setString(_keySelectedCandidate, jsonEncode(selectedCandidate.toJson()));
    } else {
      await prefs.remove(_keySelectedCandidate);
    }

    if (votedAt != null) {
      await prefs.setString(_keyVotedAt, votedAt.toIso8601String());
    } else {
      await prefs.remove(_keyVotedAt);
    }
  }

  /// Menghapus sesi untuk memulai simulasi baru
  Future<void> clearSession() async {
    final prefs = await _getPrefs();
    await prefs.remove(_keyCandidates);
    await prefs.remove(_keySelectedCandidate);
    await prefs.remove(_keyVotedAt);
  }
}
