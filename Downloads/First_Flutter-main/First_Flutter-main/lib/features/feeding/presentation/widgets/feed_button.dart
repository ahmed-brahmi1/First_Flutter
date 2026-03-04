import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/feeding_bloc.dart';
import '../bloc/feeding_event.dart';
import '../bloc/feeding_state.dart';

class FeedButton extends StatelessWidget {
  const FeedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedingBloc, FeedingState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Manual Feed',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton.icon(
                    onPressed: state is FeedingLoading
                        ? null
                        : () {
                            context.read<FeedingBloc>().add(
                                  const TriggerManualFeedRequested(),
                                );
                          },
                    icon: state is FeedingLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.restaurant, size: 28),
                    label: const Text(
                      'Feed Now',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

