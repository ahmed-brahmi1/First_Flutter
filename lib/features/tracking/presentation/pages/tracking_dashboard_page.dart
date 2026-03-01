import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../config/theme.dart';
import '../../../../config/routes.dart';
import '../bloc/tracking_bloc.dart';
import '../bloc/tracking_event.dart';
import '../bloc/tracking_state.dart';
import '../widgets/geofence_setup_dialog.dart';
import '../widgets/route_history_widget.dart';
import '../../domain/entities/geofence.dart';

class TrackingDashboardPage extends StatefulWidget {
  const TrackingDashboardPage({super.key});

  @override
  State<TrackingDashboardPage> createState() => _TrackingDashboardPageState();
}

class _TrackingDashboardPageState extends State<TrackingDashboardPage> {
  bool _showHistory = false;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    // Load initial data when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrackingBloc>().add(const LoadRealtimeLocation());
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracking Dashboard'),
        actions: [
          IconButton(
            icon: Icon(_showHistory ? Icons.map : Icons.history),
            onPressed: () {
              setState(() {
                _showHistory = !_showHistory;
              });
            },
            tooltip: _showHistory ? 'Show Map' : 'Show History',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.settings);
            },
          ),
        ],
      ),
      body: BlocBuilder<TrackingBloc, TrackingState>(
        builder: (context, state) {
          if (state is TrackingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TrackingError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TrackingBloc>().add(const LoadRealtimeLocation());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is TrackingLoaded) {
            if (_showHistory) {
              return RouteHistoryWidget(
                locationHistory: state.locationHistory ?? [],
              );
            }

            return Column(
              children: [
                Expanded(
                  flex: 5,
                  child: _buildMap(state),
                ),
                Expanded(
                  flex: 4,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildQuickStats(state),
                          const SizedBox(height: 16),
                          if (state.geofences != null && state.geofences!.isNotEmpty)
                            _buildGeofencesCard(state.geofences!),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No location data'));
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'geofence',
            onPressed: () {
              _showGeofenceSetup(context);
            },
            backgroundColor: AppTheme.accentYellow,
            child: const Icon(Icons.add_location_alt, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'recenter',
            onPressed: () {
              final state = context.read<TrackingBloc>().state;
              if (state is TrackingLoaded) {
                _mapController.move(
                  LatLng(state.currentLocation.latitude, state.currentLocation.longitude),
                  15.0,
                );
              }
            },
            backgroundColor: Colors.white,
            child: const Icon(Icons.my_location, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'refresh',
            onPressed: () {
              context.read<TrackingBloc>().add(const LoadRealtimeLocation());
            },
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  Widget _buildMap(TrackingLoaded state) {
    final currentLatLng = LatLng(
      state.currentLocation.latitude,
      state.currentLocation.longitude,
    );

    final markers = <Marker>[
      Marker(
        point: currentLatLng,
        width: 80,
        height: 80,
        child: Column(
          children: [
            const Icon(
              Icons.location_on,
              size: 40,
              color: AppTheme.accentYellow,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Current',
                style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    ];

    final circles = <CircleMarker>[];
    if (state.geofences != null) {
      for (final geofence in state.geofences!) {
        circles.add(
          CircleMarker(
            point: LatLng(geofence.latitude, geofence.longitude),
            radius: geofence.radius,
            useRadiusInMeter: true,
            color: AppTheme.primaryBlue.withOpacity(0.3),
            borderColor: AppTheme.primaryBlue,
            borderStrokeWidth: 2,
          ),
        );
        markers.add(
          Marker(
            point: LatLng(geofence.latitude, geofence.longitude),
            width: 80,
            height: 80,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_city, color: AppTheme.primaryBlue, size: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 2)],
                  ),
                  child: Text(
                    geofence.name,
                    style: const TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    if (state.currentLocation.accuracy != null) {
      circles.add(
        CircleMarker(
          point: currentLatLng,
          radius: state.currentLocation.accuracy!,
          useRadiusInMeter: true,
          color: AppTheme.accentYellow.withOpacity(0.2),
          borderColor: AppTheme.accentYellow,
          borderStrokeWidth: 1,
        ),
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: currentLatLng,
          initialZoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.smartpet',
          ),
          CircleLayer(circles: circles),
          MarkerLayer(markers: markers),
        ],
      ),
    );
  }

  Widget _buildGeofencesCard(List<Geofence> geofences) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_searching, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                const Text(
                  'Active Geofences',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...geofences.map((geofence) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: geofence.isActive
                        ? AppTheme.accentYellow
                        : Colors.grey,
                    child: Icon(
                      geofence.isActive ? Icons.check : Icons.close,
                      color: Colors.black87,
                    ),
                  ),
                  title: Text(geofence.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Radius: ${geofence.radius.toStringAsFixed(0)}m'),
                  trailing: Switch(
                    value: geofence.isActive,
                    onChanged: (value) {
                      // TODO: Implement toggle
                    },
                    activeThumbColor: AppTheme.primaryBlue,
                  ),
                  onTap: () {
                    // Pan to geofence
                    _mapController.move(
                      LatLng(geofence.latitude, geofence.longitude),
                      16.0,
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(TrackingLoaded state) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quick Stats',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Updated: ${_formatTime(state.currentLocation.timestamp)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildStatItem(
                  'Locations',
                  '${state.locationHistory?.length ?? 0}',
                  Icons.location_history,
                  AppTheme.primaryBlue,
                )),
                Expanded(child: _buildStatItem(
                  'Geofences',
                  '${state.geofences?.length ?? 0}',
                  Icons.location_searching,
                  AppTheme.accentYellow,
                )),
                Expanded(child: _buildStatItem(
                  'Recent',
                  state.geofences != null && state.geofences!.isNotEmpty 
                      ? state.geofences!.last.name 
                      : 'None',
                  Icons.place,
                  Colors.orangeAccent,
                )),
                Expanded(child: _buildStatItem(
                  'Status',
                  'Active',
                  Icons.check_circle,
                  Colors.green,
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _showGeofenceSetup(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => GeofenceSetupDialog(
        onSave: (name, latitude, longitude, radius) {
          Navigator.pop(dialogContext);
          
          final geofence = Geofence(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: name,
            latitude: latitude,
            longitude: longitude,
            radius: radius,
            isActive: true,
          );
          
          context.read<TrackingBloc>().add(SetGeofenceRequested(geofence));
          
          // Pan map to new geofence
          _mapController.move(LatLng(latitude, longitude), 15.0);
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Geofence "$name" created'),
              backgroundColor: AppTheme.accentYellow,
              duration: const Duration(seconds: 3),
            ),
          );
        },
      ),
    );
  }
}
