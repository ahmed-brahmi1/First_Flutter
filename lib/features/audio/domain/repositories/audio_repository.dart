import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class AudioRepository {
  Future<Either<Failure, void>> startTwoWayAudio();
  Future<Either<Failure, void>> sendVoiceCommand(String command);
  Future<Either<Failure, void>> stopAudio();
}

