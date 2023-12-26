import 'package:drift/drift.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:haltia_test/drift/drift_database.dart';
import 'package:haltia_test/drift/drift_messages.dart';
import 'package:haltia_test/storage/storage.dart';

final class MessagesDriftStorage implements Storage<types.TextMessage> {
  final AppDatabase database = AppDatabase();

  @override
  Stream<List<types.TextMessage>> get allItemsStream {
    final query = database.select(database.driftMessages)
      ..orderBy([
        (t) => OrderingTerm(
              expression: t.createdAt,
              mode: OrderingMode.desc,
            )
      ]);
    return query.map((driftMessage) => MessageConverter.fromDrift(driftMessage)).watch();
  }

  @override
  Future<List<types.TextMessage>> getAll() async {
    List<DriftMessage> allItems = await database.select(database.driftMessages).get();
    return allItems.map((driftMessage) => MessageConverter.fromDrift(driftMessage)).toList();
  }

  @override
  Future<types.TextMessage> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<void> initialize() async {}

  @override
  Future<void> insert(types.TextMessage item) async {
    await database.into(database.driftMessages).insert(item.toDrift());
  }
}
