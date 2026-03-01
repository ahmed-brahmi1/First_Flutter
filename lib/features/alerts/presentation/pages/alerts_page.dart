import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/alerts_bloc.dart';
import '../bloc/alerts_event.dart';
import '../bloc/alerts_state.dart';
import '../widgets/alert_tile.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  @override
  void initState() {
    super.initState();
    // Load initial data when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlertsBloc>().add(const LoadAlerts());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AlertsBloc>().add(const LoadAlerts());
            },
          ),
        ],
      ),
      body: BlocBuilder<AlertsBloc, AlertsState>(
        builder: (context, state) {
          if (state is AlertsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AlertsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AlertsBloc>().add(const LoadAlerts());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is AlertsLoaded) {
            if (state.alerts.isEmpty) {
              return const Center(
                child: Text('No alerts available'),
              );
            }
            return ListView.builder(
              itemCount: state.alerts.length,
              itemBuilder: (context, index) {
                return AlertTile(
                  alert: state.alerts[index],
                  onTap: () {
                    context.read<AlertsBloc>().add(
                          MarkAlertReadRequested(state.alerts[index].id),
                        );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No alerts data'));
          }
        },
      ),
    );
  }
}

