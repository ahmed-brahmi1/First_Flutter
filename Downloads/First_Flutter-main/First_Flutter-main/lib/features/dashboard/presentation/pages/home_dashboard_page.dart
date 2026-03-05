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
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'SmartPet',
          style: GoogleFonts.greatVibes(color: const Color(0xFFD4A017), fontSize: 36),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.settings);
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const VideoBackground(),
          Container(
            color: Colors.black.withValues(alpha: 0.35),
          ),
          SafeArea(
            child: BlocBuilder<DashboardBloc, DashboardState>(
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
                return const Center(child: Text('No data available', style: TextStyle(color: Colors.white)));
              }
            },
          ),
        ),
        ],
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
      color: Colors.black.withValues(alpha: 0.6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: const Color(0xFFD4A017).withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: GoogleFonts.greatVibes(
                color: const Color(0xFFD4A017),
                fontSize: 28,
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
                ),
                _buildQuickActionButton(
                  context,
                  icon: Icons.phone,
                  label: 'Call Pet',
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.audio),
                ),
                _buildQuickActionButton(
                  context,
                  icon: Icons.location_on,
                  label: 'Track',
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.map),
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
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD4A017).withValues(alpha: 0.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFFD4A017), size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.playfairDisplay(
                color: const Color(0xFFA9A9A9),
                fontSize: 14,
                fontWeight: FontWeight.w600,
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
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD4A017).withValues(alpha: 0.2)),
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
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFD4A017).withValues(alpha: 0.5)),
                    ),
                    child: Icon(icon, color: const Color(0xFFD4A017), size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: GoogleFonts.greatVibes(
                      fontSize: 28,
                      color: const Color(0xFFD4A017),
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
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFFD4A017), size: 24),
      ),
      title: Text(
        title,
        style: GoogleFonts.playfairDisplay(
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.playfairDisplay(
          fontSize: 13,
          color: const Color(0xFFA9A9A9),
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFFA9A9A9)),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class VideoBackground extends StatefulWidget {
  const VideoBackground({super.key});

  @override
  State<VideoBackground> createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<VideoBackground> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/Dashboard_Background.mp4')
      ..initialize().then((_) {
        _controller.setVolume(0.0);
        _controller.setLooping(true);
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.isInitialized) {
      return SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: VideoPlayer(_controller),
          ),
        ),
      );
    } else {
      return Container(color: Colors.black);
    }
  }
}


