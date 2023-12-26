import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

sealed class ChatPageState {}

final class ChatPageStateLoading implements ChatPageState {}

final class ChatPageStateReady implements ChatPageState {
  List<types.TextMessage> messages;

  ChatPageStateReady(this.messages);
}
