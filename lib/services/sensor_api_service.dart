import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sensor_model.dart';

class SensorApiService {
  static const String baseUrl =
      "http://10.0.2.2:8081/api/sensor/latest";

  Future<SensorModel> getLatestSensor() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return SensorModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load sensor data');
    }
  }
}