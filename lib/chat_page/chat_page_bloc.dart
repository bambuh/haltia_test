import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:haltia_test/chat_page/chat_page_events.dart';
import 'package:haltia_test/chat_page/chat_page_states.dart';
import 'package:haltia_test/repositories/messages_repository.dart';

final class ChatPageBloc extends Bloc<ChatPageEvent, ChatPageState> {
  final MessagesRepository _repository;
  StreamSubscription<List<types.TextMessage>>? _messagesSubscription;

  ChatPageBloc({required MessagesRepository messagesRepository})
      : _repository = messagesRepository,
        super(ChatPageStateLoading()) {
    on<ChatPageEventMessagesUpdated>((event, emit) => emit(ChatPageStateReady(event.messages)));
    on<ChatPageEventMessageSent>((event, emit) => _repository.add(event.message));

    _initializeStorage();
  }

  Future<void> _initializeStorage() async {
    _messagesSubscription = _repository.messages.listen((newMessagesList) {
      add(ChatPageEventMessagesUpdated(newMessagesList));
    });
    await _repository.initialize();
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
