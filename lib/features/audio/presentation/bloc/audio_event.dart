import 'package:equatable/equatable.dart';

abstract class AudioEvent extends Equatable {
  const AudioEvent();

  @override
  List<Object> get props => [];
}

class StartAudioRequested extends AudioEvent {
  const StartAudioRequested();
}

class StopAudioRequested extends AudioEvent {
  const StopAudioRequested();
}

class SendVoiceCommandRequested extends AudioEvent {
  final String command;

  const SendVoiceCommandRequested(this.command);

  @override
  List<Object> get props => [command];
}

