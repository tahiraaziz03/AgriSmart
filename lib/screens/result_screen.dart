import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/crop_result.dart';

class ResultScreen extends StatelessWidget {
  final CropResult result;
  const ResultScreen({super.key, required this.result});

  // 📦 Crop Information Database (Harvest time & Guide)
  Map<String, Map<String, String>> get _cropDatabase => {
        'rice': {
          'duration': '3 - 5 Months',
          'guide': 'Prepare flooded fields. Sow seeds in nurseries first, then transplant. Requires constant moisture and warm temperatures.',
        },
        'maize': {
          'duration': '3 - 4 Months',
          'guide': 'Sow seeds directly into well-drained, warm soil. Needs full sunlight and regular watering during pollination.',
        },
        'wheat': {
          'duration': '4 - 5 Months',
          'guide': 'Sow in cooler seasons. Requires well-pulverized loam soil and moderate watering (3-4 times across the cycle).',
        },
        'cotton': {
          'duration': '5 - 6 Months',
          'guide': 'Plant in deep, well-drained soils. Needs plenty of sunshine and high temperatures. Harvest when bolls burst open.',
        },
        'sugarcane': {
          'duration': '12 - 18 Months',
          'guide': 'Planted using stem cuttings. Requires heavy manure, rich soil, high temperatures, and continuous heavy irrigation.',
        },
      };

  // Emojis ko enhance kiya hai aur behtar options lagaye hain
  String _getCropEmoji(String crop) {
    const emojis = {
      'rice': '🌾', 'maize': '🌽', 'wheat': '🌱',
      'cotton': '☁️', 'sugarcane': '🎋', 'mango': '🥭',
      'banana': '🍌', 'grapes': '🍇', 'apple': '🍎',
      'watermelon': '🍉', 'papaya': ' papaya 🥭', 'orange': '🍊',
      'coconut': '🥥', 'pomegranate': '🍎', 'lentil': '🫘',
    };
    return emojis[crop.toLowerCase().trim()] ?? '🍃';
  }

  @override
  Widget build(BuildContext context) {
    final cropKey = result.recommendedCrop.toLowerCase().trim();
    final cropInfo = _cropDatabase[cropKey] ?? {
      'duration': '3 - 4 Months',
      'guide': 'Ensure proper soil preparation, maintain moisture levels, provide adequate sunlight, and protect from pests timely.',
    };

    // Premium Emerald & Mint Fresh Color Palette
    const primaryDeep = Color(0xFF004D40); // Deep Teal Green
    const accentMint = Color(0xFF00BFA5);  // Vibrant Mint
    const bgLight = Color(0xFFF0F7F6);     // Premium Soft Background

    return Scaffold(
      backgroundColor: bgLight,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [primaryDeep, bgLight],
            stops: [0.35, 0.35],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                children: [
                  // App Bar Section
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 8),
                        Text('Recommendation Analysis',
                            style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                  
                  // Main Content Card
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: primaryDeep.withOpacity(0.06),
                            blurRadius: 30,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🌟 ENHANCED EMOJI DISPLAY WITH NESTED GLASS CONTAINER
                            Center(
                              child: Column(
                                children: [
                                  Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      color: bgLight,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: accentMint.withOpacity(0.3), width: 3),
                                      boxShadow: [
                                        BoxShadow(
                                          color: accentMint.withOpacity(0.15),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                        )
                                      ]
                                    ),
                                    child: Center(
                                      child: Text(
                                        _getCropEmoji(result.recommendedCrop),
                                        style: const TextStyle(fontSize: 64), // Slightly smaller to fit perfectly inside the circle
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    result.recommendedCrop.toUpperCase(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      color: primaryDeep,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: accentMint.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      'AI Match: ${result.confidence.toStringAsFixed(1)}%',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: primaryDeep,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            const Divider(color: Color(0xFFE0F2F1)),
                            const SizedBox(height: 16),

                            // 🌾 FARMING GUIDE SECTION
                            Text('🚀 Quick Farming Guide',
                                style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: primaryDeep,
                                )),
                            const SizedBox(height: 14),
                            
                            // Harvesting Time Widget
                            Row(
                              children: [
                                const Icon(Icons.calendar_today_rounded, color: accentMint, size: 20),
                                const SizedBox(width: 10),
                                Text('Harvesting Period:',
                                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade600)),
                                const Spacer(),
                                Text(cropInfo['duration']!,
                                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: primaryDeep)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            
                            // Step by Step Instructions
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: bgLight,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: accentMint.withOpacity(0.2)),
                              ),
                              child: Text(
                                cropInfo['guide']!,
                                style: GoogleFonts.poppins(fontSize: 13, height: 1.6, color: Colors.teal.shade900),
                              ),
                            ),

                            const SizedBox(height: 24),
                            const Divider(color: Color(0xFFE0F2F1)),
                            const SizedBox(height: 16),
                            
                            // Top 3 Matches Section
                            Text('Top 3 Alternatives',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: primaryDeep,
                                )),
                            const SizedBox(height: 12),
                            if (result.top3.isNotEmpty)
                              ...result.top3.asMap().entries.map((e) {
                                final rank = e.key + 1;
                                final crop = e.value;
                                final isFirst = rank == 1;
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: isFirst ? const Color(0xFFE0F2F1) : Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(16),
                                    border: isFirst ? Border.all(color: accentMint, width: 1.5) : null,
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 14,
                                        backgroundColor: isFirst ? primaryDeep : Colors.grey.shade300,
                                        child: Text('$rank', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                                      ),
                                      const SizedBox(width: 14),
                                      
                                      // 🌟 MINI EMOJI BOX FOR ALTERNATIVES
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)
                                          ]
                                        ),
                                        child: Text(_getCropEmoji(crop.crop), style: const TextStyle(fontSize: 22)),
                                      ),
                                      
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(crop.crop,
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                                color: primaryDeep)),
                                      ),
                                      Text(
                                        '${crop.confidence.toStringAsFixed(1)}%',
                                        style: GoogleFonts.poppins(
                                          color: primaryDeep,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            
                            const SizedBox(height: 24),
                            
                            // Action Button
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.popUntil(context, (route) => route.isFirst);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryDeep,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  elevation: 0,
                                ),
                                child: Text('Test Another Field',
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5)),
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
        ),
      ),
    );
  }
}