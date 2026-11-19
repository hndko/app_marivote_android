import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../data/models/candidate.dart';
import '../../data/repositories/candidate_repository.dart';
import '../../data/repositories/session_repository.dart';

/// Enum state aplikasi sesuai UI Kit Section 9.1
enum ElectionState {
  notSelected,
  confirming,
  processingSelection,
  selected,
  generatingProof,
  savingProof,
  proofSaved,
  proofSaveFailed,
}

class ElectionController extends ChangeNotifier {
  final CandidateRepository _candidateRepository;
  final SessionRepository _sessionRepository;

  List<CandidateWithNumber> _candidates = [];
  CandidateWithNumber? _candidateUnderConfirmation;
  CandidateWithNumber? _selectedCandidate;
  DateTime? _votedAt;
  ElectionState _state = ElectionState.notSelected;
  bool _isInitialized = false;

  ElectionController({
    CandidateRepository? candidateRepository,
    SessionRepository? sessionRepository,
  })  : _candidateRepository = candidateRepository ?? CandidateRepository(),
        _sessionRepository = sessionRepository ?? SessionRepository();

  List<CandidateWithNumber> get candidates => List.unmodifiable(_candidates);
  CandidateWithNumber? get candidateUnderConfirmation => _candidateUnderConfirmation;
  CandidateWithNumber? get selectedCandidate => _selectedCandidate;
  DateTime? get votedAt => _votedAt;
  ElectionState get state => _state;
  bool get isInitialized => _isInitialized;
  bool get hasVoted => _selectedCandidate != null;

  /// Inisialisasi sesi pemilihan (memuat sesi tersimpan atau mengacak nomor baru)
  Future<void> initialize({AssetBundle? bundle}) async {
    await _candidateRepository.loadFromAsset(bundle: bundle);
    final savedSession = await _sessionRepository.loadSession();

    if (savedSession != null && savedSession.candidates.isNotEmpty) {
      _candidates = savedSession.candidates;
      _selectedCandidate = savedSession.selectedCandidate;
      _votedAt = savedSession.votedAt;
      _state = _selectedCandidate != null ? ElectionState.selected : ElectionState.notSelected;
    } else {
      // Mulai sesi baru dengan nomor urut teracak
      _candidates = _candidateRepository.randomizeCandidateNumbers();
      _selectedCandidate = null;
      _votedAt = null;
      _state = ElectionState.notSelected;
      await _sessionRepository.saveSession(candidates: _candidates);
    }

    _isInitialized = true;
    notifyListeners();
  }

  /// Pengguna menekan tombol "Pilih" pada salah satu calon
  void selectCandidateForConfirmation(CandidateWithNumber candidate) {
    if (hasVoted) return; // FR-12: Tidak dapat memilih lagi jika sudah ditetapkan

    _candidateUnderConfirmation = candidate;
    _state = ElectionState.confirming;
    notifyListeners();
  }

  /// Pengguna menekan tombol "Kembali" pada dialog konfirmasi
  void cancelConfirmation() {
    _candidateUnderConfirmation = null;
    _state = ElectionState.notSelected;
    notifyListeners();
  }

  /// Pengguna menekan "Ya, Pilih" untuk menetapkan pilihan
  Future<void> confirmSelection() async {
    if (_candidateUnderConfirmation == null || hasVoted) return;

    _state = ElectionState.processingSelection;
    notifyListeners();

    // Simulasi delay singkat 200ms untuk UI smoothness
    await Future.delayed(const Duration(milliseconds: 200));

    _selectedCandidate = _candidateUnderConfirmation;
    _candidateUnderConfirmation = null;
    _votedAt = DateTime.now();
    _state = ElectionState.selected;

    await _sessionRepository.saveSession(
      candidates: _candidates,
      selectedCandidate: _selectedCandidate,
      votedAt: _votedAt,
    );

    notifyListeners();
  }

  /// Mengupdate status saat proses bukti berlangsung
  void updateProofState(ElectionState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Mereset sesi pemilihan untuk memulai simulasi baru
  Future<void> resetSessionForNewSimulation() async {
    await _sessionRepository.clearSession();
    _candidates = _candidateRepository.randomizeCandidateNumbers();
    _selectedCandidate = null;
    _candidateUnderConfirmation = null;
    _votedAt = null;
    _state = ElectionState.notSelected;
    await _sessionRepository.saveSession(candidates: _candidates);
    notifyListeners();
  }
}
