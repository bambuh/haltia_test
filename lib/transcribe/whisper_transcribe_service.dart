import 'package:haltia_test/transcribe/transcribe_service.dart';
import 'package:haltia_test/utils/tracer.dart';
import 'package:haltia_test/whisper/whisper_flutter_plus.dart';

class WhisperTranscribeService implements TranscribeService {
  static const tag = 'WhisperTranscribeService';
  static const WhisperModel model = WhisperModel.tinyEn;
  final Whisper whisper = const Whisper(model: model);

  @override
  Future<void> load() async {
    whisper.initModel();
  }

  @override
  Future<String> transcribe(String filePath) async {
    final DateTime start = DateTime.now();

    try {
      final WhisperTranscribeResponse transcription = await whisper.transcribe(
        transcribeRequest: TranscribeRequest(
          audio: filePath,
          language: 'en',
          isTranslate: false,
          isNoTimestamps: true,
          splitOnWord: false,
        ),
      );

      final Duration transcriptionDuration = DateTime.now().difference(start);
      trace(tag, 'Transcribing took $transcriptionDuration');
      return transcription.text;
    } catch (e) {
      trace(tag, e.toString(), level: TraceLevel.error);
      return '';
    }
  }
}
