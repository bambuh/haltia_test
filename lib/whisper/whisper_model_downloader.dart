import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:haltia_test/utils/tracer.dart';
import 'package:haltia_test/whisper/whisper_models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';

extension WhisperModelDownloader on WhisperModel {
  static const tag = 'WhisperModelDownloader';

  String get _binFileName => 'ggml-$modelName.bin';
  String get _coreMLFileName => 'ggml-$modelName-encoder.mlmodelc.zip';
  String get _huggingfaceURL => 'https://huggingface.co/ggerganov/whisper.cpp/resolve/main/';

  Uri get binUri => Uri.parse('$_huggingfaceURL$_binFileName');
  Uri get coreMLUri => Uri.parse('$_huggingfaceURL$_coreMLFileName');

  Future<String> getBinPath() async => '${await _getModelDir()}/$_binFileName';
  Future<String> getCoreMLPath() async => '${await _getModelDir()}/$_coreMLFileName';

  Future<bool> isModelExist() async {
    final File modelFile = File(await getBinPath());
    return modelFile.existsSync();
  }

  Future<void> downloadModel() async {
    trace(tag, 'Download model $modelName');

    final binDestinationPath = await getBinPath();
    final coreMLZipDestinationPath = await getCoreMLPath();

    try {
      if (File(binDestinationPath).existsSync()) {
        trace(tag, 'Using already downloaded $_binFileName');
      } else {
        await _downloadFile(
          uri: binUri,
          destinationPath: binDestinationPath,
        );
      }

      File coreMLZipFile = await _downloadFile(
        uri: coreMLUri,
        destinationPath: coreMLZipDestinationPath,
      );

      await ZipFile.extractToDirectory(
        zipFile: coreMLZipFile,
        destinationDir: Directory(await _getModelDir()),
      );
      await coreMLZipFile.delete();
    } catch (e) {
      trace(tag, e.toString(), level: TraceLevel.error);
    }
  }

  Future<File> _downloadFile({
    required Uri uri,
    required String destinationPath,
  }) async {
    final bundleFile = await _copyFromBundleIfPossible(
      uri: uri,
      destinationPath: destinationPath,
    );
    if (bundleFile != null) {
      trace(tag, 'Got file $uri from bundle');
      return bundleFile;
    }
    trace(tag, 'Download file $uri');
    final httpClient = HttpClient();
    final request = await httpClient.getUrl(
      uri,
    );
    final response = await request.close();
    final bytes = await consolidateHttpClientResponseBytes(response);
    final File file = File(destinationPath);
    await file.writeAsBytes(bytes);

    return file;
  }

  Future<File?> _copyFromBundleIfPossible({
    required Uri uri,
    required String destinationPath,
  }) async {
    try {
      var file = File(destinationPath);
      final byteData = await rootBundle.load('assets/${uri.pathSegments.last}');
      final buffer = byteData.buffer;
      await file.create(recursive: true);
      await file.writeAsBytes(buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      return file;
    } catch (e) {
      return null;
    }
  }

  Future<String> _getModelDir() async {
    final Directory libraryDirectory =
        Platform.isAndroid ? await getApplicationSupportDirectory() : await getLibraryDirectory();
    return libraryDirectory.path;
  }
}
