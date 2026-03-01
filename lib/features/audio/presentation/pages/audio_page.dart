import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme.dart';
import '../bloc/audio_bloc.dart';
import '../bloc/audio_event.dart';
import '../bloc/audio_state.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  bool _isRecording = false;
  bool _barkDetectionEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Two-Way Audio'),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // Two-Way Audio Status
                  Card(
                    color: state is AudioActive
                        ? AppTheme.primaryBlue
                        : Colors.grey[300],
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(
                            state is AudioActive ? Icons.mic : Icons.mic_none,
                            size: 80,
                            color: state is AudioActive
                                ? Colors.white
                                : Colors.grey[600],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state is AudioActive
                                ? 'Audio Active'
                                : 'Audio Inactive',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: state is AudioActive
                                  ? Colors.white
                                  : Colors.grey[800],
                            ),
                          ),
                          if (state is AudioActive) ...[
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
                  ),
                  const SizedBox(height: 32),
                  // Control Buttons
                  if (state is AudioLoading)
                    const CircularProgressIndicator()
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (state is! AudioActive)
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<AudioBloc>().add(
                                    const StartAudioRequested(),
                                  );
                            },
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Start'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
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
                            label: Text(_isRecording ? 'Stop' : 'Record'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isRecording
                                  ? Colors.red
                                  : AppTheme.accentYellow,
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<AudioBloc>().add(
                                    const StopAudioRequested(),
                                  );
                            },
                            icon: const Icon(Icons.stop),
                            label: const Text('End Call'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  const SizedBox(height: 32),
                  // Bark Detection Card
                  if (_barkDetectionEnabled)
                    Card(
                      color: AppTheme.accentYellow.withValues(alpha: 0.2),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.pets,
                              color: AppTheme.accentYellow,
                              size: 32,
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
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'You will receive alerts when your pet barks',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

