import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haltia_test/utils/extended_bloc.dart';

class ExtendedBlocConsumer<B extends ExtendedBloc<dynamic, S, C>, S, C> extends StatefulWidget {
  const ExtendedBlocConsumer({
    Key? key,
    required this.builder,
    required this.listener,
    this.commandListener,
    this.bloc,
    this.buildWhen,
    this.listenWhen,
  }) : super(key: key);

  final B? bloc;
  final BlocWidgetBuilder<S> builder;
  final BlocWidgetListener<S> listener;
  final BlocBuilderCondition<S>? buildWhen;
  final BlocListenerCondition<S>? listenWhen;
  final void Function(BuildContext context, C command)? commandListener;

  @override
  State<ExtendedBlocConsumer<B, S, C>> createState() => _BlocConsumerState<B, S, C>();
}

class _BlocConsumerState<B extends ExtendedBloc<dynamic, S, C>, S, C> extends State<ExtendedBlocConsumer<B, S, C>> {
  late B _bloc;
  late final StreamSubscription<C> _commandSubscription;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? context.read<B>();
    _commandSubscription = _bloc.commands.listen(_onCommandReceived);
  }

  @override
  void dispose() {
    _commandSubscription.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(ExtendedBlocConsumer<B, S, C> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldBloc = oldWidget.bloc ?? context.read<B>();
    final currentBloc = widget.bloc ?? oldBloc;
    if (oldBloc != currentBloc) _bloc = currentBloc;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = widget.bloc ?? context.read<B>();
    if (_bloc != bloc) _bloc = bloc;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bloc == null) {
      context.select<B, bool>((bloc) => identical(_bloc, bloc));
    }
    return BlocBuilder<B, S>(
      bloc: _bloc,
      builder: widget.builder,
      buildWhen: (previous, current) {
        if (widget.listenWhen?.call(previous, current) ?? true) {
          widget.listener(context, current);
        }
        return widget.buildWhen?.call(previous, current) ?? true;
      },
    );
  }

  void _onCommandReceived(C command) => widget.commandListener?.call(context, command);
}
