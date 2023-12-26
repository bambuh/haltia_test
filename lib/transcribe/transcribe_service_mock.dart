import 'package:haltia_test/transcribe/transcribe_service.dart';

class TranscribeServiceMock implements TranscribeService {
  @override
  Future<void> load() async {}

  @override
  Future<String> transcribe(String filePath) {
    return Future.delayed(
      const Duration(seconds: 3),
      () => 'Some transcribed text',
    );
  }
}
