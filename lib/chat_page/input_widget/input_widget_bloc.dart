import 'dart:io';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:haltia_test/repositories/messages_repository.dart';
import 'package:haltia_test/repositories/user_repository.dart';
import 'package:haltia_test/transcribe/transcribe_service.dart';
import 'package:haltia_test/utils/extended_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

final class InputWidgetBloc extends ExtendedBloc<InputWidgetEvent, InputWidgetState, InputWidgetCommand> {
  final TranscribeService _transcribeService;
  final MessagesRepository _messagesRepository;
  final UserRepository _userRepository;
  final _recorder = AudioRecorder();

  InputWidgetBloc({
    required TranscribeService transcribeService,
    required MessagesRepository messagesRepository,
    required UserRepository userRepository,
  })  : _transcribeService = transcribeService,
        _messagesRepository = messagesRepository,
        _userRepository = userRepository,
        super(InputWidgetStateIdle()) {
    on<InputWidgetEventButtonPressed>((event, emit) async {
      switch (state) {
        case InputWidgetStateIdle _:
          if (!await _recorder.hasPermission()) return;
          final Directory appDirectory = await getApplicationDocumentsDirectory();

          await _recorder.start(
            const RecordConfig(
              encoder: AudioEncoder.pcm16bits,
              sampleRate: 16000,
            ),
            path: '${appDirectory.path}/myFile.wav',
          );
          emit(InputWidgetStateRecording());
          break;
        case InputWidgetStateRecording _:
          final audioFilePath = await _recorder.stop();
          if (audioFilePath != null) {
            emit(InputWidgetStateTranscribing());
            _transcribeService.transcribe(audioFilePath).then((value) {
              command(InputWidgetCommandUpdateTextValue(value));
              add(InputWidgetEventTranscribed());
            });
          } else {
            emit(InputWidgetStateIdle());
          }
          break;
        case InputWidgetStateTranscribing _:
          break;
        case InputWidgetStateReadyToSend _:
          final textMessage = types.TextMessage(
            author: _userRepository.user,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: const Uuid().v4(),
            text: event.inputContent,
          );

          _messagesRepository.add(textMessage);
          command(InputWidgetCommandUpdateTextValue(''));
          emit(InputWidgetStateIdle());
          break;
      }
    });
    on<InputWidgetEventTranscribed>((event, emit) {
      emit(InputWidgetStateReadyToSend());
    });
    on<InputWidgetEventInputChanged>((event, emit) {
      if (event.inputContent.isEmpty) {
        emit(InputWidgetStateIdle());
      } else if (state is InputWidgetStateIdle) {
        emit(InputWidgetStateReadyToSend());
      }
    });
    _transcribeService.load();
  }

  @override
  Future<void> close() {
    _recorder.dispose();
    return super.close();
  }
}

sealed class InputWidgetEvent {}

final class InputWidgetEventButtonPressed implements InputWidgetEvent {
  final String inputContent;

  InputWidgetEventButtonPressed(this.inputContent);
}

final class InputWidgetEventTranscribed implements InputWidgetEvent {}

final class InputWidgetEventInputChanged implements InputWidgetEvent {
  final String inputContent;

  InputWidgetEventInputChanged(this.inputContent);
}

sealed class InputWidgetState {}

final class InputWidgetStateIdle implements InputWidgetState {}

final class InputWidgetStateRecording implements InputWidgetState {}

final class InputWidgetStateTranscribing implements InputWidgetState {}

final class InputWidgetStateReadyToSend implements InputWidgetState {}

sealed class InputWidgetCommand {}

final class InputWidgetCommandUpdateTextValue implements InputWidgetCommand {
  final String newValue;

  InputWidgetCommandUpdateTextValue(this.newValue);
}
