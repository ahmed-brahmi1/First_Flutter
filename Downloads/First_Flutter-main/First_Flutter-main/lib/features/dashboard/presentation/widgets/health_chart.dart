import 'package:flutter/material.dart';
import '../../domain/entities/health_data.dart';

class HealthChart extends StatelessWidget {
  final HealthData healthData;

  const HealthChart({super.key, required this.healthData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Health Data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHealthMetric(
                  'Temperature',
                  '${healthData.temperature.toStringAsFixed(1)}°C',
                  Icons.thermostat,
                ),
                _buildHealthMetric(
                  'Heart Rate',
                  '${healthData.heartRate} bpm',
                  Icons.favorite,
                ),
                _buildHealthMetric(
                  'Activity',
                  '${healthData.activityLevel}%',
                  Icons.directions_run,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.blue),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

