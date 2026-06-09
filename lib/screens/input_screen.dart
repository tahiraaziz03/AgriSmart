import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import 'result_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _nCtrl = TextEditingController();
  final _pCtrl = TextEditingController();
  final _kCtrl = TextEditingController();
  final _tempCtrl = TextEditingController();
  final _humCtrl = TextEditingController();
  final _phCtrl = TextEditingController();
  final _rainCtrl = TextEditingController();

  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _nCtrl.dispose();
    _pCtrl.dispose();
    _kCtrl.dispose();
    _tempCtrl.dispose();
    _humCtrl.dispose();
    _phCtrl.dispose();
    _rainCtrl.dispose();
    super.dispose();
  }

  Future<void> _predict() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final result = await ApiService.predictCrop(
        nitrogen: double.parse(_nCtrl.text),
        phosphorus: double.parse(_pCtrl.text),
        potassium: double.parse(_kCtrl.text),
        temperature: double.parse(_tempCtrl.text),
        humidity: double.parse(_humCtrl.text),
        ph: double.parse(_phCtrl.text),
        rainfall: double.parse(_rainCtrl.text),
      );
      if (mounted) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, a, b) => ResultScreen(result: result),
            transitionsBuilder: (_, a, b, child) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
              child: child,
            ),
            transitionDuration: const Duration(milliseconds: 450),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: [
            const Text('⚠️ '),
            Expanded(
                child: Text('Connection error. Try again.',
                    style: GoogleFonts.poppins())),
          ]),
          backgroundColor: const Color(0xFFB71C1C),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildField(
    TextEditingController ctrl,
    String label,
    String hint,
    String unit,
    String emoji, {
    String? rangeHint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: '$emoji  $label',
          labelStyle: GoogleFonts.poppins(
              fontSize: 14, color: const Color(0xFF388E3C)),
          hintText: hint,
          hintStyle:
              GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade400),
          suffixText: unit,
          suffixStyle: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFF2E7D32),
              fontWeight: FontWeight.w600),
          helperText: rangeHint,
          helperStyle: GoogleFonts.poppins(
              fontSize: 11, color: Colors.grey.shade500),
          filled: true,
          fillColor: const Color(0xFFF1F8E9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFDCEDC8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFDCEDC8), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: Color(0xFF4CAF50), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE53935), width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: (v) {
          if (v == null || v.isEmpty) return 'This field is required';
          if (double.tryParse(v) == null) return 'Enter a valid number';
          return null;
        },
      ),
    );
  }

  Widget _buildSectionHeader(String emoji, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1B5E20))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Soft web layout background
      appBar: AppBar(
        title: Text('Soil & Climate Data',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700, color: Colors.white, fontSize: 18)),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Center( // Centers the web form layout beautifully
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600), // Perfect desktop width limit
          child: Container(
            color: Colors.white,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Info card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE8F5E9), Color(0xFFF1F8E9)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: const Border(
                              left: BorderSide(
                                  color: Color(0xFF4CAF50), width: 4)),
                        ),
                        child: Row(
                          children: [
                            const Text('💡', style: TextStyle(fontSize: 22)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Fill in your soil & weather details for an accurate AI recommendation.',
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: const Color(0xFF2E7D32),
                                    height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      _buildSectionHeader('🧪', 'Soil Nutrients'),
                      _buildField(_nCtrl, 'Nitrogen', 'e.g. 90', 'mg/kg', '🌿',
                          rangeHint: 'Typical range: 0–140'),
                      _buildField(_pCtrl, 'Phosphorus', 'e.g. 42', 'mg/kg', '🪨',
                          rangeHint: 'Typical range: 5–145'),
                      _buildField(_kCtrl, 'Potassium', 'e.g. 43', 'mg/kg', '⚗️',
                          rangeHint: 'Typical range: 5–205'),
                      _buildField(_phCtrl, 'Soil pH', 'e.g. 6.5', 'pH', '🧫',
                          rangeHint: 'Ideal range: 3.5–9.5'),
                      const SizedBox(height: 8),
                      _buildSectionHeader('🌤️', 'Climate Conditions'),
                      _buildField(_tempCtrl, 'Temperature', 'e.g. 25.0', '°C', '🌡️',
                          rangeHint: 'Typical range: 8–44°C'),
                      _buildField(_humCtrl, 'Humidity', 'e.g. 80', '%', '💧',
                          rangeHint: 'Typical range: 14–100%'),
                      _buildField(_rainCtrl, 'Rainfall', 'e.g. 200', 'mm', '🌧️',
                          rangeHint: 'Typical range: 20–300mm'),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _predict,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2.5))
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('🌾 ',
                                        style: TextStyle(fontSize: 20)),
                                    Text('Analyse & Recommend',
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.3)),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}