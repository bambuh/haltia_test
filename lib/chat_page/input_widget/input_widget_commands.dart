sealed class InputWidgetCommand {}

final class InputWidgetCommandUpdateTextValue implements InputWidgetCommand {
  final String newValue;

  InputWidgetCommandUpdateTextValue(this.newValue);
}
