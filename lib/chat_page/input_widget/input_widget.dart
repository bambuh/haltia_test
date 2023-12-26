import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haltia_test/chat_page/input_widget/input_widget_bloc.dart';
import 'package:haltia_test/chat_page/input_widget/input_widget_commands.dart';
import 'package:haltia_test/chat_page/input_widget/input_widget_events.dart';
import 'package:haltia_test/chat_page/input_widget/input_widget_states.dart';
import 'package:haltia_test/utils/extended_bloc_builder.dart';
import 'package:haltia_test/utils/inkwell.dart';

class InputWidget extends StatefulWidget {
  const InputWidget({super.key});

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          )),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ExtendedBlocBuilder<InputWidgetBloc, InputWidgetState, InputWidgetCommand>(
          builder: (context, state) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onChanged: (value) =>
                        context.read<InputWidgetBloc>().add(InputWidgetEventInputChanged(_controller.text)),
                    enabled: state.inputEnabled,
                    maxLines: null,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.33,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                    decoration: InputDecoration(
                      fillColor: Colors.white.withOpacity(0.2),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                MInkWell(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: 100,
                  onTap: switch (state) {
                    InputWidgetStateIdle _ => () =>
                        context.read<InputWidgetBloc>().add(InputWidgetEventRecordPressed()),
                    InputWidgetStateRecording _ => () =>
                        context.read<InputWidgetBloc>().add(InputWidgetEventStopRecordPressed()),
                    InputWidgetStateTranscribing _ => null,
                    InputWidgetStateReadyToSend _ => () =>
                        context.read<InputWidgetBloc>().add(InputWidgetEventSendPressed(_controller.text)),
                  },
                  padding: const EdgeInsets.all(16),
                  child: state.buttonIcon,
                ),
              ],
            );
          },
          commandListener: (context, command) {
            switch (command) {
              case InputWidgetCommandUpdateTextValue _:
                _controller.value = TextEditingValue(text: command.newValue);
                break;
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

extension _ on InputWidgetState {
  Widget get buttonIcon => switch (this) {
        InputWidgetStateIdle _ => const Icon(
            Icons.mic,
            color: Colors.white,
            size: 24,
          ),
        InputWidgetStateRecording _ => const Icon(
            Icons.stop,
            color: Colors.white,
            size: 24,
          ),
        InputWidgetStateTranscribing _ => const CupertinoActivityIndicator(
            color: Colors.white,
            radius: 12,
          ),
        InputWidgetStateReadyToSend _ => const Icon(
            Icons.send,
            color: Colors.white,
            size: 24,
          ),
      };

  bool get inputEnabled => switch (this) {
        InputWidgetStateIdle _ => true,
        InputWidgetStateReadyToSend _ => true,
        _ => false,
      };
}
