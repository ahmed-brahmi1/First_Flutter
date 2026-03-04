import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/alert_repository.dart';

class SubscribePushNotifications implements UseCase<void, SubscribePushNotificationsParams> {
  final AlertRepository repository;

  SubscribePushNotifications(this.repository);

  @override
  Future<Either<Failure, void>> call(SubscribePushNotificationsParams params) async {
    return await repository.subscribePushNotifications(params.deviceToken);
  }
}

class SubscribePushNotificationsParams {
  final String deviceToken;

  SubscribePushNotificationsParams({required this.deviceToken});
}

