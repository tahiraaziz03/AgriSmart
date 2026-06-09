import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/crop_result.dart';

class ApiService {
  // Emulator ke liye yeh IP hai
  static const String baseUrl = 'http://localhost:8000';

  static Future<CropResult> predictCrop({
    required double nitrogen,
    required double phosphorus,
    required double potassium,
    required double temperature,
    required double humidity,
    required double ph,
    required double rainfall,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/predict'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nitrogen': nitrogen,
        'phosphorus': phosphorus,
        'potassium': potassium,
        'temperature': temperature,
        'humidity': humidity,
        'ph': ph,
        'rainfall': rainfall,
      }),
    );

    if (response.statusCode == 200) {
      return CropResult.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed: ${response.body}');
    }
  }
}