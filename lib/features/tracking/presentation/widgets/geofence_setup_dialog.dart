import 'package:flutter/material.dart';
import '../../../../config/theme.dart';
import '../../../../services/location_service.dart';
import '../../../../services/osm_nominatim_service.dart';

class GeofenceSetupDialog extends StatefulWidget {
  final Function(String name, double lat, double lng, double radius) onSave;

  const GeofenceSetupDialog({super.key, required this.onSave});

  @override
  State<GeofenceSetupDialog> createState() => _GeofenceSetupDialogState();
}

class _GeofenceSetupDialogState extends State<GeofenceSetupDialog> {
  final _searchController = TextEditingController();
  final _nameController = TextEditingController();
  final _radiusController = TextEditingController(text: '100');
  final _latitudeController = TextEditingController(text: 0.0.toStringAsFixed(6));
  final _longitudeController = TextEditingController(text: 0.0.toStringAsFixed(6));

  final _locationService = LocationService();
  final _osmService = OsmNominatimService();

  double _latitude = 0.0;
  double _longitude = 0.0;
  bool _isSearching = false;
  bool _isResolvingLocation = false;
  String? _resolvedPlace;
  String? _locationError;
  String? _searchError;

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _radiusController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _searchAddress() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _searchError = null;
      _resolvedPlace = null;
    });

    final place = await _osmService.searchPlace(query);

    if (!mounted) return;

    setState(() => _isSearching = false);

    if (place != null) {
      _latitude = place.latitude;
      _longitude = place.longitude;
      _latitudeController.text = _latitude.toStringAsFixed(6);
      _longitudeController.text = _longitude.toStringAsFixed(6);

      // Auto-fill name if empty
      if (_nameController.text.isEmpty) {
        _nameController.text = query;
      }

      setState(() {
        _resolvedPlace = place.displayName;
        _searchError = null;
      });
    } else {
      setState(() {
        _searchError = 'Place not found. Try a more specific name (e.g. "Berlin, Germany").';
      });
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() {
      _isResolvingLocation = true;
      _locationError = null;
      _resolvedPlace = null;
    });

    try {
      final position = await _locationService.getCurrentLocation();
      _latitude = position.latitude;
      _longitude = position.longitude;
      _latitudeController.text = _latitude.toStringAsFixed(6);
      _longitudeController.text = _longitude.toStringAsFixed(6);

      final place = await _osmService.reverseGeocode(
        latitude: _latitude,
        longitude: _longitude,
      );

      if (place != null && mounted) {
        setState(() {
          _resolvedPlace = place;
          if (_nameController.text.isEmpty) {
            _nameController.text = place;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _locationError = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResolvingLocation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Setup Geofence'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Search by address ---
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search address or city',
                      hintText: 'e.g., Berlin, Paris, Tokyo',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (_) => _searchAddress(),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSearching ? null : _searchAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: _isSearching
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ],
            ),
            if (_resolvedPlace != null) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _resolvedPlace!,
                        style: const TextStyle(fontSize: 12, color: Colors.green),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (_searchError != null) ...[
              const SizedBox(height: 6),
              Text(_searchError!, style: const TextStyle(fontSize: 12, color: Colors.redAccent)),
            ],
            const Divider(height: 24),
            // --- Geofence name ---
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Geofence Name',
                hintText: 'e.g., Home, Park, Vet',
                prefixIcon: Icon(Icons.label),
              ),
            ),
            const SizedBox(height: 12),
            // --- Lat / Lng readout ---
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _latitudeController,
                    decoration: const InputDecoration(
                      labelText: 'Latitude',
                      prefixIcon: Icon(Icons.north),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      _latitude = double.tryParse(value) ?? 0.0;
                      _resolvedPlace = null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _longitudeController,
                    decoration: const InputDecoration(
                      labelText: 'Longitude',
                      prefixIcon: Icon(Icons.east),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      _longitude = double.tryParse(value) ?? 0.0;
                      _resolvedPlace = null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
              onPressed: _isResolvingLocation ? null : _useCurrentLocation,
              icon: _isResolvingLocation
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location),
              label: const Text('Use Current Location'),
            ),
            if (_locationError != null) ...[
              const SizedBox(height: 8),
              Text(_locationError!, style: const TextStyle(fontSize: 12, color: Colors.redAccent)),
            ],
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
            final name = _nameController.text.trim().isNotEmpty
                ? _nameController.text.trim()
                : _searchController.text.trim();

            if (name.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a name or search for a place first.')),
              );
              return;
            }

            if (_latitude == 0.0 && _longitude == 0.0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please search for a place or enter coordinates first.'),
                  backgroundColor: Colors.orange,
                ),
              );
              return;
            }

            widget.onSave(name, _latitude, _longitude, radius);
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue),
          child: const Text('Create'),
        ),
      ],
    );
  }
}
