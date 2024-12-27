import 'dart:io';
import 'dart:developer';


import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';


AnsiPen _blackLog = AnsiPen()..black(bold: true);
AnsiPen _infoLog = AnsiPen()..cyan(bold: true);
AnsiPen _successLog = AnsiPen()..green(bold: true);
AnsiPen _warningLog = AnsiPen()..yellow(bold: true);
AnsiPen _errorLog = AnsiPen()..red(bold: true);

bool get dLog => Platform.isAndroid;
blackLog(String data, [String? tag, String? extra]) =>
    logD(!dLog ? data : _blackLog(data), tag, extra);
infoLog(String data, [String? tag, String? extra]) =>logD(!dLog ? data : _infoLog('ℹ $data'), tag, extra);
successLog(String data, [String? tag, String? extra]) =>logD(!dLog ? data : _successLog('✔ $data'), tag, extra);
warningLog(String data, [String? tag, String? extra]) =>logD(!dLog ? data : _warningLog('⚠️ $data'), tag, extra);
errorLog(String data, [String? tag, String? extra]) =>logD(!dLog ? data : _errorLog('💀 $data'), tag, extra);
logD(String data, [String? tag, String? extra, bool colored = false]) {
  ansiColorDisabled = colored;
  debugPrint(
      '${!dLog ? '' : _blackLog('--->')}${tag != null ? ('<$tag> ') : ''} $data ${extra != null ? ('<$extra> ') : ''} ${!dLog ? '' : _blackLog('<---')}');
}

longLogger(String data, [String? tag]) {
  int maxCharactersPerLine = 200;
  warningLog('Running on $tag');
  if (data.length > maxCharactersPerLine) {
    int iterations = (data.length / maxCharactersPerLine).floor();
    for (int i = 0; i <= iterations; i++) {
      int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
      if (endingIndex > data.length) {
        endingIndex = data.length;
      }
      infoLog(data.substring(i * maxCharactersPerLine, endingIndex));
    }
  } else {
    infoLog(data.toString());
  }
}
MyLogger logger = MyLogger();

class MyLogger {
  static final logger = Logger(
    printer: PrettyPrinter(
      noBoxingByDefault: false,
      printTime: false,
      levelColors: {
        Level.trace: AnsiColor.fg(AnsiColor.grey(0.5)),
        Level.debug: const AnsiColor.none(),
        Level.info: const AnsiColor.fg(12),
        Level.warning: const AnsiColor.fg(208),
        Level.error: const AnsiColor.fg(196),
        Level.fatal: const AnsiColor.fg(80),
      },
      levelEmojis: {
        Level.trace: '🔍',
        Level.debug: '🐞',
        Level.info: '📢',
        Level.warning: '👋',
        Level.error: '🚨',
        Level.fatal: '✅',
      },
    ),
  );

  var loggerNoStack = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  //d,e,f,i,t,w

  //d
  void d(
      dynamic message, {
        String? tag,
        DateTime? time,
        Object? error,
        bool reverse = false,
        StackTrace? stackTrace,
      }) {
    logger.d(
      message,
      time: time,
      error: reverse ? error : tag,
      stackTrace: stackTrace ??
          StackTrace.fromString(
              reverse ? (tag ?? '') : (error != null ? error.toString() : '')),
    );
  }

  //e
  void e(
      dynamic message, {
        String? tag,
        DateTime? time,
        Object? error,
        bool reverse = false,
        StackTrace? stackTrace,
      }) {
    logger.e(
      message,
      time: time ?? DateTime.now(),
      error: reverse ? error : tag,
      stackTrace: stackTrace ??
          StackTrace.fromString(
              reverse ? (tag ?? '') : (error != null ? error.toString() : '')),
    );
  }

  //f
  void f(
      dynamic message, {
        String? tag,
        DateTime? time,
        Object? error,
        bool reverse = false,
        StackTrace? stackTrace,
      }) {
    logger.f(
      message,
      time: time ?? DateTime.now(),
      error: reverse ? error : tag,
      stackTrace: stackTrace ??
          StackTrace.fromString(
              reverse ? (tag ?? '') : (error != null ? error.toString() : '')),
    );
  }

  //i
  void i(
      dynamic message, {
        String? tag,
        DateTime? time,
        Object? error,
        bool reverse = false,
        StackTrace? stackTrace,
      }) {
    logger.i(
      message,
      time: time ?? DateTime.now(),
      error: reverse ? error : tag,
      stackTrace: stackTrace ??
          StackTrace.fromString(
              reverse ? (tag ?? '') : (error != null ? error.toString() : '')),
    );
  }

  //t
  void t(
      dynamic message, {
        String? tag,
        DateTime? time,
        Object? error,
        bool reverse = false,
        StackTrace? stackTrace,
      }) {
    logger.t(
      message,
      time: time ?? DateTime.now(),
      error: reverse ? error : tag,
      stackTrace: stackTrace ??
          StackTrace.fromString(
              reverse ? (tag ?? '') : (error != null ? error.toString() : '')),
    );
  }

  //w
  void w(
      dynamic message, {
        String? tag,
        DateTime? time,
        Object? error,
        bool reverse = false,
        StackTrace? stackTrace,
      }) {
    logger.w(
      message,
      time: time ?? DateTime.now(),
      error: reverse ? error : tag,
      stackTrace: stackTrace ??
          StackTrace.fromString(
              reverse ? (tag ?? '') : (error != null ? error.toString() : '')),
    );
  }

  static void demo() {
    MyLogger().d('debug message', tag: 'this is tag');
    MyLogger().e('error message', error: 'error', tag: 'tag', reverse: false);
    MyLogger().f('fetal message', tag: 'fetal');
    MyLogger().i('info message');
    MyLogger().t('trace tmessage');
    MyLogger().w('warning message');

    MyLogger().f("<-- END HTTP",
        tag: "--> options.uri {options.method options.path}",
        error: 'options.headers.toString()');
  }
}

void p(dynamic message) {
  if (kDebugMode) {
    print(message);
  }
}

void pl(dynamic message, [String? tag]) =>
    log(message.toString(), name: tag ?? 'MyLogger');

Future<T?> tryAsync<T>(Future<T?> Function() method,
    [String tag = '', T? defaultValue]) async {
  try {
    return await method();
  } catch (e) {
    logger.e(e, tag: tag);
    return defaultValue;
  }
}

///with return type T
T? tryCatch<T>(T? Function() method, [String tag = '', T? defaultValue]) {
  try {
    return method();
  } catch (e) {
    logger.e(e,
        tag: tag.isEmpty ? method.toString() : tag,
        stackTrace: StackTrace.current);
    return defaultValue;
  }
}
