import 'package:drift/drift.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:haltia_test/drift/drift_database.dart';

@DataClassName('DriftMessage')
class DriftMessages extends Table {
  TextColumn get authorId => text()();
  IntColumn get createdAt => integer().nullable()();
  TextColumn get id => text().unique()();
  TextColumn get body => text()();
  IntColumn get updatedAt => integer().nullable()();
}

extension MessageConverter on TextMessage {
  static TextMessage fromDrift(DriftMessage driftMessage) {
    return TextMessage(
      author: User(id: driftMessage.authorId),
      createdAt: driftMessage.createdAt,
      id: driftMessage.id,
      text: driftMessage.body,
      updatedAt: driftMessage.updatedAt,
    );
  }

  DriftMessage toDrift() {
    return DriftMessage(
      authorId: author.id,
      id: id,
      body: text,
      updatedAt: updatedAt,
      createdAt: createdAt,
    );
  }
}
