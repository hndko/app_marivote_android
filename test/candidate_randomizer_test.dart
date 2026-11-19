import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:marivote/data/models/candidate.dart';
import 'package:marivote/data/repositories/candidate_repository.dart';

void main() {
  group('Candidate Model Tests', () {
    test('Candidate JSON serialization and deserialization works correctly', () {
      final candidate = Candidate(
        id: 'candidate_a',
        name: 'Ahmad Pratama',
        image: 'assets/images/calon_a.png',
        description: 'Calon Pertama',
      );

      final json = candidate.toJson();
      final fromJson = Candidate.fromJson(json);

      expect(fromJson.id, equals(candidate.id));
      expect(fromJson.name, equals(candidate.name));
      expect(fromJson.image, equals(candidate.image));
      expect(fromJson.description, equals(candidate.description));
      expect(fromJson, equals(candidate));
    });

    test('CandidateWithNumber formats number to two digits (01, 02)', () {
      const candidate = Candidate(
        id: 'test_1',
        name: 'Nama Test',
        image: 'assets/images/test.png',
      );

      const candidateWithNum1 = CandidateWithNumber(candidate: candidate, number: 1);
      const candidateWithNum2 = CandidateWithNumber(candidate: candidate, number: 2);

      expect(candidateWithNum1.formattedNumber, equals('01'));
      expect(candidateWithNum1.accessibilityLabel, equals('Nomor urut 01'));

      expect(candidateWithNum2.formattedNumber, equals('02'));
      expect(candidateWithNum2.accessibilityLabel, equals('Nomor urut 02'));

      final json = candidateWithNum1.toJson();
      final fromJson = CandidateWithNumber.fromJson(json);
      expect(fromJson, equals(candidateWithNum1));
    });
  });

  group('CandidateRepository & Randomizer Tests (PRD FR-01, FR-02, FR-03, TC-02)', () {
    test('Aplikasi memiliki tepat dua calon default', () {
      final repo = CandidateRepository();
      final candidates = repo.getRawCandidates();

      expect(candidates.length, equals(2));
      expect(candidates[0].id, equals('candidate_a'));
      expect(candidates[0].name, equals('Ahmad Pratama'));
      expect(candidates[1].id, equals('candidate_b'));
      expect(candidates[1].name, equals('Siti Rahmawati'));
    });

    test('Pengacakan nomor urut selalu menghasilkan tepat 2 calon bernomor 1 dan 2 tanpa duplikasi', () {
      final repo = CandidateRepository();

      for (int i = 0; i < 50; i++) {
        final assigned = repo.randomizeCandidateNumbers();

        expect(assigned.length, equals(2));
        final numbers = assigned.map((c) => c.number).toList();
        expect(numbers, containsAll([1, 2]));
        expect(numbers[0], isNot(equals(numbers[1]))); // Tidak duplikat
        expect(assigned[0].candidate.id, isNot(equals(assigned[1].candidate.id)));
      }
    });

    test('Pengacakan dengan seeded random bekerja deterministik dan teracak', () {
      // Seed yang menghasilkan true pada panggilan pertama
      final random = Random(42);
      final repo = CandidateRepository(random: random);

      final session1 = repo.randomizeCandidateNumbers();
      expect(session1.length, equals(2));
      expect(session1[0].number, equals(1));
      expect(session1[1].number, equals(2));
    });

    test('Memastikan kedua calon memiliki peluang mendapatkan nomor urut 1 dan 2 dalam beberapa sesi (TC-02)', () {
      final repo = CandidateRepository();
      bool aGotNumberOne = false;
      bool bGotNumberOne = false;

      // Jalankan 100 kali simulasi
      for (int i = 0; i < 100; i++) {
        final session = repo.randomizeCandidateNumbers();
        final firstCandidate = session.firstWhere((c) => c.number == 1);
        if (firstCandidate.candidate.id == 'candidate_a') {
          aGotNumberOne = true;
        } else if (firstCandidate.candidate.id == 'candidate_b') {
          bGotNumberOne = true;
        }
      }

      // Keduanya harus pernah mendapatkan nomor urut 1
      expect(aGotNumberOne, isTrue);
      expect(bGotNumberOne, isTrue);
    });

    test('loadFromAsset dengan file tidak ditemukan mempertahankan calon default tanpa error', () async {
      final repo = CandidateRepository();
      await repo.loadFromAsset(assetPath: 'assets/non_existent.json');

      final candidates = repo.getRawCandidates();
      expect(candidates.length, equals(2));
      expect(candidates[0].id, equals('candidate_a'));
    });
  });
}
