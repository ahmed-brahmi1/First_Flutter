import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/audio_repository.dart';

class SendVoiceCommand implements UseCase<void, SendVoiceCommandParams> {
  final AudioRepository repository;

  SendVoiceCommand(this.repository);

  @override
  Future<Either<Failure, void>> call(SendVoiceCommandParams params) async {
    return await repository.sendVoiceCommand(params.command);
  }
}

class SendVoiceCommandParams {
  final String command;

  SendVoiceCommandParams({required this.command});
}

