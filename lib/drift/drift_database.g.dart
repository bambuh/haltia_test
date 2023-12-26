// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
class $DriftMessagesTable extends DriftMessages
    with TableInfo<$DriftMessagesTable, DriftMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _authorIdMeta =
      const VerificationMeta('authorId');
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
      'author_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [authorId, createdAt, id, body, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drift_messages';
  @override
  VerificationContext validateIntegrity(Insertable<DriftMessage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('author_id')) {
      context.handle(_authorIdMeta,
          authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta));
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  DriftMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftMessage(
      authorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at']),
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $DriftMessagesTable createAlias(String alias) {
    return $DriftMessagesTable(attachedDatabase, alias);
  }
}

class DriftMessage extends DataClass implements Insertable<DriftMessage> {
  final String authorId;
  final int? createdAt;
  final String id;
  final String body;
  final int? updatedAt;
  const DriftMessage(
      {required this.authorId,
      this.createdAt,
      required this.id,
      required this.body,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['author_id'] = Variable<String>(authorId);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(createdAt);
    }
    map['id'] = Variable<String>(id);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(updatedAt);
    }
    return map;
  }

  DriftMessagesCompanion toCompanion(bool nullToAbsent) {
    return DriftMessagesCompanion(
      authorId: Value(authorId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      id: Value(id),
      body: Value(body),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory DriftMessage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftMessage(
      authorId: serializer.fromJson<String>(json['authorId']),
      createdAt: serializer.fromJson<int?>(json['createdAt']),
      id: serializer.fromJson<String>(json['id']),
      body: serializer.fromJson<String>(json['body']),
      updatedAt: serializer.fromJson<int?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'authorId': serializer.toJson<String>(authorId),
      'createdAt': serializer.toJson<int?>(createdAt),
      'id': serializer.toJson<String>(id),
      'body': serializer.toJson<String>(body),
      'updatedAt': serializer.toJson<int?>(updatedAt),
    };
  }

  DriftMessage copyWith(
          {String? authorId,
          Value<int?> createdAt = const Value.absent(),
          String? id,
          String? body,
          Value<int?> updatedAt = const Value.absent()}) =>
      DriftMessage(
        authorId: authorId ?? this.authorId,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        id: id ?? this.id,
        body: body ?? this.body,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('DriftMessage(')
          ..write('authorId: $authorId, ')
          ..write('createdAt: $createdAt, ')
          ..write('id: $id, ')
          ..write('body: $body, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(authorId, createdAt, id, body, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftMessage &&
          other.authorId == this.authorId &&
          other.createdAt == this.createdAt &&
          other.id == this.id &&
          other.body == this.body &&
          other.updatedAt == this.updatedAt);
}

class DriftMessagesCompanion extends UpdateCompanion<DriftMessage> {
  final Value<String> authorId;
  final Value<int?> createdAt;
  final Value<String> id;
  final Value<String> body;
  final Value<int?> updatedAt;
  final Value<int> rowid;
  const DriftMessagesCompanion({
    this.authorId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.id = const Value.absent(),
    this.body = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DriftMessagesCompanion.insert({
    required String authorId,
    this.createdAt = const Value.absent(),
    required String id,
    required String body,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : authorId = Value(authorId),
        id = Value(id),
        body = Value(body);
  static Insertable<DriftMessage> custom({
    Expression<String>? authorId,
    Expression<int>? createdAt,
    Expression<String>? id,
    Expression<String>? body,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (authorId != null) 'author_id': authorId,
      if (createdAt != null) 'created_at': createdAt,
      if (id != null) 'id': id,
      if (body != null) 'body': body,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DriftMessagesCompanion copyWith(
      {Value<String>? authorId,
      Value<int?>? createdAt,
      Value<String>? id,
      Value<String>? body,
      Value<int?>? updatedAt,
      Value<int>? rowid}) {
    return DriftMessagesCompanion(
      authorId: authorId ?? this.authorId,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      body: body ?? this.body,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftMessagesCompanion(')
          ..write('authorId: $authorId, ')
          ..write('createdAt: $createdAt, ')
          ..write('id: $id, ')
          ..write('body: $body, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $DriftMessagesTable driftMessages = $DriftMessagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [driftMessages];
}
