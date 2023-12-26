import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haltia_test/chat_page/chat_page.dart';
import 'package:haltia_test/chat_page/chat_page_bloc.dart';
import 'package:haltia_test/chat_page/chat_user.dart';
import 'package:haltia_test/models/user.dart';
import 'package:haltia_test/repositories/messages_repository.dart';
import 'package:haltia_test/repositories/user_repository.dart';
import 'package:haltia_test/storage/messages_drift_storage.dart';
import 'package:haltia_test/transcribe/transcribe_service.dart';
import 'package:haltia_test/transcribe/whisper_transcribe_service.dart';
import 'package:haltia_test/utils/tracer.dart';

void main() {
  runZonedGuarded(
    () => runApp(const MainApp()),
    (e, stackTrace) => trace(
      'main',
      e.toString(),
      stackTrace: stackTrace,
      level: TraceLevel.error,
    ),
  );
}

class MainApp extends StatelessWidget {
  static const user = User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
    firstName: 'Oleksii',
    lastName: 'Bukhantsov',
  );

  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => MessagesRepository(
              messagesStorage: MessagesDriftStorage(),
            ),
          ),
          RepositoryProvider<TranscribeService>(
            create: (context) => WhisperTranscribeService(),
          ),
          RepositoryProvider(
            create: (context) => UserRepository(
              user: user,
            ),
          )
        ],
        child: Builder(builder: (context) {
          return BlocProvider(
            create: (context) => ChatPageBloc(
              messagesRepository: context.read(),
            ),
            child: ChatPage(user: context.read<UserRepository>().user.chatUser),
          );
        }),
      ),
    );
  }
}
