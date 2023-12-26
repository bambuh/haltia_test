import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:haltia_test/utils/tracer.dart';
import 'package:universal_io/io.dart';

enum WhisperModel {
  tiny('tiny'),
  base('base'),
  small('small'),
  medium('medium'),
  large('large'),
  tinyEn('tiny.en'),
  baseEn('base.en'),
  smallEn('small.en'),
  mediumEn('medium.en');

  const WhisperModel(this.modelName);

  final String modelName;

  Uri get binUri {
    return Uri.parse(
      'https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-$modelName.bin',
    );
  }

  Uri get coreMLUri {
    return Uri.parse(
      'https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-$modelName-encoder.mlmodelc.zip',
    );
  }

  String getBinPath(String dir) {
    return '$dir/ggml-$modelName.bin';
  }

  String getCoreMLPath(String dir) {
    return '$dir/ggml-$modelName-encoder.mlmodelc.zip';
  }
}

extension ModelDownloader on WhisperModel {
  static const tag = 'ModelDownloader';

  Future<void> downloadModel({
    required String destinationDir,
  }) async {
    trace(tag, 'Download model $modelName');

    File? binFile = await _copyFromBundleIfPossible(
      uri: binUri,
      destinationPath: getBinPath(destinationDir),
    );
    binFile ??= await _downloadFile(
      uri: binUri,
      destinationPath: getBinPath(destinationDir),
    );

    File? coreMLZipFile = await _copyFromBundleIfPossible(
      uri: coreMLUri,
      destinationPath: getCoreMLPath(destinationDir),
    );
    coreMLZipFile ??= await _downloadFile(
      uri: coreMLUri,
      destinationPath: getCoreMLPath(destinationDir),
    );

    try {
      await ZipFile.extractToDirectory(
        zipFile: coreMLZipFile,
        destinationDir: Directory(destinationDir),
        onExtracting: (zipEntry, progress) {
          return ZipFileOperation.includeItem;
        },
      );
      await coreMLZipFile.delete();
    } catch (e) {
      trace(tag, e.toString(), level: TraceLevel.error);
    }
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

  Future<File> _downloadFile({
    required Uri uri,
    required String destinationPath,
  }) async {
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
}
