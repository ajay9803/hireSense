import 'dart:ui';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  static const routename = '/splash';
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // Navigate after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // User is logged in → go to home
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        // User not logged in → go to login
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [_animatedBackground(), _gridOverlay(), _content()],
      ),
    );
  }

  // ---------------- ANIMATED BACKGROUND ----------------

  Widget _animatedBackground() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final t = _controller.value * 2 * math.pi;

        final alignment = Alignment(0.6 * math.cos(t), 0.6 * math.sin(t));

        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: alignment,
              radius: 1.4,
              colors: const [
                Color(0xFF0B1D3A),
                Color(0xFF050B16),
                Color(0xFF020409),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------- GRID ----------------

  Widget _gridOverlay() {
    return CustomPaint(size: Size.infinite, painter: _GridPainter());
  }

  // ---------------- CONTENT ----------------

  Widget _content() {
    return SafeArea(
      child: Column(
        children: [
          const Spacer(),

          _glassLogo(),

          const SizedBox(height: 36),

          _title(),

          const SizedBox(height: 14),

          _subtitle(),

          const SizedBox(height: 24),

          _tagline(),

          const Spacer(),

          _loading(),

          const SizedBox(height: 28),

          _footer(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ---------------- GLASS LOGO ----------------

  Widget _glassLogo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [Colors.blueAccent.withOpacity(0.35), Colors.transparent],
            ),
          ),
        ),

        ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white.withOpacity(0.25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.25),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(Icons.hub, color: Colors.white, size: 38),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- TEXT ----------------

  Widget _title() {
    return RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: "Hire",
            style: TextStyle(
              fontSize: 28,
              letterSpacing: 3,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          TextSpan(
            text: "Sense",
            style: TextStyle(
              fontSize: 28,
              letterSpacing: 3,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3B82F6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _subtitle() {
    return const Text(
      "AI-POWERED TALENT MATCHING",
      style: TextStyle(fontSize: 11, letterSpacing: 2, color: Colors.white70),
    );
  }

  Widget _tagline() {
    return const Text(
      "Match the perfect CV. Faster. Smarter.",
      style: TextStyle(fontSize: 12, color: Colors.white38),
    );
  }

  // ---------------- LOADING ----------------

  Widget _loading() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final opacity = (1 - (_controller.value - i * 0.3).abs()).clamp(
              0.2,
              1.0,
            );

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(opacity),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }

  // ---------------- FOOTER ----------------

  Widget _footer() {
    return Column(
      children: const [
        Text(
          "SECURING TALENT INTELLIGENCE",
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 2,
            color: Colors.white24,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "v1.0.0 • ENTERPRISE AI",
          style: TextStyle(fontSize: 10, color: Colors.white24),
        ),
      ],
    );
  }
}

// ---------------- GRID PAINTER ----------------

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 1;

    const spacing = 36.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
