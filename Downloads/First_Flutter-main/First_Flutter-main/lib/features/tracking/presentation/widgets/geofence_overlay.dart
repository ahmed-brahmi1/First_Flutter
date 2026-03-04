import 'package:flutter/material.dart';
import '../../domain/entities/geofence.dart';

class GeofenceOverlay extends StatelessWidget {
  final List<Geofence> geofences;

  const GeofenceOverlay({super.key, required this.geofences});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      right: 16,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Geofences',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...geofences.map((geofence) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Icon(
                          geofence.isActive ? Icons.circle : Icons.circle_outlined,
                          size: 16,
                          color: geofence.isActive ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(geofence.name),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

