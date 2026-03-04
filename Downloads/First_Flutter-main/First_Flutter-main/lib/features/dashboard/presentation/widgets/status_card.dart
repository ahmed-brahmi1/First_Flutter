import 'package:flutter/material.dart';
import '../../domain/entities/pet_status.dart';

class StatusCard extends StatelessWidget {
  final PetStatus petStatus;

  const StatusCard({super.key, required this.petStatus});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pet Status',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Status:'),
                Chip(
                  label: Text(petStatus.isActive ? 'Active' : 'Inactive'),
                  backgroundColor: petStatus.isActive ? Colors.green : Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Battery Level:'),
                Text('${(petStatus.batteryLevel * 100).toStringAsFixed(0)}%'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Last Update:'),
                Text(
                  '${petStatus.lastUpdate.hour}:${petStatus.lastUpdate.minute.toString().padLeft(2, '0')}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

