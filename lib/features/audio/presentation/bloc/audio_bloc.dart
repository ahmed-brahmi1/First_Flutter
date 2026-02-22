import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/start_two_way_audio.dart';
import '../../domain/usecases/send_voice_command.dart';
import '../../../../core/usecases/usecase.dart';
import 'audio_event.dart';
import 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final StartTwoWayAudio startTwoWayAudio;
  final SendVoiceCommand sendVoiceCommand;

  AudioBloc({
    required this.startTwoWayAudio,
    required this.sendVoiceCommand,
  }) : super(AudioInitial()) {
    on<StartAudioRequested>(_onStartAudioRequested);
    on<StopAudioRequested>(_onStopAudioRequested);
    on<SendVoiceCommandRequested>(_onSendVoiceCommandRequested);
  }

  Future<void> _onStartAudioRequested(
    StartAudioRequested event,
    Emitter<AudioState> emit,
  ) async {
    emit(AudioLoading());
    final result = await startTwoWayAudio(const NoParams());

    result.fold(
      (failure) => emit(AudioError(failure.message)),
      (_) => emit(const AudioActive()),
    );
  }

  Future<void> _onStopAudioRequested(
    StopAudioRequested event,
    Emitter<AudioState> emit,
  ) async {
    emit(const AudioInactive());
  }

  Future<void> _onSendVoiceCommandRequested(
    SendVoiceCommandRequested event,
    Emitter<AudioState> emit,
  ) async {
    final result = await sendVoiceCommand(
      SendVoiceCommandParams(command: event.command),
    );

    result.fold(
      (failure) => emit(AudioError(failure.message)),
      (_) {
        // Keep current state if command sent successfully
        if (state is AudioActive) {
          emit(const AudioActive());
        }
      },
    );
  }
}

