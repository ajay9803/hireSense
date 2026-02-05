import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hiresense/api/auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isRecruiter = true;
  bool obscurePassword = true;
  bool loading = false;

  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  Future<void> _signUp() async {
    ScaffoldMessenger.of(context).clearSnackBars();
    // Validate form first
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      final result = await AuthService().signUpWithEmailPassword(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
        isRecruiter: isRecruiter,
        username: _nameCtrl.text.trim(),
      );

      setState(() => loading = false);

      if (result != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Signup successful! Please verify your email."),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, "/verify");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Signup failed. Try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 380,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),

                    // Logo
                    const Icon(
                      Icons.auto_awesome,
                      size: 32,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "hireSense",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "ENTERPRISE INTELLIGENCE",
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1.2,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      "Create your account",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Access your recruitment suite",
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    // Role selector
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          _roleButton("Recruiter", isRecruiter, () {
                            setState(() => isRecruiter = true);
                          }),
                          _roleButton("Hiring Manager", !isRecruiter, () {
                            setState(() => isRecruiter = false);
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    _label("FULL NAME"),
                    _input(
                      _nameCtrl,
                      "John Doe",
                      Icons.person,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your name";
                        }
                        return null;
                      },
                    ),

                    _label("WORK EMAIL"),
                    _input(
                      _emailCtrl,
                      "name@company.com",
                      Icons.email,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your email";
                        }
                        final emailRegex = RegExp(
                          r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                        );
                        if (!emailRegex.hasMatch(value.trim())) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),

                    _label("COMPANY NAME"),
                    _input(
                      _companyCtrl,
                      "Acme Corp",
                      Icons.apartment,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter company name";
                        }
                        return null;
                      },
                    ),

                    _label("PASSWORD"),
                    _input(
                      _passwordCtrl,
                      "Min. 8 characters",
                      Icons.lock,
                      obscure: obscurePassword,
                      suffix: TextButton(
                        onPressed: () {
                          setState(() => obscurePassword = !obscurePassword);
                        },
                        child: Text(obscurePassword ? "SHOW" : "HIDE"),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter password";
                        }
                        if (value.trim().length < 8) {
                          return "Password must be at least 8 characters";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: loading ? null : _signUp,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: loading
                              ? SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      "SECURE SSO",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),

                    const SizedBox(height: 12),

                    _ssoButton(FontAwesomeIcons.google, "Google"),
                    const SizedBox(height: 10),
                    _ssoButton(FontAwesomeIcons.linkedin, "LinkedIn"),

                    const SizedBox(height: 16),

                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/login");
                      },
                      child: const Text("Already have an account? Log in"),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "PRIVACY  ·  LEGAL  ·  SECURITY",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- UI HELPERS ----------------

  Widget _roleButton(String text, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: active ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

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

  Widget _ssoButton(IconData icon, String text) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 16),
        label: Text(text),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
