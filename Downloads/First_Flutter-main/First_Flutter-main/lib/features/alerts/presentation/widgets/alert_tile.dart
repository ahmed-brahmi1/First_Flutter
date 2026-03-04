import 'package:flutter/material.dart';
import '../../domain/entities/alert.dart';

class AlertTile extends StatelessWidget {
  final Alert alert;
  final VoidCallback onTap;

  const AlertTile({super.key, required this.alert, required this.onTap});

  IconData _getIconForType(AlertType type) {
    switch (type) {
      case AlertType.geofence:
        return Icons.location_on;
      case AlertType.health:
        return Icons.favorite;
      case AlertType.feeding:
        return Icons.restaurant;
      case AlertType.battery:
        return Icons.battery_alert;
      case AlertType.connection:
        return Icons.wifi_off;
    }
  }

  Color _getColorForType(AlertType type) {
    switch (type) {
      case AlertType.geofence:
        return Colors.orange;
      case AlertType.health:
        return Colors.red;
      case AlertType.feeding:
        return Colors.blue;
      case AlertType.battery:
        return Colors.amber;
      case AlertType.connection:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: alert.isRead ? Colors.grey[100] : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getColorForType(alert.type),
          child: Icon(
            _getIconForType(alert.type),
            color: Colors.white,
          ),
        ),
        title: Text(
          alert.title,
          style: TextStyle(
            fontWeight: alert.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(alert.message),
            const SizedBox(height: 4),
            Text(
              '${alert.timestamp.hour}:${alert.timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: alert.isRead
            ? null
            : const Icon(Icons.circle, size: 8, color: Colors.blue),
        onTap: onTap,
      ),
    );
  }
}

