import 'package:flutter/material.dart';
import '../../domain/entities/feeding_schedule.dart';

class ScheduleList extends StatelessWidget {
  final List<FeedingSchedule> schedules;

  const ScheduleList({super.key, required this.schedules});

  @override
  Widget build(BuildContext context) {
    if (schedules.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No feeding schedules set'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Feeding Schedules',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...schedules.map((schedule) => Card(
              child: ListTile(
                leading: const Icon(Icons.schedule),
                title: Text(
                  '${schedule.time.hour}:${schedule.time.minute.toString().padLeft(2, '0')} - ${schedule.amount}g',
                ),
                subtitle: Text(
                  'Days: ${schedule.daysOfWeek.join(", ")}',
                ),
                trailing: Switch(
                  value: schedule.isActive,
                  onChanged: (value) {
                    // TODO: Implement toggle schedule
                  },
                ),
              ),
            )),
      ],
    );
  }
}

