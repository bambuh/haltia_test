import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

abstract interface class BaseCommandBloc<C, S> extends StateStreamable<S> {
  Stream<C> get commands;
}

abstract class ExtendedBloc<E, S, C> extends Bloc<E, S> implements BaseCommandBloc<C, S> {
  final _commandsController = StreamController<C>.broadcast();
  ExtendedBloc(super.initialState);

  @override
  Future<void> close() {
    _commandsController.close();
    return super.close();
  }

  void command(C command) => _commandsController.add(command);

  @override
  Stream<C> get commands => _commandsController.stream;
}

abstract class ExtendedCubit<C, S> extends Cubit<S> implements BaseCommandBloc<C, S> {
  final _commandsController = StreamController<C>.broadcast();

  ExtendedCubit(super.initialState);
  @override
  Future<void> close() {
    _commandsController.close();
    return super.close();
  }

  void command(C command) => _commandsController.add(command);

  @override
  Stream<C> get commands => _commandsController.stream;
}
