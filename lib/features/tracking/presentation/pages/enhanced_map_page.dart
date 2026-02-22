import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme.dart';
import '../bloc/tracking_bloc.dart';
import '../bloc/tracking_event.dart';
import '../bloc/tracking_state.dart';
import '../widgets/geofence_overlay.dart';
import '../widgets/geofence_setup_dialog.dart';
import '../widgets/route_history_widget.dart';

class EnhancedMapPage extends StatefulWidget {
  const EnhancedMapPage({super.key});

  @override
  State<EnhancedMapPage> createState() => _EnhancedMapPageState();
}

class _EnhancedMapPageState extends State<EnhancedMapPage> {
  bool _showHistory = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS Tracking'),
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

            return Stack(
              children: [
                // Real-time Map
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.lightBlue.withOpacity(0.3),
                        AppTheme.primaryBlue.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 80,
                          color: AppTheme.primaryBlue,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Real-time Location',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Lat: ${state.currentLocation.latitude.toStringAsFixed(6)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Lng: ${state.currentLocation.longitude.toStringAsFixed(6)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Last updated: ${_formatTime(state.currentLocation.timestamp)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Geofence Overlay
                if (state.geofences != null && state.geofences!.isNotEmpty)
                  GeofenceOverlay(geofences: state.geofences!),
                // Location Info Card
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Card(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Current Location',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Icon(
                                Icons.my_location,
                                color: AppTheme.primaryBlue,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoItem(
                                  'Accuracy',
                                  '${state.currentLocation.accuracy?.toStringAsFixed(1) ?? "N/A"} m',
                                  Icons.gps_fixed,
                                ),
                              ),
                              Expanded(
                                child: _buildInfoItem(
                                  'Status',
                                  'Active',
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
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
            child: const Icon(Icons.location_searching, color: Colors.black87),
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

  Widget _buildInfoItem(String label, String value, IconData icon, {Color? color}) {
    return Column(
      children: [
        Icon(icon, color: color ?? AppTheme.primaryBlue, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.black87,
          ),
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
      builder: (context) => GeofenceSetupDialog(
        onSave: (name, latitude, longitude, radius) {
          // TODO: Implement geofence creation
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Geofence "$name" created with ${radius}m radius'),
              backgroundColor: AppTheme.accentYellow,
            ),
          );
        },
      ),
    );
  }
}

