import 'package:flutter/material.dart';
import '../../../../config/routes.dart';
import '../../../../config/theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _pushNotificationsEnabled = true;
  bool _geofenceAlertsEnabled = true;
  bool _temperatureAlertsEnabled = true;
  bool _feedingAlertsEnabled = true;
  bool _batteryAlertsEnabled = true;
  bool _barkDetectionEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Pet Profile Section
          _buildSectionHeader('Pet Profile'),
          _buildProfileCard(),
          
          // Notification Preferences
          _buildSectionHeader('Notification Preferences'),
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Enable push notifications'),
            value: _pushNotificationsEnabled,
            onChanged: (value) {
              setState(() {
                _pushNotificationsEnabled = value;
              });
            },
            activeColor: AppTheme.primaryBlue,
          ),
          SwitchListTile(
            title: const Text('Geofence Alerts'),
            subtitle: const Text('Alert when pet leaves safe zone'),
            value: _geofenceAlertsEnabled,
            onChanged: (value) {
              setState(() {
                _geofenceAlertsEnabled = value;
              });
            },
            activeColor: AppTheme.primaryBlue,
          ),
          SwitchListTile(
            title: const Text('Temperature Alerts'),
            subtitle: const Text('Alert for abnormal temperature'),
            value: _temperatureAlertsEnabled,
            onChanged: (value) {
              setState(() {
                _temperatureAlertsEnabled = value;
              });
            },
            activeColor: AppTheme.primaryBlue,
          ),
          SwitchListTile(
            title: const Text('Feeding Alerts'),
            subtitle: const Text('Alert for feeding schedule'),
            value: _feedingAlertsEnabled,
            onChanged: (value) {
              setState(() {
                _feedingAlertsEnabled = value;
              });
            },
            activeColor: AppTheme.primaryBlue,
          ),
          SwitchListTile(
            title: const Text('Low Battery Alerts'),
            subtitle: const Text('Alert when device battery is low'),
            value: _batteryAlertsEnabled,
            onChanged: (value) {
              setState(() {
                _batteryAlertsEnabled = value;
              });
            },
            activeColor: AppTheme.primaryBlue,
          ),
          SwitchListTile(
            title: const Text('Bark Detection'),
            subtitle: const Text('Alert when pet barks'),
            value: _barkDetectionEnabled,
            onChanged: (value) {
              setState(() {
                _barkDetectionEnabled = value;
              });
            },
            activeColor: AppTheme.accentYellow,
          ),
          
          // Device Settings
          _buildSectionHeader('Device Settings'),
          ListTile(
            leading: const Icon(Icons.bluetooth, color: AppTheme.primaryBlue),
            title: const Text('Device Pairing'),
            subtitle: const Text('Pair SmartPet device'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showDevicePairingDialog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.fingerprint, color: AppTheme.primaryBlue),
            title: const Text('Biometric Authentication'),
            subtitle: const Text('Enable fingerprint/Face ID login'),
            trailing: Switch(
              value: true, // TODO: Get from preferences
              onChanged: (value) {
                // TODO: Save preference
              },
              activeColor: AppTheme.primaryBlue,
            ),
          ),
          
          // Account Settings
          _buildSectionHeader('Account'),
          ListTile(
            leading: const Icon(Icons.person, color: AppTheme.primaryBlue),
            title: const Text('Edit Profile'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to profile edit
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            onTap: () {
              _showLogoutDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.primaryBlue,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppTheme.primaryBlue,
              child: const Icon(Icons.pets, size: 40, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Max',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Golden Retriever • 3 years old',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: AppTheme.primaryBlue),
              onPressed: () {
                // TODO: Edit profile
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDevicePairingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Device Pairing'),
        content: const Text(
          'Make sure your SmartPet device is powered on and in pairing mode. '
          'The device should appear in the list below.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Searching for devices...')),
              );
            },
            child: const Text('Scan'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout
              Navigator.of(context).pushReplacementNamed(AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

