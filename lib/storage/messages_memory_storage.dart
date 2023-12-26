import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:haltia_test/storage/storage.dart';
import 'package:rxdart/rxdart.dart';

final class MessagesMemoryStorage implements Storage<types.TextMessage> {
  final BehaviorSubject<List<types.TextMessage>> _messagesSubject = BehaviorSubject.seeded([]);

  @override
  ValueStream<List<types.TextMessage>> get allItemsStream => _messagesSubject.stream;

  @override
  Future<List<types.TextMessage>> getAll() async {
    return _messagesSubject.value;
  }

  @override
  Future<types.TextMessage> getById(String id) async {
    return _messagesSubject.value.firstWhere((element) => element.id == id);
  }

  @override
  Future<void> insert(types.TextMessage item) async {
    final messages = _messagesSubject.value..insert(0, item);
    _messagesSubject.add(messages);
  }

  @override
  Future<void> initialize() async {}
}
