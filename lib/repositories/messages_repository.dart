import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:haltia_test/storage/storage.dart';

final class MessagesRepository {
  final Storage<types.TextMessage> _messagesStorage;

  MessagesRepository({required Storage<types.TextMessage> messagesStorage}) : _messagesStorage = messagesStorage;

  Future<void> initialize() => _messagesStorage.initialize();

  Stream<List<types.TextMessage>> get messages {
    return _messagesStorage.allItemsStream;
  }

  Future<void> add(types.TextMessage message) => _messagesStorage.insert(message);
}
