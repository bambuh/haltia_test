import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:haltia_test/chat_page/chat_page.dart';
import 'package:haltia_test/chat_page/chat_page_bloc.dart';
import 'package:haltia_test/repositories/messages_repository.dart';
import 'package:haltia_test/repositories/user_repository.dart';
import 'package:haltia_test/storage/messages_drift_storage.dart';
import 'package:haltia_test/transcribe/transcribe_service.dart';
import 'package:haltia_test/transcribe/transcribe_service_mock.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => MessagesRepository(
              // messagesStorage: MessagesMemoryStorage(),
              messagesStorage: MessagesDriftStorage(),
            ),
          ),
          RepositoryProvider<TranscribeService>(
            create: (context) => TranscribeServiceMock(),
          ),
          RepositoryProvider(
            create: (context) => UserRepository(
              user: const types.User(
                id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
                firstName: 'Oleksii',
                lastName: 'Bukhantsov',
              ),
            ),
          )
        ],
        child: BlocProvider(
          create: (context) => ChatPageBloc(
            messagesRepository: context.read(),
          ),
          child: const ChatPage(),
        ),
      ),
    );
  }
}
