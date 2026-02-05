import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final user = FirebaseAuth.instance.currentUser;
  bool canResend = true;
  int resendCountdown = 60;
  Timer? _timer;
  Timer? _verificationTimer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _startVerificationCheck(); // Start auto-checking email verification
  }

  void _startCountdown() {
    setState(() {
      canResend = false;
      resendCountdown = 60;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCountdown == 0) {
        setState(() => canResend = true);
        timer.cancel();
      } else {
        setState(() => resendCountdown--);
      }
    });
  }

  void _startVerificationCheck() {
    _verificationTimer?.cancel();
    _verificationTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      await user?.reload();
      final refreshedUser = FirebaseAuth.instance.currentUser;
      if (refreshedUser != null && refreshedUser.emailVerified) {
        // Stop the verification timer
        _verificationTimer?.cancel();

        // Update Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(refreshedUser.uid)
            .update({'emailVerified': true});

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Email verified successfully!"),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to home after short delay
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) Navigator.pushReplacementNamed(context, "/home");
          });
        }
      }
    });
  }

  Future<void> _resendEmail() async {
    try {
      await user?.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Verification email sent!"),
          backgroundColor: Colors.green,
        ),
      );
      _startCountdown();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _openEmailApp() async {
    const emailUrl = 'mailto:';
    if (await canLaunchUrl(Uri.parse(emailUrl))) {
      await launchUrl(Uri.parse(emailUrl));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Could not open email app."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _verificationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = user?.email ?? "your email";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Verification",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xFFF5F8FC),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.email, size: 48, color: Colors.blue),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Verify your email",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "We've sent a verification link to your inbox. Please click the link to confirm your account and access the platform.",
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    email,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _openEmailApp,
                    icon: const Icon(
                      Icons.open_in_new,
                      size: 20,
                      color: Colors.white,
                    ),
                    label: const Text("Open Email App"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(color: Colors.white),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Didn't receive the email?",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: canResend ? _resendEmail : null,
                  child: Text(
                    canResend
                        ? "Resend Verification Email"
                        : "Resend in 00:${resendCountdown.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      color: canResend ? Colors.blue : Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Enterprise AI Recruitment Platform v2.4.0\nNeed help? Contact Support",
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
