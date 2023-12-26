import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:haltia_test/chat_page/chat_user.dart';
import 'package:haltia_test/chat_page/input_widget/input_widget_commands.dart';
import 'package:haltia_test/chat_page/input_widget/input_widget_events.dart';
import 'package:haltia_test/chat_page/input_widget/input_widget_states.dart';
import 'package:haltia_test/repositories/messages_repository.dart';
import 'package:haltia_test/repositories/user_repository.dart';
import 'package:haltia_test/transcribe/transcribe_service.dart';
import 'package:haltia_test/utils/extended_bloc.dart';
import 'package:haltia_test/utils/tracer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

final class InputWidgetBloc extends ExtendedBloc<InputWidgetEvent, InputWidgetState, InputWidgetCommand> {
  static const tag = 'InputWidgetBloc';

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
    on<InputWidgetEventRecordPressed>((event, emit) async {
      try {
        if (!await _recorder.hasPermission()) {
          addError('No permissions');
          return;
        }
        final Directory appDirectory = await getApplicationDocumentsDirectory();

        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.pcm16bits,
            sampleRate: 16000,
          ),
          path: '${appDirectory.path}/myFile.wav',
        );
        if (isClosed) return;
        emit(InputWidgetStateRecording());
      } catch (e) {
        addError(e);
      }
    });
    on<InputWidgetEventStopRecordPressed>((event, emit) async {
      try {
        final audioFilePath = await _recorder.stop();
        if (audioFilePath != null) {
          emit(InputWidgetStateTranscribing());
          final transcription = await _transcribeService.transcribe(audioFilePath);
          if (isClosed) return;
          if (transcription.isNotEmpty) {
            command(InputWidgetCommandUpdateTextValue(transcription));
            add(InputWidgetEventTranscribed());
          } else {
            emit(InputWidgetStateIdle());
          }
        } else {
          if (isClosed) return;
          addError('Audio not recorded');
          emit(InputWidgetStateIdle());
        }
      } catch (e) {
        addError(e);
      }
    });
    on<InputWidgetEventSendPressed>((event, emit) {
      try {
        final textMessage = types.TextMessage(
          author: _userRepository.user.chatUser,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text: event.inputContent,
        );

        _messagesRepository.add(textMessage);
        command(InputWidgetCommandUpdateTextValue(''));
        emit(InputWidgetStateIdle());
      } catch (e) {
        addError(e);
      }
    });
    on<InputWidgetEventTranscribed>((event, emit) => emit(InputWidgetStateReadyToSend()));
    on<InputWidgetEventInputChanged>(_handleInputChanged);
    _transcribeService.load();
  }

  FutureOr<void> _handleInputChanged(InputWidgetEventInputChanged event, Emitter<InputWidgetState> emit) {
    if (event.inputContent.isEmpty) {
      emit(InputWidgetStateIdle());
    } else if (state is InputWidgetStateIdle) {
      emit(InputWidgetStateReadyToSend());
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    trace(tag, error.toString());
    command(InputWidgetCommandShowError(error));
    super.onError(error, stackTrace);
  }

  @override
  Future<void> close() {
    _recorder.dispose();
    return super.close();
  }
}
