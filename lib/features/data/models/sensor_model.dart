class SensorModel {
  final int id;
  final double temperature;
  final int heartRate;
  final int steps;
  final int healthScore;
  final DateTime createdAt;

  SensorModel({
    required this.id,
    required this.temperature,
    required this.heartRate,
    required this.steps,
    required this.healthScore,
    required this.createdAt,
  });

  factory SensorModel.fromJson(Map<String, dynamic> json) {
    return SensorModel(
      id: json['id'],
      temperature: json['temperature'].toDouble(),
      heartRate: json['heartRate'],
      steps: json['steps'],
      healthScore: json['healthScore'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}