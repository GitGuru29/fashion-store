import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Centralized logging utility for the BELLDI Fashion Store app
/// Uses dart:developer for structured logging in development
class AppLogger {
  static const String _appName = 'BELLDI';

  /// Log a debug message (Development only)
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log(
        '🔧 $message',
        name: tag ?? _appName,
        level: 500,
      );
    }
  }

  /// Log an info message
  static void info(String message, {String? tag}) {
    developer.log(
      'ℹ️  $message',
      name: tag ?? _appName,
      level: 800,
    );
  }

  /// Log a warning message
  static void warning(String message, {String? tag}) {
    developer.log(
      '⚠️  $message',
      name: tag ?? _appName,
      level: 900,
    );
  }

  /// Log an error message with optional error object and stack trace
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      '❌ $message${error != null ? '\nError: $error' : ''}',
      name: tag ?? _appName,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log auth-specific events with formatted prefix
  static void auth(String message) {
    developer.log(
      message,
      name: 'Auth',
      level: 800,
    );
  }

  /// Log Firebase-specific events with formatted prefix
  static void firebase(String message, {Object? error}) {
    developer.log(
      message,
      name: 'Firebase',
      level: 800,
      error: error,
    );
  }

  /// Log network-specific events with formatted prefix
  static void network(String message) {
    developer.log(
      message,
      name: 'Network',
      level: 800,
    );
  }
}


