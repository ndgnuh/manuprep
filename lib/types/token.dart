/// Typing for the tokenize module
library;

enum TokenType {
  macro,
  blockCommentBegin,
  blockCommentEnd,
  groupBegin,
  groupEnd,
  optionBegin,
  optionEnd,
  other,
  eof,
}

class Token {
  final TokenType type;
  final String value;

  Token(this.type, this.value);

  @override
  String toString() => 'Token(type: $type, value: "$value")';
}
