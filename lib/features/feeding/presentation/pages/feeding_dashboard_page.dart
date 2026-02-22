import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme.dart';
import '../../../../config/routes.dart';
import '../bloc/feeding_bloc.dart';
import '../bloc/feeding_event.dart';
import '../bloc/feeding_state.dart';
import '../widgets/schedule_list.dart';
import '../widgets/feed_button.dart';

class FeedingDashboardPage extends StatefulWidget {
  const FeedingDashboardPage({super.key});

  @override
  State<FeedingDashboardPage> createState() => _FeedingDashboardPageState();
}

class _FeedingDashboardPageState extends State<FeedingDashboardPage> {
  @override
  void initState() {
    super.initState();
    // Load initial data when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedingBloc>().add(const LoadFeedingLogs());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feeding Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.settings);
            },
          ),
        ],
      ),
      body: BlocListener<FeedingBloc, FeedingState>(
        listener: (context, state) {
          if (state is FeedingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is FeedingSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.accentYellow,
              ),
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
                  child: const Text('Load Feeding Dashboard'),
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<FeedingBloc>().add(const LoadFeedingLogs());
        },
        icon: const Icon(Icons.refresh),
        label: const Text('Refresh'),
        backgroundColor: AppTheme.accentYellow,
        foregroundColor: Colors.black87,
      ),
    );
  }

  Widget _buildFoodLevelIndicator() {
    const double foodLevel = 65.0; // Percentage
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.fastfood, color: AppTheme.accentYellow, size: 28),
                    const SizedBox(width: 8),
                    const Text(
                      'Food Level',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${foodLevel.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 24,
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
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: foodLevel / 100,
                minHeight: 24,
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
                fontSize: 14,
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
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.water_drop, color: AppTheme.primaryBlue, size: 28),
                    const SizedBox(width: 8),
                    const Text(
                      'Water Level',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${waterLevel.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 24,
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
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: waterLevel / 100,
                minHeight: 24,
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
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

