import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme.dart';
import '../bloc/feeding_bloc.dart';
import '../bloc/feeding_event.dart';
import '../bloc/feeding_state.dart';
import '../widgets/schedule_list.dart';
import '../widgets/feed_button.dart';

class FeedingPage extends StatelessWidget {
  const FeedingPage({super.key});

  Widget _buildFoodLevelIndicator() {
    const double foodLevel = 65.0; // Percentage
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Food Level',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${foodLevel.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: foodLevel < 30
                        ? Colors.red
                        : foodLevel < 50
                            ? AppTheme.accentYellow
                            : Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: foodLevel / 100,
                minHeight: 20,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  foodLevel < 30
                      ? Colors.red
                      : foodLevel < 50
                          ? AppTheme.accentYellow
                          : Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              foodLevel < 30
                  ? '⚠️ Low food level - Please refill soon'
                  : foodLevel < 50
                      ? 'Food level is getting low'
                      : 'Food level is good',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterLevelIndicator() {
    const double waterLevel = 75.0; // Percentage
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Water Level',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${waterLevel.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: waterLevel < 30
                        ? Colors.red
                        : waterLevel < 50
                            ? AppTheme.accentYellow
                            : Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: waterLevel / 100,
                minHeight: 20,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  waterLevel < 30
                      ? Colors.red
                      : waterLevel < 50
                          ? AppTheme.accentYellow
                          : Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              waterLevel < 30
                  ? '⚠️ Low water level - Please refill soon'
                  : waterLevel < 50
                      ? 'Water level is getting low'
                      : 'Water level is good',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feeding'),
      ),
      body: BlocListener<FeedingBloc, FeedingState>(
        listener: (context, state) {
          if (state is FeedingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is FeedingSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<FeedingBloc, FeedingState>(
          builder: (context, state) {
            if (state is FeedingLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FeedingLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Food Level Indicator
                    _buildFoodLevelIndicator(),
                    const SizedBox(height: 16),
                    // Water Level Indicator
                    _buildWaterLevelIndicator(),
                    const SizedBox(height: 16),
                    // Manual Feed Button
                    const FeedButton(),
                    const SizedBox(height: 24),
                    // Schedule List
                    ScheduleList(schedules: state.schedules),
                  ],
                ),
              );
            } else {
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<FeedingBloc>().add(const LoadFeedingLogs());
                  },
                  child: const Text('Load Feeding Schedules'),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

