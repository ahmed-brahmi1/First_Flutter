import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme.dart';
import '../../../../config/routes.dart';
import '../bloc/tracking_bloc.dart';
import '../bloc/tracking_event.dart';
import '../bloc/tracking_state.dart';
import '../widgets/geofence_setup_dialog.dart';
import '../widgets/route_history_widget.dart';

class TrackingDashboardPage extends StatefulWidget {
  const TrackingDashboardPage({super.key});

  @override
  State<TrackingDashboardPage> createState() => _TrackingDashboardPageState();
}

class _TrackingDashboardPageState extends State<TrackingDashboardPage> {
  bool _showHistory = false;

  @override
  void initState() {
    super.initState();
    // Load initial data when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrackingBloc>().add(const LoadRealtimeLocation());
    });
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

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Current Location Card
                  _buildLocationCard(state),
                  const SizedBox(height: 16),
                  // Geofences Card
                  if (state.geofences != null && state.geofences!.isNotEmpty)
                    _buildGeofencesCard(state.geofences!),
                  const SizedBox(height: 16),
                  // Quick Stats
                  _buildQuickStats(state),
                ],
              ),
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

  Widget _buildLocationCard(TrackingLoaded state) {
    return Card(
      elevation: 4,
      color: AppTheme.primaryBlue,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(
              Icons.location_on,
              size: 64,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            const Text(
              'Current Location',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Lat: ${state.currentLocation.latitude.toStringAsFixed(6)}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            Text(
              'Lng: ${state.currentLocation.longitude.toStringAsFixed(6)}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            if (state.currentLocation.accuracy != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Accuracy: ${state.currentLocation.accuracy!.toStringAsFixed(1)}m',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Text(
              'Last updated: ${_formatTime(state.currentLocation.timestamp)}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeofencesCard(List geofences) {
    return Card(
      elevation: 4,
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
                  leading: CircleAvatar(
                    backgroundColor: geofence.isActive
                        ? AppTheme.accentYellow
                        : Colors.grey,
                    child: Icon(
                      geofence.isActive ? Icons.check : Icons.close,
                      color: Colors.black87,
                    ),
                  ),
                  title: Text(geofence.name),
                  subtitle: Text('Radius: ${geofence.radius.toStringAsFixed(0)}m'),
                  trailing: Switch(
                    value: geofence.isActive,
                    onChanged: (value) {
                      // TODO: Implement toggle
                    },
                    activeThumbColor: AppTheme.primaryBlue,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(TrackingLoaded state) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Stats',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Locations',
                  '${state.locationHistory?.length ?? 0}',
                  Icons.location_history,
                  AppTheme.primaryBlue,
                ),
                _buildStatItem(
                  'Geofences',
                  '${state.geofences?.length ?? 0}',
                  Icons.location_searching,
                  AppTheme.accentYellow,
                ),
                _buildStatItem(
                  'Status',
                  'Active',
                  Icons.check_circle,
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
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

