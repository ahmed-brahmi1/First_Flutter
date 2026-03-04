import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/alert.dart';

abstract class AlertRepository {
  Future<Either<Failure, List<Alert>>> getAlerts();
  Future<Either<Failure, void>> markAlertRead(String alertId);
  Future<Either<Failure, void>> subscribePushNotifications(String deviceToken);
}

