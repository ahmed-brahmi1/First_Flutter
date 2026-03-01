import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/audio_repository.dart';

class StartTwoWayAudio implements UseCase<void, NoParams> {
  final AudioRepository repository;

  StartTwoWayAudio(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.startTwoWayAudio();
  }
}

