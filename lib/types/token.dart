/// Typing for the tokenize module
library;

enum TokenType {
  macro,
  blockCommentBegin,
  blockCommentEnd,
  percent,
  newLine,
  groupBegin,
  groupEnd,
  optionBegin,
  optionEnd,
  other,
  eof,
}

class const Token({
  required final TokenType type,
  required final String value,
  required final int start,
}) {
  @override
  String toString() => 'Token(type: $type, value: "$value")';

  int get length => value.length;
  int get end => start + length;
}
