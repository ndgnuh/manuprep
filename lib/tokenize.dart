/// From source -> Tokens
library;

import 'types/token.dart';

/// Tokenize [source] latex into [List<Token>].
List<Token> tokenize(String source) {
  final tknz = Tokenizer(source);
  return tknz.tokenize();
}

class Tokenizer {
  final String input;
  int _position = 0;

  Tokenizer(this.input);

  List<Token> tokenize() {
    final tokens = <Token>[];
    while (notEof) {
      final token = nextToken();
      final lastToken = tokens.isNotEmpty
          ? tokens.last
          : Token(TokenType.eof, '');

      if (token.type == TokenType.other && lastToken.type == TokenType.other) {
        // Merge consecutive 'other' tokens
        final mergedToken = Token(
          TokenType.other,
          lastToken.value + token.value,
        );
        tokens.last = mergedToken;
      } else {
        tokens.add(token);
      }
    }

    tokens.add(Token(TokenType.eof, ''));

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
    final c = advance();
    final beginComment = "begin{comment}";
    final endComment = "end{comment}";
    switch (c) {
      case '':
        return Token(TokenType.eof, '');
      case r'\':
        if (rest.startsWith(beginComment)) {
          // Consume 'begin{comment}'
          for (int i = 0; i < beginComment.length; i++) {
            advance();
          }
          return Token(TokenType.blockCommentBegin, r'\begin{comment}');
        }

        if (rest.startsWith(endComment)) {
          // Consume 'begin{comment}'
          for (int i = 0; i < endComment.length; i++) {
            advance();
          }
          return Token(TokenType.blockCommentEnd, r'\end{comment}');
        }

        final buffer = StringBuffer()..write(c);
        while (notEof && RegExp(r'[a-zA-Z*]').hasMatch(currentChar)) {
          buffer.write(advance());
        }
        final command = buffer.toString();
        return Token(TokenType.macro, command);
      case '{':
        return Token(TokenType.groupBegin, c);
      case '}':
        return Token(TokenType.groupEnd, c);
      case '[':
        return Token(TokenType.optionBegin, c);
      case ']':
        return Token(TokenType.optionEnd, c);
      default:
        StringBuffer buffer = StringBuffer()..write(c);
        while (notEof) {
          final nextChar = currentChar;
          if (nextChar == '\\' ||
              nextChar == '{' ||
              nextChar == '}' ||
              nextChar == '[' ||
              nextChar == ']') {
            break;
          }
          buffer.write(advance());
        }
        return Token(TokenType.other, buffer.toString());
    }
  }
}
