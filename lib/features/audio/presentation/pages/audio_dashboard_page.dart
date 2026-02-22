import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme.dart';
import '../../../../config/routes.dart';
import '../bloc/audio_bloc.dart';
import '../bloc/audio_event.dart';
import '../bloc/audio_state.dart';

class AudioDashboardPage extends StatefulWidget {
  const AudioDashboardPage({super.key});

  @override
  State<AudioDashboardPage> createState() => _AudioDashboardPageState();
}

class _AudioDashboardPageState extends State<AudioDashboardPage> {
  bool _isRecording = false;
  bool _barkDetectionEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Dashboard'),
        actions: [
          Switch(
            value: _barkDetectionEnabled,
            onChanged: (value) {
              setState(() {
                _barkDetectionEnabled = value;
              });
              if (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bark detection alerts enabled'),
                    backgroundColor: AppTheme.accentYellow,
                  ),
                );
              }
            },
            activeThumbColor: AppTheme.accentYellow,
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.settings);
            },
          ),
        ],
      ),
      body: BlocListener<AudioBloc, AudioState>(
        listener: (context, state) {
          if (state is AudioError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<AudioBloc, AudioState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  // Audio Status Card
                  _buildAudioStatusCard(state),
                  const SizedBox(height: 24),
                  // Control Buttons
                  _buildControlButtons(context, state),
                  const SizedBox(height: 24),
                  // Bark Detection Card
                  if (_barkDetectionEnabled)
                    _buildBarkDetectionCard(),
                  const SizedBox(height: 24),
                  // Audio Stats
                  _buildAudioStats(state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAudioStatusCard(AudioState state) {
    final isActive = state is AudioActive;
    return Card(
      elevation: 4,
      color: isActive ? AppTheme.primaryBlue : Colors.grey[300],
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(
              isActive ? Icons.mic : Icons.mic_none,
              size: 80,
              color: isActive ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              isActive ? 'Audio Active' : 'Audio Inactive',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : Colors.grey[800],
              ),
            ),
            if (isActive) ...[
              const SizedBox(height: 8),
              const Text(
                'Two-way communication enabled',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildControlButtons(BuildContext context, AudioState state) {
    if (state is AudioLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Audio Controls',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (state is! AudioActive)
              ElevatedButton.icon(
                onPressed: () {
                  context.read<AudioBloc>().add(const StartAudioRequested());
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Audio Connection'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            if (state is AudioActive) ...[
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isRecording = !_isRecording;
                  });
                },
                icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                label: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isRecording
                      ? Colors.red
                      : AppTheme.accentYellow,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<AudioBloc>().add(const StopAudioRequested());
                },
                icon: const Icon(Icons.stop),
                label: const Text('End Audio Connection'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBarkDetectionCard() {
    return Card(
      elevation: 4,
      color: AppTheme.accentYellow.withValues(alpha: 0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.pets,
              color: AppTheme.accentYellow,
              size: 40,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bark Detection Active',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'You will receive alerts when your pet barks',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioStats(AudioState state) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Audio Statistics',
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
                  'Status',
                  state is AudioActive ? 'Active' : 'Inactive',
                  Icons.info,
                  state is AudioActive ? Colors.green : Colors.grey,
                ),
                _buildStatItem(
                  'Recording',
                  _isRecording ? 'Yes' : 'No',
                  Icons.mic,
                  _isRecording ? Colors.red : Colors.grey,
                ),
                _buildStatItem(
                  'Bark Detection',
                  _barkDetectionEnabled ? 'On' : 'Off',
                  Icons.pets,
                  _barkDetectionEnabled ? AppTheme.accentYellow : Colors.grey,
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
            fontSize: 18,
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
}

