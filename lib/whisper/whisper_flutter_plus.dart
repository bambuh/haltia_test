import 'dart:convert';
import 'dart:ffi';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:haltia_test/whisper/models/_models.dart';
import 'package:haltia_test/whisper/models/requests/transcribe_request_dto.dart';
import 'package:haltia_test/whisper/models/requests/version_request.dart';
import 'package:haltia_test/whisper/models/whisper_dto.dart';
import 'package:haltia_test/whisper/whisper_model_downloader.dart';
import 'package:haltia_test/whisper/whisper_models.dart';
import 'package:universal_io/io.dart';

export 'models/_models.dart';
export 'whisper_model_downloader.dart' show WhisperModel;

/// Native request type
typedef WReqNative = Pointer<Utf8> Function(Pointer<Utf8> body);

Future<void>? _initializationFuture;

/// Entry point of whisper_flutter_plus
class Whisper {
  static const tag = 'Whisper';

  /// [model] is required
  const Whisper({required this.model});

  /// model used for transcription
  final WhisperModel model;

  DynamicLibrary _openLib() {
    if (Platform.isIOS) {
      return DynamicLibrary.process();
    } else {
      return DynamicLibrary.open('libwhisper.so');
    }
  }

  Future<void> initModel() async {
    _initializationFuture ??= Future(() async {
      await model.downloadModel();
    });
    await _initializationFuture;
  }

  Future<Map<String, dynamic>> _request({
    required WhisperRequestDto whisperRequest,
  }) async {
    await initModel();
    return Isolate.run(
      () async {
        final Pointer<Utf8> data = whisperRequest.toRequestString().toNativeUtf8();
        final Pointer<Utf8> res = _openLib()
            .lookupFunction<WReqNative, WReqNative>(
              'request',
            )
            .call(data);

        final Map<String, dynamic> result = json.decode(
          res.toDartString(),
        ) as Map<String, dynamic>;

        malloc.free(data);
        return result;
      },
    );
  }

  /// Transcribe audio file to text
  Future<WhisperTranscribeResponse> transcribe({
    required TranscribeRequest transcribeRequest,
  }) async {
    final TranscribeRequest req = transcribeRequest.copyWith(
      audio: transcribeRequest.audio,
    );
    final Map<String, dynamic> result = await _request(
      whisperRequest: TranscribeRequestDto.fromTranscribeRequest(
        req,
        await model.getBinPath(),
      ),
    );
    if (result['text'] == null) {
      throw Exception(result['message']);
    }
    return WhisperTranscribeResponse.fromJson(result);
  }

  /// Get whisper version
  Future<String?> getVersion() async {
    final Map<String, dynamic> result = await _request(
      whisperRequest: const VersionRequest(),
    );

    final WhisperVersionResponse response = WhisperVersionResponse.fromJson(
      result,
    );
    return response.message;
  }
}
