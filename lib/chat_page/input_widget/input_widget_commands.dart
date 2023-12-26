sealed class InputWidgetCommand {}

final class InputWidgetCommandUpdateTextValue implements InputWidgetCommand {
  final String newValue;

  InputWidgetCommandUpdateTextValue(this.newValue);
}

final class InputWidgetCommandShowError implements InputWidgetCommand {
  final Object error;

  InputWidgetCommandShowError(this.error);
}
