import 'package:haltia_test/whisper/models/_models.dart';

class TranscribeResult {
  const TranscribeResult({
    required this.transcription,
    required this.time,
  });
  final WhisperTranscribeResponse transcription;
  final Duration time;
}
