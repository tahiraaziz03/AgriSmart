import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>(); // Tracks input validation state
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  bool _isLoading = false;
  bool _obscurePass = true;

  late AnimationController _fadeCtrl;
  late AnimationController _floatCtrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _slideAnim;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _floatCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<double>(begin: 40, end: 0).animate(
        CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOutCubic));
    _floatAnim = Tween<double>(begin: -8, end: 8).animate(
        CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _floatCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    // Halts execution if user data fields fail regex/empty constraints
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.auth.signUp(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
        data: {'full_name': _nameCtrl.text.trim()},
      );
      if (mounted) {
        _showNotification('Account created! Please sign in.', const Color(0xFF2E7D32), '✅ ');
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, a, b) => const LoginScreen(),
            transitionsBuilder: (_, a, b, child) =>
                FadeTransition(opacity: a, child: child),
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    } on AuthException catch (e) {
      // Catches explicit validation failures from Supabase (e.g., "Email already registered")
      if (mounted) _showNotification(e.message, const Color(0xFFB71C1C), '⚠️ ');
    } catch (e) {
      if (mounted) _showNotification('Signup failed. Try again.', const Color(0xFFB71C1C), '⚠️ ');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showNotification(String msg, Color bgColor, String emoji) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        Text(emoji),
        Expanded(child: Text(msg, style: GoogleFonts.poppins())),
      ]),
      backgroundColor: bgColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A3D0A), Color(0xFF1B5E20), Color(0xFF2E7D32)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500), // Ensures high-end desktop web presentation
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: AnimatedBuilder(
                    animation: _slideAnim,
                    builder: (_, child) => Transform.translate(
                      offset: Offset(0, _slideAnim.value),
                      child: child,
                    ),
                    child: Form(
                      key: _formKey, // Form key registration
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          AnimatedBuilder(
                            animation: _floatAnim,
                            builder: (_, __) => Transform.translate(
                              offset: Offset(0, _floatAnim.value),
                              child: Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF4CAF50).withOpacity(0.5),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text('🌱', style: TextStyle(fontSize: 42)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text('AgriSmart',
                              style: GoogleFonts.poppins(
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              )),
                          Text('Join the smart farming revolution',
                              style: GoogleFonts.poppins(
                                  fontSize: 13, color: Colors.white60)),
                          const SizedBox(height: 32),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.15), width: 1.5),
                            ),
                            padding: const EdgeInsets.all(28),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Create Account 🚀',
                                    style: GoogleFonts.poppins(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white)),
                                const SizedBox(height: 6),
                                Text('Fill in the details below',
                                    style: GoogleFonts.poppins(
                                        fontSize: 13, color: Colors.white54)),
                                const SizedBox(height: 28),
                                _buildGlassField(
                                  controller: _nameCtrl,
                                  label: 'Full Name',
                                  icon: Icons.person_outline_rounded,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) return 'Please tell us your name';
                                    if (v.trim().length < 2) return 'Name is too short';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                _buildGlassField(
                                  controller: _emailCtrl,
                                  label: 'Email Address',
                                  icon: Icons.alternate_email_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) return 'Email is required';
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim())) {
                                      return 'Enter a valid email address';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                _buildGlassField(
                                  controller: _passCtrl,
                                  label: 'Password',
                                  icon: Icons.lock_outline_rounded,
                                  obscure: _obscurePass,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) return 'Password cannot be blank';
                                    if (v.trim().length < 6) return 'Password must be at least 6 characters';
                                    return null;
                                  },
                                  suffix: IconButton(
                                    icon: Icon(
                                      _obscurePass
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.white54,
                                      size: 20,
                                    ),
                                    onPressed: () =>
                                        setState(() => _obscurePass = !_obscurePass),
                                  ),
                                ),
                                const SizedBox(height: 28),
                                SizedBox(
                                  width: double.infinity,
                                  height: 54,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _signup,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4CAF50),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16)),
                                      elevation: 0,
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2.5))
                                        : Text('Create Account',
                                            style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.5)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already have an account? ',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white60, fontSize: 14)),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Text('Sign In',
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF81C784),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextFormField( // Shifted to TextFormField to communicate validation failures
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      validator: validator,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.white54, fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF81C784), size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEF9A9A), width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.8),
        ),
      ),
    );
  }
}