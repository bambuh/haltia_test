import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

final _log = <TraceRecord>[];

final _levelPrefixes = {
  TraceLevel.verbose: '[VERBOSE]',
  TraceLevel.debug: '[DEBUG]',
  TraceLevel.info: '[INFO]',
  TraceLevel.warning: '[WARNING]',
  TraceLevel.error: '[ERROR]',
  TraceLevel.wtf: '[CRITICAL]',
};

final _levelColors = {
  TraceLevel.verbose: AnsiColor.fg(AnsiColor.grey(0.5)),
  TraceLevel.debug: AnsiColor.none(),
  TraceLevel.info: AnsiColor.fg(12),
  TraceLevel.warning: AnsiColor.fg(208),
  TraceLevel.error: AnsiColor.fg(196),
  TraceLevel.wtf: AnsiColor.fg(199),
};

enum TraceLevel {
  verbose,
  debug,
  info,
  warning,
  error,
  wtf;
}

void trace(String tag, String msg, {StackTrace? stackTrace, TraceLevel level = TraceLevel.verbose}) {
  if (level == TraceLevel.debug && !kDebugMode) {
    //Do not print debug messages in release mode
    return;
  }

  _log.add(TraceRecord(
    level: level,
    message: msg,
    tag: tag,
    timeStamp: DateTime.now(),
  ));
  Tracer._logSubject.add(_log);

  final output = '${level.prefix} ${DateTime.now()} [$tag] => $msg';
  log(level.color.call(output), stackTrace: stackTrace);
  if (kIsWeb && kDebugMode) {
    // ignore: avoid_print
    print('$output\n$stackTrace');
  }
}

void wtf(String msg) => trace('WTF', msg, level: TraceLevel.wtf);

extension TraceLevelTools on TraceLevel {
  String get prefix => _levelPrefixes[this] ?? '';
  AnsiColor get color => _levelColors[this] ?? AnsiColor.none();
}

Function _traceAlias = trace;

extension TraceExtension on Object {
  void trace(String tag, {StackTrace? stackTrace}) {
    final exception = this;
    _traceAlias(
      tag,
      exception.toString(),
      stackTrace: stackTrace,
      level: stackTrace == null ? TraceLevel.info : TraceLevel.error,
    );
  }
}

class Tracer {
  static List<TraceRecord> get lastValue => _logSubject.value;
  static Stream<List<TraceRecord>> get stream => _logSubject.stream;
  static final _logSubject = BehaviorSubject<List<TraceRecord>>.seeded([]);
  void close() => _logSubject.close();
}

class TraceRecord {
  final String tag;
  final String message;
  final TraceLevel level;
  final DateTime timeStamp;

  TraceRecord({
    required this.tag,
    required this.message,
    required this.level,
    required this.timeStamp,
  });

  @override
  String toString() => 'TracerRecord(tag: $tag, message: $message, level: $level)';
}
