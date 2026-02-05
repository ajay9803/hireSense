import 'package:flutter/material.dart';
import 'package:hiresense/api/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isRecruiter = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final userCredential = await AuthService().signInWithEmailPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = userCredential!.user;
      if (user != null) {
        final refreshedUser = FirebaseAuth.instance.currentUser;
        if (refreshedUser!.emailVerified) {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, "/verify");
        }
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Sign-in failed"),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      setState(() => _loading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6EEFE),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Outer card
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F6FF),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      children: [
                        // Logo
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: Color(0xFF4F7CFF),
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          "hireSense",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),

                        const SizedBox(height: 4),

                        const Text(
                          "ENTERPRISE INTELLIGENCE",
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 1.2,
                            color: Color(0xFF64748B),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Inner white card with form
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  "Welcome Back",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),

                                const SizedBox(height: 6),

                                const Text(
                                  "Access your recruitment suite",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF64748B),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Role selector
                                Container(
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Stack(
                                    children: [
                                      AnimatedAlign(
                                        alignment: isRecruiter
                                            ? Alignment.centerLeft
                                            : Alignment.centerRight,
                                        duration: const Duration(
                                          milliseconds: 320,
                                        ),
                                        curve: Curves.easeOut,
                                        child: Container(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.38,
                                          height: 36,
                                          margin: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Row(
                                          children: [
                                            _roleButton(
                                              text: "Recruiter",
                                              active: isRecruiter,
                                              onTap: () {
                                                setState(() {
                                                  isRecruiter = true;
                                                });
                                              },
                                            ),
                                            _roleButton(
                                              text: "Hiring Manager",
                                              active: !isRecruiter,
                                              onTap: () {
                                                setState(() {
                                                  isRecruiter = false;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Email input
                                _input(
                                  _emailController,
                                  "Email Address",
                                  Icons.email_outlined,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter email";
                                    }
                                    return null;
                                  },
                                ),

                                // Password input
                                _input(
                                  _passwordController,
                                  "Password",
                                  Icons.lock_outline,
                                  obscure: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter password";
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 20),

                                // Sign In button
                                GestureDetector(
                                  onTap: _loading ? null : _signInWithEmail,
                                  child: Container(
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0F172A),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Center(
                                      child: _loading
                                          ? SizedBox(
                                              height: 18,
                                              width: 18,
                                              child:
                                                  const CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 2,
                                                  ),
                                            )
                                          : const Text(
                                              "Sign In",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Divider
                                Row(
                                  children: const [
                                    Expanded(child: Divider()),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        "SECURE SSO",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF94A3B8),
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Divider()),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                // SSO buttons
                                Row(
                                  children: [
                                    _ssoButton(
                                      icon: FontAwesomeIcons.google,
                                      text: "Google",
                                      iconColor: Color.fromARGB(255, 194, 7, 7),
                                      onTap: () async {
                                        final userCredential =
                                            await AuthService()
                                                .signInWithGoogle(
                                                  isRecruiter: isRecruiter,
                                                );

                                        if (userCredential != null) {
                                          if (!mounted) return;
                                          Navigator.pushReplacementNamed(
                                            context,
                                            '/dashboard',
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 12),
                                    _ssoButton(
                                      icon: FontAwesomeIcons.linkedinIn,
                                      text: "LinkedIn",
                                      iconColor: Color(0xFF0A66C2),
                                      onTap: () async {},
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Footer
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                      children: [
                        TextSpan(text: "New to the platform? "),
                        TextSpan(
                          text: "Request Access",
                          style: TextStyle(
                            color: Color(0xFF4F7CFF),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "PRIVACY  •  LEGAL  •  SECURITY",
                    style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- COMPONENTS ----------------

Widget _roleButton({
  required String text,
  required bool active,
  required VoidCallback onTap,
}) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        color: Colors.transparent,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: active ? const Color(0xFF0F172A) : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _ssoButton({
  required IconData icon,
  required String text,
  required Color iconColor,
  required Future<void> Function() onTap,
}) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ],
        ),
      ),
    ),
  );
}

// ---------------- TEXT INPUT ----------------

Widget _input(
  TextEditingController controller,
  String hint,
  IconData icon, {
  bool obscure = false,
  Widget? suffix,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 18),
        suffixIcon: suffix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
    ),
  );
}
