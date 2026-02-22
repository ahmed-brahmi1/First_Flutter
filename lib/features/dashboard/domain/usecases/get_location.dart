import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/location.dart';
import '../repositories/dashboard_repository.dart';

class GetLocation implements UseCase<Location, NoParams> {
  final DashboardRepository repository;

  GetLocation(this.repository);

  @override
  Future<Either<Failure, Location>> call(NoParams params) async {
    return await repository.getLocation();
  }
}

