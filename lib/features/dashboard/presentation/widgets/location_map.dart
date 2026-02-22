import 'package:flutter/material.dart';
import '../../domain/entities/location.dart';

class LocationMap extends StatelessWidget {
  final Location location;

  const LocationMap({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Location',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.map, size: 48, color: Colors.grey),
                    const SizedBox(height: 8),
                    Text(
                      'Lat: ${location.latitude.toStringAsFixed(6)}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Lng: ${location.longitude.toStringAsFixed(6)}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: ${location.timestamp.hour}:${location.timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

