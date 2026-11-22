/// From source -> Tokens
library;

import 'types/token.dart';

/// Characters that always form a token on their own.
/// They also end a run of plain text.
const _singleCharTokens = <String, TokenType>{
  '{': TokenType.groupBegin,
  '}': TokenType.groupEnd,
  '[': TokenType.optionBegin,
  ']': TokenType.optionEnd,
  '%': TokenType.percent,
  '\n': TokenType.newLine,
};

/// Tokenize [source] latex into [List<Token>].
List<Token> tokenize(String source) {
  final tknz = Tokenizer(source);
  return tknz.tokenize();
}

class Tokenizer {
  final String input;
  int _position = 0;

  Tokenizer(this.input);

  int tell() => _position;

  List<Token> tokenize() {
    final tokens = <Token>[];
    while (notEof) {
      final token = nextToken();
      final lastToken = tokens.isNotEmpty
          ? tokens.last
          : Token(start: _position, type: TokenType.eof, value: '');

      if (token.type == TokenType.other && lastToken.type == TokenType.other) {
        // Merge consecutive 'other' tokens
        final mergedToken = Token(
          start: lastToken.start,
          type: TokenType.other,
          value: lastToken.value + token.value,
        );
        tokens.last = mergedToken;
      } else {
        tokens.add(token);
      }
    }

    tokens.add(Token(type: TokenType.eof, value: '', start: _position));

    _position = 0;

    return tokens;
  }

  /// Increase the position by 1 and return the current character
  String advance() {
    if (eof) {
      return '';
    }
    final result = input[_position];
    _position += 1;
    return result;
  }

  /// Get current character
  String get currentChar => _position >= input.length ? "" : input[_position];
  bool get eof => _position >= input.length;
  bool get notEof => _position < input.length;

  String get rest => input.substring(_position);

  Token nextToken() {
    final initPosition = tell();
    final c = advance();
    final beginComment = "begin{comment}";
    final endComment = "end{comment}";

    /// Not really the intended place to put this
    /// If \ becomes a single token, then this should be placed
    /// down below the command...
    if (_singleCharTokens[c] case final type?) {
      return Token(start: initPosition, type: type, value: c);
    }

    switch (c) {
      case '':
        return Token(type: TokenType.eof, value: '', start: _position);
      case r'\':
        if (rest.startsWith(beginComment)) {
          // Consume 'begin{comment}'
          for (int i = 0; i < beginComment.length; i++) {
            advance();
          }
          return Token(
            start: initPosition,
            type: TokenType.blockCommentBegin,
            value: r'\begin{comment}',
          );
        }

        if (rest.startsWith(endComment)) {
          // Consume 'begin{comment}'
          for (int i = 0; i < endComment.length; i++) {
            advance();
          }
          return Token(
            start: initPosition,
            type: TokenType.blockCommentEnd,
            value: r'\end{comment}',
          );
        }

        final buffer = StringBuffer()..write(c);
        while (notEof && RegExp(r'[a-zA-Z*]').hasMatch(currentChar)) {
          buffer.write(advance());
        }
        final command = buffer.toString();
        return Token(
          start: initPosition,
          type: TokenType.macro,
          value: command,
        );
      default:
        StringBuffer buffer = StringBuffer()..write(c);
        while (notEof) {
          final nextChar = currentChar;
          if (nextChar == '\\' || _singleCharTokens.containsKey(nextChar)) {
            break;
          }
          buffer.write(advance());
        }
        return Token(
          start: initPosition,
          type: TokenType.other,
          value: buffer.toString(),
        );
    }
  }
}
