import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiresense/services/auth.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  static const routename = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isRecruiter = true;

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

                        // Inner white card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
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

                              // Role selector (ANIMATED)
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
                                            MediaQuery.of(context).size.width *
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

                              // Email
                              const _Label(text: "EMAIL ADDRESS"),
                              const SizedBox(height: 6),
                              const _InputField(
                                hint: "name@company.com",
                                icon: Icons.email_outlined,
                              ),

                              const SizedBox(height: 16),

                              // Password
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  _Label(text: "PASSWORD"),
                                  Text(
                                    "FORGOT?",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF4F7CFF),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),
                              const _InputField(
                                hint: "••••••••",
                                icon: Icons.lock_outline,
                                obscure: true,
                              ),

                              const SizedBox(height: 20),

                              // Sign In
                              GestureDetector(
                                onTap: () async {
                                  final userCredential = await AuthService()
                                      .signInWithGoogle(
                                        isRecruiter: isRecruiter,
                                      );
                                  if (userCredential != null) {
                                    final user = userCredential.user;
                                    print("Signed in as: ${user?.displayName}");
                                    print("Email: ${user?.email}");
                                    print(
                                      "Role: ${isRecruiter ? "Recruiter" : "Hiring Manager"}",
                                    );
                                  } else {
                                    print("Sign-in failed or was cancelled");
                                  }
                                },
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F172A),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Center(
                                    child: Text(
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

                              // SSO Buttons
                              Row(
                                children: [
                                  // _ssoButton(
                                  //   icon: FontAwesomeIcons.linkedinIn,
                                  //   text: "LinkedIn",
                                  //   iconColor: Color(0xFF0A66C2),
                                  // const SizedBox(width: 12),
                                  // _ssoButton(
                                  //   icon: FontAwesomeIcons.linkedinIn,
                                  //   text: "LinkedIn",
                                  //   iconColor: Color(0xFF0A66C2),
                                  // ),
                                ],
                              ),
                            ],
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
}) {
  return Expanded(
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
  );
}

class _Label extends StatelessWidget {
  final String text;
  const _Label({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Color(0xFF64748B),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool obscure;

  const _InputField({
    required this.hint,
    required this.icon,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              obscureText: obscure,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
