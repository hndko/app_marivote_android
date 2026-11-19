import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marivote/data/repositories/candidate_repository.dart';
import 'package:marivote/data/repositories/session_repository.dart';
import 'package:marivote/presentation/controllers/election_controller.dart';
import 'package:marivote/presentation/screens/home_election_screen.dart';
import 'package:marivote/presentation/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ElectionController controller;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    controller = ElectionController(
      candidateRepository: CandidateRepository(),
      sessionRepository: SessionRepository(prefs: prefs),
    );
  });

  testWidgets('SplashScreen displays brand elements and navigates to HomeElectionScreen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: SplashScreen(
          controller: controller,
          displayDuration: const Duration(milliseconds: 300),
        ),
      ),
    );

    // Initial pump - Brand identity must be visible
    await tester.pump();
    expect(find.text('MariVote'), findsOneWidget);
    expect(find.text('Simulasi Pemilihan Calon Android'), findsOneWidget);
    expect(find.text('v1.0.0 • Prototype Statis'), findsOneWidget);

    // Advance animation and transition timer
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    // Must navigate to HomeElectionScreen
    expect(find.byType(HomeElectionScreen), findsOneWidget);
    expect(find.text('Pilih Calon Anda'), findsOneWidget);
  });
}
