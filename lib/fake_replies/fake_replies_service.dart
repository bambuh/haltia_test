import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:haltia_test/repositories/messages_repository.dart';
import 'package:uuid/uuid.dart';

class FakeRepliesService extends Bloc<Never, void> {
  final MessagesRepository _messagesRepository;
  int _currentIndex = 0;
  late final Timer _timer;

  FakeRepliesService({
    required MessagesRepository messagesRepository,
  })  : _messagesRepository = messagesRepository,
        super(null) {
    _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      if (_currentIndex < _replies.length - 1) {
        final textMessage = types.TextMessage(
          author: const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ad'),
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text: _replies[_currentIndex],
        );

        _messagesRepository.add(textMessage);
        _currentIndex++;
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  Future<void> close() {
    _timer.cancel();
    return super.close();
  }

  static const _replies = [
    "Hello! Ready for some fun?",
    "Here to keep you entertained!",
    "Today's goal: Make you smile. 😄",
    "Fun fact: I love dad jokes!",
    "I'm a pro at virtual high fives! ✋",
    "Joke time: Why did the tomato turn red? Because it saw the salad dressing!",
    "Guess what? I'm learning to moonwalk. 🌙",
    "Ever heard a bot sing? Maybe another time. 🎤",
    "I'm like coffee: Better with sugar and a little bit nuts. ☕",
    "Let's play a game: Think of any number.",
    "Today's mission: Spread cheer!",
    "Why don't scientists trust atoms? They make up everything!",
    "I'm not arguing, I'm just explaining. 😉",
    "Did you know? Penguins can't fly. I relate. 🐧",
    "Life motto: Keep rolling. Like a roomba. 🤖",
    "Challenge: Try to stump me with a riddle!",
    "Learning guitar, know any good tunes? 🎸",
    "If I had a dollar for every joke I know... I'd be rich! 💰",
    "Deep thought: Is cereal soup? 🥣",
    "Remember, laugh more, worry less! 😆"
  ];
}
