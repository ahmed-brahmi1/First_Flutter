import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/tracking_bloc.dart';
import '../bloc/tracking_event.dart';
import '../bloc/tracking_state.dart';
import '../widgets/geofence_overlay.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Tracking'),
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
            return Stack(
              children: [
                // Map placeholder
                Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.map, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'Lat: ${state.currentLocation.latitude.toStringAsFixed(6)}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'Lng: ${state.currentLocation.longitude.toStringAsFixed(6)}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.geofences != null && state.geofences!.isNotEmpty)
                  GeofenceOverlay(geofences: state.geofences!),
              ],
            );
          } else {
            return const Center(child: Text('No location data'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<TrackingBloc>().add(const LoadRealtimeLocation());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

