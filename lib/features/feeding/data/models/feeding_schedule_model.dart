import '../../domain/entities/feeding_schedule.dart';

class FeedingScheduleModel extends FeedingSchedule {
  const FeedingScheduleModel({
    required super.id,
    required super.time,
    required super.amount,
    required super.isActive,
    required super.daysOfWeek,
    super.deviceId,
  });

  /// From NestJS: id, device_id, time_of_day, portion_grams?, enabled, created_at?
  factory FeedingScheduleModel.fromJson(Map<String, dynamic> json) {
    final timeOfDay = json['time_of_day'] as String? ?? '00:00';
    final time = _parseTimeOfDay(timeOfDay);
    final daysRaw = json['days_of_week'];
    final daysOfWeek = daysRaw is List
        ? (daysRaw.map((e) => (e is num ? e.toInt() : int.parse(e.toString()))).toList())
        : [1, 2, 3, 4, 5, 6, 7];
    return FeedingScheduleModel(
      id: json['id'] as String,
      time: time,
      amount: (json['portion_grams'] as num?)?.toDouble() ?? (json['amount'] as num?)?.toDouble() ?? 0.0,
      isActive: (json['enabled'] as bool?) ?? (json['is_active'] as bool?) ?? true,
      daysOfWeek: daysOfWeek,
      deviceId: json['device_id'] as String?,
    );
  }

  static DateTime _parseTimeOfDay(String timeOfDay) {
    final parts = timeOfDay.split(':');
    final hour = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return DateTime(1970, 1, 1, hour, minute);
  }

  /// For NestJS create/update: device_id, time_of_day, portion_grams, enabled
  Map<String, dynamic> toJson() {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return {
      if (id.isNotEmpty) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      'time_of_day': '$hour:$minute',
      'portion_grams': amount,
      'enabled': isActive,
      'days_of_week': daysOfWeek,
    };
  }
}

