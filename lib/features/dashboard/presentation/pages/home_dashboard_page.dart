import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/routes.dart';
import '../../../../config/theme.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/status_card.dart';
import '../widgets/location_map.dart';
import '../widgets/health_chart.dart';

class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartPet Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.settings);
            },
          ),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DashboardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DashboardBloc>().add(const LoadDashboardData());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is DashboardLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Quick Actions Section
                  _buildQuickActions(context),
                  const SizedBox(height: 24),
                  
                  // Three Main Sections
                  _buildSectionCard(
                    context,
                    title: 'Monitor Pet',
                    icon: Icons.pets,
                    color: AppTheme.primaryBlue,
                    children: [
                      _buildFeatureTile(
                        context,
                        icon: Icons.location_on,
                        title: 'Tracking Dashboard',
                        subtitle: 'Real-time GPS tracking & geofence',
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.map),
                        color: AppTheme.lightBlue,
                      ),
                      _buildFeatureTile(
                        context,
                        icon: Icons.thermostat,
                        title: 'Health Dashboard',
                        subtitle: 'Temperature, heart rate & AI insights',
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.health),
                        color: AppTheme.lightBlue,
                      ),
                      _buildFeatureTile(
                        context,
                        icon: Icons.mic,
                        title: 'Audio Dashboard',
                        subtitle: 'Two-way communication & bark detection',
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.audio),
                        color: AppTheme.lightBlue,
                      ),
                      _buildFeatureTile(
                        context,
                        icon: Icons.history,
                        title: 'View History',
                        subtitle: 'Activity logs',
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.health),
                        color: AppTheme.lightBlue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  _buildSectionCard(
                    context,
                    title: 'Manage Feeding',
                    icon: Icons.restaurant,
                    color: AppTheme.accentYellow,
                    children: [
                      _buildFeatureTile(
                        context,
                        icon: Icons.restaurant,
                        title: 'Feeding Dashboard',
                        subtitle: 'Food/water levels, schedules & manual feed',
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.feeding),
                        color: AppTheme.lightYellow,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  _buildSectionCard(
                    context,
                    title: 'Configure System',
                    icon: Icons.settings,
                    color: AppTheme.darkBlue,
                    children: [
                      _buildFeatureTile(
                        context,
                        icon: Icons.notifications_active,
                        title: 'Set Alerts',
                        subtitle: 'Notification preferences',
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.alerts),
                        color: AppTheme.lightBlue,
                      ),
                      _buildFeatureTile(
                        context,
                        icon: Icons.location_searching,
                        title: 'Geofence',
                        subtitle: 'Safe zone boundaries',
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.map),
                        color: AppTheme.lightBlue,
                      ),
                      _buildFeatureTile(
                        context,
                        icon: Icons.person,
                        title: 'Profiles',
                        subtitle: 'Pet & user settings',
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.settings),
                        color: AppTheme.lightBlue,
                      ),
                      _buildFeatureTile(
                        context,
                        icon: Icons.notifications,
                        title: 'Notifications',
                        subtitle: 'Push alert settings',
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.alerts),
                        color: AppTheme.lightBlue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Status Overview Cards
                  StatusCard(petStatus: state.petStatus),
                  const SizedBox(height: 16),
                  LocationMap(location: state.location),
                  const SizedBox(height: 16),
                  HealthChart(healthData: state.healthData),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<DashboardBloc>().add(const RefreshDashboardData());
        },
        icon: const Icon(Icons.refresh),
        label: const Text('Refresh'),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      color: AppTheme.primaryBlue,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickActionButton(
                  context,
                  icon: Icons.restaurant,
                  label: 'Feed Now',
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.feeding),
                  color: AppTheme.accentYellow,
                ),
                _buildQuickActionButton(
                  context,
                  icon: Icons.phone,
                  label: 'Call Pet',
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.audio),
                  color: AppTheme.accentYellow,
                ),
                _buildQuickActionButton(
                  context,
                  icon: Icons.location_on,
                  label: 'Track',
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.map),
                  color: AppTheme.accentYellow,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.black87, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: color),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

