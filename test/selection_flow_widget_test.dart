import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marivote/data/repositories/candidate_repository.dart';
import 'package:marivote/data/repositories/session_repository.dart';
import 'package:marivote/presentation/controllers/election_controller.dart';
import 'package:marivote/presentation/screens/home_election_screen.dart';
import 'package:marivote/presentation/widgets/candidate_card.dart';
import 'package:marivote/presentation/widgets/confirmation_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ElectionController controller;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final sessionRepo = SessionRepository(prefs: prefs);
    final candidateRepo = CandidateRepository();

    controller = ElectionController(
      candidateRepository: candidateRepo,
      sessionRepository: sessionRepo,
    );
    await controller.initialize();
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: HomeElectionScreen(controller: controller),
    );
  }

  group('Selection Flow & Dialog Tests (PRD TC-01, TC-03, TC-04, TC-05, TC-07)', () {
    testWidgets('TC-01: Menampilkan tepat dua kartu calon di halaman utama', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.text('Pemilihan Calon'), findsOneWidget);
      expect(find.text('Pilih Calon Anda'), findsOneWidget);
      expect(find.byType(CandidateCard), findsNWidgets(2));
      expect(find.text('Pilih'), findsNWidgets(2));
    });

    testWidgets('TC-03 & TC-04: Menekan Pilih membuka dialog dan menekan Kembali membatalkan pilihan', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final firstCandidate = controller.candidates[0];
      final originalNumber = firstCandidate.formattedNumber;

      // Tap tombol Pilih pada calon pertama
      final pickButtons = find.widgetWithText(ElevatedButton, 'Pilih');
      await tester.ensureVisible(pickButtons.first);
      await tester.tap(pickButtons.first);
      await tester.pumpAndSettle();

      // Dialog konfirmasi harus tampil
      expect(find.byType(ConfirmationDialog), findsOneWidget);
      expect(find.text('Konfirmasi Pilihan'), findsOneWidget);
      expect(find.textContaining(firstCandidate.candidate.name), findsWidgets);
      expect(find.textContaining('Nomor Urut $originalNumber'), findsWidgets);

      // Tap Kembali
      final backButton = find.widgetWithText(OutlinedButton, 'Kembali');
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Dialog tertutup dan belum ada pilihan yang disimpan
      expect(find.byType(ConfirmationDialog), findsNothing);
      expect(controller.hasVoted, isFalse);
      expect(controller.selectedCandidate, isNull);

      // Nomor urut harus tetap sama (PRD FR-04)
      expect(controller.candidates[0].formattedNumber, equals(originalNumber));
    });

    testWidgets('TC-05: Menekan Ya, Pilih menetapkan calon dan beralih ke halaman hasil', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final selectedCandidate = controller.candidates[0];

      // Tap tombol Pilih pada calon pertama
      final pickButtons = find.widgetWithText(ElevatedButton, 'Pilih');
      await tester.ensureVisible(pickButtons.first);
      await tester.tap(pickButtons.first);
      await tester.pumpAndSettle();

      // Tap Ya, Pilih
      final confirmButton = find.widgetWithText(ElevatedButton, 'Ya, Pilih');
      await tester.tap(confirmButton);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Verifikasi status controller
      expect(controller.hasVoted, isTrue);
      expect(controller.selectedCandidate, equals(selectedCandidate));
      expect(controller.state, equals(ElectionState.selected));

      // Verifikasi Halaman Hasil
      expect(find.text('Pilihan Berhasil Disimpan'), findsOneWidget);
      expect(find.text('Terima kasih. Pilihan Anda telah berhasil dicatat pada perangkat ini.'), findsOneWidget);
      expect(find.text(selectedCandidate.candidate.name), findsOneWidget);
    });

    testWidgets('TC-07: Memilih calon kedua menetapkan calon kedua secara konsisten', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final secondCandidate = controller.candidates[1];

      // Scroll dan tap tombol Pilih pada calon kedua
      final pickButtons = find.widgetWithText(ElevatedButton, 'Pilih');
      await tester.ensureVisible(pickButtons.at(1));
      await tester.tap(pickButtons.at(1));
      await tester.pumpAndSettle();

      expect(find.byType(ConfirmationDialog), findsOneWidget);
      expect(find.textContaining(secondCandidate.candidate.name), findsWidgets);
      expect(find.textContaining('Nomor Urut ${secondCandidate.formattedNumber}'), findsWidgets);

      // Konfirmasi
      final confirmButton = find.widgetWithText(ElevatedButton, 'Ya, Pilih');
      await tester.tap(confirmButton);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(controller.hasVoted, isTrue);
      expect(controller.selectedCandidate, equals(secondCandidate));
      expect(find.text(secondCandidate.candidate.name), findsOneWidget);
    });
  });
}
