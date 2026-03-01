import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/pet_status.dart';
import '../repositories/dashboard_repository.dart';

class GetPetStatus implements UseCase<PetStatus, NoParams> {
  final DashboardRepository repository;

  GetPetStatus(this.repository);

  @override
  Future<Either<Failure, PetStatus>> call(NoParams params) async {
    return await repository.getPetStatus();
  }
}

