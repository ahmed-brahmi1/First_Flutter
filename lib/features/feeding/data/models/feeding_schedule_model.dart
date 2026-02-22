import '../../domain/entities/feeding_schedule.dart';

class FeedingScheduleModel extends FeedingSchedule {
  const FeedingScheduleModel({
    required super.id,
    required super.time,
    required super.amount,
    required super.isActive,
    required super.daysOfWeek,
  });

  factory FeedingScheduleModel.fromJson(Map<String, dynamic> json) {
    return FeedingScheduleModel(
      id: json['id'] as String,
      time: DateTime.parse(json['time'] as String),
      amount: (json['amount'] as num).toDouble(),
      isActive: json['is_active'] as bool,
      daysOfWeek: (json['days_of_week'] as List<dynamic>).map((e) => e as int).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time.toIso8601String(),
      'amount': amount,
      'is_active': isActive,
      'days_of_week': daysOfWeek,
    };
  }
}

