sealed class InputWidgetState {}

final class InputWidgetStateIdle implements InputWidgetState {}

final class InputWidgetStateRecording implements InputWidgetState {}

final class InputWidgetStateTranscribing implements InputWidgetState {}

final class InputWidgetStateReadyToSend implements InputWidgetState {}
