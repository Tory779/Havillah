import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _arrowController;
  late final Animation<double> _arrowAnimation;

  bool _showButton = false;

  @override
  void initState() {
    super.initState();

    _arrowController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _arrowAnimation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _arrowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.85,
            colors: [Color(0xFF1E1E50), Color(0xFF38A3C5)],
            stops: [0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 20),
              Transform.translate(
                offset: const Offset(0, -100),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLogo(),
                    const SizedBox(height: 6),
                    Text(
                      'ICE CREAM',
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      'creme de la creme',
                      style: GoogleFonts.playfairDisplay(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedTruckImage(
                onAnimationComplete: () {
                  if (mounted) {
                    setState(() {
                      _showButton = true;
                    });
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30, left: 24, right: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _arrowAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _arrowAnimation.value),
                          child: child,
                        );
                      },
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.red, Colors.lightBlueAccent],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(bounds),
                        child: const Icon(
                          Icons.arrow_downward_rounded,
                          size: 36,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AnimatedOpacity(
                      opacity: _showButton ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: IgnorePointer(
                        ignoring: !_showButton,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => context.go('/'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC00000),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              elevation: 4,
                            ),
                            child: const Text(
                              'Choose your flavour',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.holtwoodOneSc(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
        children: [
          TextSpan(
            text: 'H',
            style: GoogleFonts.holtwoodOneSc(color: const Color(0xFFCC0505)),
          ),
          TextSpan(
            text: 'A',
            style: GoogleFonts.holtwoodOneSc(color: const Color(0xFF050FCC)),
          ),
          TextSpan(
            text: 'V',
            style: GoogleFonts.holtwoodOneSc(color: Colors.white),
          ),
          TextSpan(
            text: 'I',
            style: GoogleFonts.holtwoodOneSc(color: const Color(0xFF008223)),
          ),
          TextSpan(
            text: 'L',
            style: GoogleFonts.holtwoodOneSc(color: const Color(0xFFB30593)),
          ),
          TextSpan(
            text: 'A',
            style: GoogleFonts.holtwoodOneSc(color: const Color(0xFFF56111)),
          ),
          TextSpan(
            text: 'H',
            style: GoogleFonts.holtwoodOneSc(color: const Color(0xFFCC0505)),
          ),
        ],
      ),
    );
  }
}

class AnimatedTruckImage extends StatefulWidget {
  const AnimatedTruckImage({super.key, required this.onAnimationComplete});

  final VoidCallback onAnimationComplete;

  @override
  State<AnimatedTruckImage> createState() => _AnimatedTruckImageState();
}

class _AnimatedTruckImageState extends State<AnimatedTruckImage>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutBack),
    );

    _fadeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete();
      }
    });

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -80),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Image.asset(
            'assets/images/fonts/truck_balloons.png',
            width: 170,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
