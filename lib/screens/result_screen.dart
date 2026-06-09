import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/crop_result.dart';

class ResultScreen extends StatelessWidget {
  final CropResult result;
  const ResultScreen({super.key, required this.result});

  String _getCropEmoji(String crop) {
    const emojis = {
      'rice': '🌾', 'maize': '🌽', 'wheat': '🌿',
      'cotton': '☁️', 'sugarcane': '🎋', 'mango': '🥭',
      'banana': '🍌', 'grapes': '🍇', 'apple': '🍎',
      'watermelon': '🍉', 'papaya': '🧡', 'orange': '🍊',
      'coconut': '🥥', 'pomegranate': '🍎', 'lentil': '🫘',
    };
    return emojis[crop.toLowerCase()] ?? '🌱';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1B5E20), Color(0xFFE8F5E9)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white),
                    ),
                    Text('Your Result',
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          _getCropEmoji(result.recommendedCrop),
                          style: const TextStyle(fontSize: 72),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          result.recommendedCrop.toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1B5E20),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Confidence: ${result.confidence.toStringAsFixed(1)}%',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: const Color(0xFF2E7D32),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          result.message,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const Divider(height: 32),
                        Text('Top 3 Recommendations',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            )),
                        const SizedBox(height: 12),
                        ...result.top3.asMap().entries.map((e) {
                          final rank = e.key + 1;
                          final crop = e.value;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: rank == 1
                                  ? const Color(0xFFE8F5E9)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: rank == 1
                                  ? Border.all(
                                      color: const Color(0xFF4CAF50),
                                      width: 2)
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Text('$rank.',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                const SizedBox(width: 12),
                                Text(_getCropEmoji(crop.crop),
                                    style:
                                        const TextStyle(fontSize: 24)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(crop.crop,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15)),
                                ),
                                Text(
                                  '${crop.confidence.toStringAsFixed(1)}%',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF2E7D32),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.popUntil(
                                context, (route) => route.isFirst),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E7D32),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12)),
                            ),
                            child: Text('Try Again',
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}