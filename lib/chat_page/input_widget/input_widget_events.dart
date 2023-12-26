sealed class InputWidgetEvent {}

final class InputWidgetEventSendPressed implements InputWidgetEvent {
  final String inputContent;

  InputWidgetEventSendPressed(this.inputContent);
}

final class InputWidgetEventRecordPressed implements InputWidgetEvent {}

final class InputWidgetEventStopRecordPressed implements InputWidgetEvent {}

final class InputWidgetEventTranscribed implements InputWidgetEvent {}

final class InputWidgetEventInputChanged implements InputWidgetEvent {
  final String inputContent;

  InputWidgetEventInputChanged(this.inputContent);
}
