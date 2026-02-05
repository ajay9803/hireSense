import 'dart:ui';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
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

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
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
      backgroundColor: const Color(0xFFF7FAFF),
      body: SafeArea(
        child: Stack(
          children: [_animatedBackground(), _gridOverlay(), _content()],
        ),
      ),
    );
  }

  // ---------------- BACKGROUND ----------------

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
                Color(0xFFEAF2FF),
                Color(0xFFF7FAFF),
                Colors.white,
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

  // ---------------- LOGO ----------------

  Widget _glassLogo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [Colors.blue.withOpacity(0.18), Colors.transparent],
            ),
          ),
        ),

        ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(Icons.hub, color: Color(0xFF2563EB), size: 38),
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
              color: Color(0xFF1E293B),
            ),
          ),
          TextSpan(
            text: "Sense",
            style: TextStyle(
              fontSize: 28,
              letterSpacing: 3,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2563EB),
            ),
          ),
        ],
      ),
    );
  }

  Widget _subtitle() {
    return const Text(
      "AI-POWERED TALENT MATCHING",
      style: TextStyle(
        fontSize: 11,
        letterSpacing: 2,
        color: Color(0xFF64748B),
      ),
    );
  }

  Widget _tagline() {
    return const Text(
      "Match the perfect CV. Faster. Smarter.",
      style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
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
              0.3,
              1.0,
            );

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(opacity),
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
            color: Color(0xFFCBD5E1),
          ),
        ),
        SizedBox(height: 10),
        Text(
          "v1.0.0 • ENTERPRISE AI",
          style: TextStyle(fontSize: 10, color: Color(0xFFCBD5E1)),
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
      ..color = Colors.black.withOpacity(0.1)
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
