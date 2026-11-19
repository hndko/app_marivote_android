import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../controllers/election_controller.dart';
import 'home_election_screen.dart';

/// Halaman Splash Screen Beranimasi sesuai PRD Section 11 & Grill-me Alignment
class SplashScreen extends StatefulWidget {
  final ElectionController controller;
  final Duration displayDuration;

  const SplashScreen({
    super.key,
    required this.controller,
    this.displayDuration = const Duration(milliseconds: 1500),
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeIn,
      ),
    );

    _animController.forward();
    _startTransitionTimer();
  }

  Future<void> _startTransitionTimer() async {
    // Jalankan inisialisasi controller dan tunggu durasi minimum tampilan
    final initFuture = widget.controller.isInitialized
        ? Future.value()
        : widget.controller.initialize();

    final timerFuture = Future.delayed(widget.displayDuration);

    await Future.wait([initFuture, timerFuture]);

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            HomeElectionScreen(controller: widget.controller),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),

                // Logo Aplikasi MariVote
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.18),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/app_logo.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, error, stackTrace) => Container(
                        color: AppColors.primary,
                        child: const Icon(
                          Icons.how_to_vote_rounded,
                          color: Colors.white,
                          size: 64,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.space5),

                // Judul Aplikasi
                Text(
                  'MariVote',
                  style: AppTypography.display.copyWith(
                    fontSize: 32,
                    letterSpacing: 0.5,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: AppSpacing.space1),

                // Subtitle / Tagline
                Text(
                  'Simulasi Pemilihan Calon Android',
                  style: AppTypography.bodySecondary.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: AppSpacing.space4),

                // Badge Status Simulasi Statis
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space3,
                    vertical: AppSpacing.space1,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: AppSpacing.roundedFull,
                  ),
                  child: Text(
                    'v1.0.0 • Prototype Statis',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                // Catatan Bawah
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.space1),
                    Text(
                      '100% Offline • Netral • Mandiri',
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.space4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
