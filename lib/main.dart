import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/controllers/election_controller.dart';
import 'presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final controller = ElectionController();

  runApp(MariVoteApp(controller: controller));
}

class MariVoteApp extends StatelessWidget {
  final ElectionController controller;

  const MariVoteApp({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MariVote - Pemilihan Calon',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: SplashScreen(controller: controller),
    );
  }
}
