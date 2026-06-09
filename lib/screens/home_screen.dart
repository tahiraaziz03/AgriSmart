import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'input_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late AnimationController _floatCtrl;
  late AnimationController _pulseCtrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _floatAnim;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _floatCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: true);
    _pulseCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);

    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _floatAnim = Tween<double>(begin: -10, end: 10).animate(
        CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
    _pulseAnim = Tween<double>(begin: 0.98, end: 1.02).animate( // Slightly reduced for smoother web rendering
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _floatCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A3D0A), Color(0xFF1B5E20), Color(0xFF388E3C)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView( // Prevents UI crash / overflow on smaller screens/web resize
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          // Top bar
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Good day! 👋',
                                        style: GoogleFonts.poppins(
                                            fontSize: 13, color: Colors.white60)),
                                    Text('AgriSmart',
                                        style: GoogleFonts.poppins(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                            letterSpacing: 0.5)),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.2)),
                                  ),
                                  child: const Text('🌿',
                                      style: TextStyle(fontSize: 22)),
                                ),
                              ],
                            ),
                          ),
                          
                          // Main Content Area
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Floating main icon
                                  AnimatedBuilder(
                                    animation: _floatAnim,
                                    builder: (_, __) => Transform.translate(
                                      offset: Offset(0, _floatAnim.value),
                                      child: Container(
                                        width: 140,
                                        height: 140,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF81C784),
                                              Color(0xFF2E7D32)
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF4CAF50)
                                                  .withOpacity(0.6),
                                              blurRadius: 40,
                                              spreadRadius: 10,
                                            ),
                                          ],
                                        ),
                                        child: const Center(
                                          child: Text('🌾', style: TextStyle(fontSize: 64)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Text(
                                    'AI-Powered\nCrop Intelligence',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      height: 1.2,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    'Enter your soil & climate data\nand get the perfect crop recommendation',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.white60,
                                      height: 1.6,
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                  
                                  // Stats row
                                  Row(
                                    children: [
                                      _buildStat('22+', 'Crops', '🌽'),
                                      const SizedBox(width: 12),
                                      _buildStat('98%', 'Accuracy', '🎯'),
                                      const SizedBox(width: 12),
                                      _buildStat('AI', 'Powered', '🤖'),
                                    ],
                                  ),
                                  const SizedBox(height: 40),
                                  
                                  // CTA Button with pulse
                                  AnimatedBuilder(
                                    animation: _pulseAnim,
                                    builder: (_, child) => Transform.scale(
                                      scale: _pulseAnim.value,
                                      child: child,
                                    ),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 60,
                                      child: ElevatedButton(
                                        onPressed: () => Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (_, a, b) =>
                                                const InputScreen(),
                                            transitionsBuilder: (_, a, b, child) =>
                                                SlideTransition(
                                              position: Tween<Offset>(
                                                begin: const Offset(1, 0),
                                                end: Offset.zero,
                                              ).animate(CurvedAnimation(
                                                  parent: a,
                                                  curve: Curves.easeOutCubic)),
                                              child: child,
                                            ),
                                            transitionDuration:
                                                const Duration(milliseconds: 400),
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF4CAF50),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(18)),
                                          elevation: 0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('Get Crop Recommendation',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: 0.3)),
                                            const SizedBox(width: 10),
                                            const Icon(Icons.arrow_forward_rounded,
                                                size: 20),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label, String emoji) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(value,
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 11, color: Colors.white60)),
          ],
        ),
      ),
    );
  }
}