import 'package:flutter/material.dart';

class AIInsightCard extends StatelessWidget {
  final Map<String, dynamic> predictions;

  const AIInsightCard({super.key, required this.predictions});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.psychology, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'AI Insights',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (predictions.containsKey('prediction'))
              Text(
                predictions['prediction'] as String? ?? 'No prediction available',
                style: const TextStyle(fontSize: 16),
              ),
            if (predictions.containsKey('confidence'))
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Confidence: ${(predictions['confidence'] as num?)?.toStringAsFixed(2) ?? 'N/A'}%',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

