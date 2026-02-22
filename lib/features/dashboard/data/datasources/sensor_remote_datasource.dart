import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sensor_model.dart';

class SensorRemoteDataSource {
  final String baseUrl;

  SensorRemoteDataSource({required this.baseUrl});

  Future<SensorModel> getLatestSensor() async {
    final response = await http.get(
      Uri.parse('$baseUrl/sensor/latest'),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return SensorModel.fromJson(jsonData);
    } else {
      throw Exception("Failed to load sensor data");
    }
  }
}