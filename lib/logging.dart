/// Minimal logging helpers: thin wrappers around [print]
/// that prefix each message with its level.
library;

void info(Object? message) => print('[INFO] $message');

void warn(Object? message) => print('[WARN] $message');

void err(Object? message) => print('[ERROR] $message');
