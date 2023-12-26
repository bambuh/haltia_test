import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:haltia_test/models/user.dart';

extension ChatUser on User {
  types.User get chatUser => types.User(
        id: id,
        firstName: firstName,
        lastName: lastName,
      );
}
