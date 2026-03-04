import 'package:flutter/material.dart';
import '../../../../config/theme.dart';

class GeofenceSetupDialog extends StatefulWidget {
  final Function(String name, double lat, double lng, double radius) onSave;

  const GeofenceSetupDialog({super.key, required this.onSave});

  @override
  State<GeofenceSetupDialog> createState() => _GeofenceSetupDialogState();
}

class _GeofenceSetupDialogState extends State<GeofenceSetupDialog> {
  final _nameController = TextEditingController();
  final _radiusController = TextEditingController(text: '100');
  double _latitude = 0.0;
  double _longitude = 0.0;

  @override
  void dispose() {
    _nameController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Setup Geofence'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Geofence Name',
                hintText: 'e.g., Home, Park, Vet',
                prefixIcon: Icon(Icons.label),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                      text: _latitude.toStringAsFixed(6),
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Latitude',
                      prefixIcon: Icon(Icons.north),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      _latitude = double.tryParse(value) ?? 0.0;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                      text: _longitude.toStringAsFixed(6),
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Longitude',
                      prefixIcon: Icon(Icons.east),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      _longitude = double.tryParse(value) ?? 0.0;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _radiusController,
              decoration: const InputDecoration(
                labelText: 'Radius (meters)',
                prefixIcon: Icon(Icons.radio_button_checked),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                // TODO: Get current location
                setState(() {
                  _latitude = 37.7749; // Example
                  _longitude = -122.4194; // Example
                });
              },
              icon: const Icon(Icons.my_location),
              label: const Text('Use Current Location'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final radius = double.tryParse(_radiusController.text) ?? 100.0;
            if (_nameController.text.isNotEmpty) {
              widget.onSave(
                _nameController.text,
                _latitude,
                _longitude,
                radius,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryBlue,
          ),
          child: const Text('Create'),
        ),
      ],
    );
  }
}

