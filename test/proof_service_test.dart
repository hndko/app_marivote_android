import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marivote/data/models/candidate.dart';
import 'package:marivote/presentation/widgets/proof_ticket_widget.dart';
import 'package:marivote/services/proof_export_service.dart';

void main() {
  group('ProofExportService Tests (PRD Section 10.3)', () {
    test('generateFileName generates correct format bukti-pilihan-YYYYMMDD-HHmmss.png', () {
      final dt = DateTime(2026, 11, 19, 14, 30, 45);
      final fileName = ProofExportService.generateFileName(dt);

      expect(fileName, equals('bukti-pilihan-20261119-143045.png'));
    });

    test('ProofTicketWidget formats Indonesian dates and times properly', () {
      final dt = DateTime(2026, 11, 19, 9, 5);
      final dateStr = ProofTicketWidget.formatDateIndonesian(dt);
      final timeStr = ProofTicketWidget.formatTimeIndonesian(dt);

      expect(dateStr, equals('19 November 2026'));
      expect(timeStr, equals('09:05'));
    });

    testWidgets('ProofTicketWidget displays ONLY selected candidate data and not the other', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const candidateA = Candidate(
        id: 'candidate_a',
        name: 'Ahmad Pratama',
        image: 'assets/images/calon_a.png',
      );

      const candidateWithNumber = CandidateWithNumber(
        candidate: candidateA,
        number: 1,
      );

      final votedAt = DateTime(2026, 11, 19, 11, 30);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ProofTicketWidget(
                candidateWithNumber: candidateWithNumber,
                votedAt: votedAt,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Memastikan teks judul dan calon terpilih tampil
      expect(find.text('BUKTI PILIHAN'), findsOneWidget);
      expect(find.text('SIMULASI PEMILIHAN CALON'), findsOneWidget);
      expect(find.text('Ahmad Pratama'), findsOneWidget);
      expect(find.text('NOMOR URUT 01'), findsOneWidget);
      expect(find.textContaining('19 November 2026'), findsOneWidget);
      expect(find.textContaining('11:30'), findsOneWidget);
      expect(find.text('Dokumen ini merupakan bukti simulasi dari aplikasi statis.'), findsOneWidget);

      // Memastikan calon yang TIDAK dipilih sama sekali tidak muncul (PRD Section 6.4)
      expect(find.text('Siti Rahmawati'), findsNothing);
      expect(find.text('NOMOR URUT 02'), findsNothing);
    });
  });
}
