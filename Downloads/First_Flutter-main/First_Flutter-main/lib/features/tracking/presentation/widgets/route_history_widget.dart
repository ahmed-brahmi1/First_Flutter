import 'package:flutter/material.dart';
import '../../../../config/theme.dart';
import '../../../dashboard/domain/entities/location.dart';

class RouteHistoryWidget extends StatelessWidget {
  final List<Location> locationHistory;

  const RouteHistoryWidget({super.key, required this.locationHistory});

  @override
  Widget build(BuildContext context) {
    if (locationHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No route history available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: locationHistory.length,
      itemBuilder: (context, index) {
        final location = locationHistory[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryBlue,
              child: const Icon(Icons.location_on, color: Colors.white),
            ),
            title: Text(
              _formatDateTime(location.timestamp),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Lat: ${location.latitude.toStringAsFixed(6)}\n'
              'Lng: ${location.longitude.toStringAsFixed(6)}',
            ),
            trailing: location.accuracy != null
                ? Chip(
                    label: Text('${location.accuracy!.toStringAsFixed(0)}m'),
                    backgroundColor: AppTheme.lightBlue.withOpacity(0.3),
                  )
                : null,
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

