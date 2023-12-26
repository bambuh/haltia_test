import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

sealed class ChatPageEvent {}

final class ChatPageEventMessagesUpdated implements ChatPageEvent {
  List<types.TextMessage> messages;

  ChatPageEventMessagesUpdated(this.messages);
}

final class ChatPageEventMessageSent implements ChatPageEvent {
  types.TextMessage message;

  ChatPageEventMessageSent(this.message);
}
