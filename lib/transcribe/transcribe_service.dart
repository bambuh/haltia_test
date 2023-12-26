abstract interface class TranscribeService {
  Future<void> load();
  Future<String> transcribe(String filePath);
}
