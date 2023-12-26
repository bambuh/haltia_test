import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:haltia_test/chat_page/chat_page_bloc.dart';
import 'package:haltia_test/chat_page/input_widget/input_widget.dart';
import 'package:haltia_test/chat_page/input_widget/input_widget_bloc.dart';
import 'package:haltia_test/repositories/user_repository.dart';

final class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ChatPageBloc, ChatPageState>(
        builder: (context, state) {
          return switch (state) {
            ChatPageStateLoading _ => const Center(
                child: CupertinoActivityIndicator(),
              ),
            ChatPageStateReady(:final messages) => Chat(
                messages: messages,
                customBottomWidget: BlocProvider(
                  create: (context) => InputWidgetBloc(
                    transcribeService: context.read(),
                    messagesRepository: context.read(),
                    userRepository: context.read(),
                  ),
                  child: const InputWidget(),
                ),
                onSendPressed: (_) {},
                showUserAvatars: true,
                showUserNames: true,
                user: context.read<UserRepository>().user,
              ),
          };
        },
      ),
    );
  }
}
