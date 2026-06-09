class CropResult {
  final String recommendedCrop;
  final double confidence;
  final List<TopCrop> top3;
  final String message;

  CropResult({
    required this.recommendedCrop,
    required this.confidence,
    required this.top3,
    required this.message,
  });

  factory CropResult.fromJson(Map<String, dynamic> json) {
    return CropResult(
      recommendedCrop: json['recommended_crop'],
      confidence: json['confidence'].toDouble(),
      top3: (json['top_3'] as List)
          .map((e) => TopCrop.fromJson(e))
          .toList(),
      message: json['message'],
    );
  }
}

class TopCrop {
  final String crop;
  final double confidence;

  TopCrop({required this.crop, required this.confidence});

  factory TopCrop.fromJson(Map<String, dynamic> json) {
    return TopCrop(
      crop: json['crop'],
      confidence: json['confidence'].toDouble(),
    );
  }
}