/// From tokens -> AST
library;

import 'compose.dart';
import 'types/token.dart';
import 'types/ast.dart';

import 'tokenize.dart';

FreeText _mergeFreeText(FreeText text1, FreeText text2) {
  return FreeText(text1.text + text2.text);
}

DocumentNode parseTokenList(List<Token> tokens) {
  return DocumentParser(tokens).parse();
}

class DocumentParser {
  final List<Token> tokens;
  DocumentParser(this.tokens);

  /// Position of current token
  int position = 0;

  bool get eof => position >= tokens.length;
  bool get notEof => position < tokens.length;

  /// The entrypoint for parsing
  /// loop over token list and just parse from there
  DocumentNode parse() {
    position = 0;
    final children = <AstNode>[];
    AstNode? previousNode;
    while (notEof) {
      final token = advance();
      if (token.type == TokenType.eof) {
        break;
      }
      final parsed = parseFromToken(token);

      switch ((previousNode, parsed)) {
        case (FreeText prev, FreeText next):
          children.last = _mergeFreeText(prev, next);
        default:
          children.add(parsed);
      }
      previousNode = parsed;
    }
    return DocumentNode(children: children);
  }

  /// The main hub of token handling
  /// Route each token type to appropriate parsing function
  AstNode parseFromToken(Token token) {
    switch (token.type) {
      case TokenType.macro:
        return switch (token.value) {
          r"\bibliography" => parseBibliographyCommand(),
          r"\includegraphics" => parseIncludeGraphicsCommand(),
          r"\input" => parseInputNode(),
          r"\usepackage" => parseOtherMacro(
            name: token.value,
            argSpec: "om",
          ),
          _ => FreeText(token.value),
        };
      case TokenType.groupBegin:
        return parseBlock(optional: false);
      case TokenType.optionBegin:
        return parseBlock(optional: true);
      case TokenType.other:
        return FreeText(token.value);
      case TokenType.eof:
        throw Exception('Unexpected end of file');
      case TokenType.blockCommentBegin:
        return parseCommentEnvironment();
      default:
        throw unexpect(token);
    }
  }

  Token peek() {
    if (eof) {
      return tokens.last;
    }
    return tokens[position];
  }

  Token advance() {
    if (eof) {
      return tokens.last;
    }
    final token = tokens[position];
    position += 1;
    return token;
  }

  /// Expect a token at currnet position
  /// consume at return that token, throws if unmet
  Token expect(TokenType type) {
    final token = advance();
    if (token.type != type) {
      throw Exception('Expected token of type $type, got ${token.type}');
    }
    return token;
  }

  Token unexpect(Token token) {
    throw Exception('Unexpected token of type ${token.type}}');
  }

  InputNode parseInputNode({AstNode? parent}) {
    // Expecting \input{path}
    expect(TokenType.groupBegin);
    final block = parseBlock(optional: false);
    final path = block.children
        .map((e) => texCompose(astNode: e))
        .join()
        .trim();
    return InputNode(path: path);
  }

  AstNode parseFreeText() {
    final buffer = StringBuffer();

    while (notEof) {
      final nextToken = peek();
      switch (nextToken.type) {
        case TokenType.other:
          buffer.write(advance().value);
        default:
          return FreeText(buffer.toString());
      }
    }

    return FreeText(buffer.toString());
  }

  GroupNode parseBlock({bool optional = false}) {
    final children = <AstNode>[];
    while (notEof) {
      final token = advance();
      switch ((token.type, optional)) {
        case (TokenType.groupEnd, false):
          return GroupNode(children: children);
        case (TokenType.optionEnd, true):
          return GroupNode(children: children, isOption: true);
        case (TokenType.eof, _):
          throw Exception('Unexpected end of file while parsing block');
        default:
          children.add(parseFromToken(token));
      }
    }
    throw Exception('Unclosed block');
  }

  BibliographyNode parseBibliographyCommand() {
    // Expecting \bibliography{source1,source2,...}
    // Consume the '{'
    expect(TokenType.groupBegin);

    // Split the argument by commas and trim spaces
    final children = <AstNode>[];
    loop:
    while (notEof) {
      final token = advance();
      switch (token.type) {
        case TokenType.groupEnd:
          break loop;
        default:
          final args = parseFromToken(token);
          children.add(args);
      }
    }
    final sources = [
      for (final child in children) texCompose(astNode: child),
    ].join();
    final bibSources = sources.split(',').toList();
    return BibliographyNode(sources: bibSources);
  }

  IncludeGraphicsNode parseIncludeGraphicsCommand({AstNode? parent}) {
    // Check if the next token is an optional argument
    final currentToken = peek();
    late final GroupNode? options;
    if (currentToken.type == TokenType.optionBegin) {
      advance(); // Consume '['
      options = parseBlock(optional: true);
    } else {
      options = null;
    }

    expect(TokenType.groupBegin); // Consume any spaces between options and path

    // Expecting \includegraphics{path}
    final graphicPath = parseBlock(optional: false);
    final blockContent = graphicPath.children
        .map((e) => texCompose(astNode: e))
        .join();
    return IncludeGraphicsNode(
      path: blockContent,
      options: options,
    );
  }

  BlockCommentNode parseCommentEnvironment({AstNode? parent}) {
    final buffer = StringBuffer();
    while (notEof) {
      final token = advance();
      if (token.type == TokenType.blockCommentEnd) {
        return BlockCommentNode(content: buffer.toString());
      } else {
        buffer.write(token.value);
      }
    }
    throw Exception('Unclosed comment environment');
  }

  OtherMacroNode parseOtherMacro({
    required String name,
    String argSpec = "",
    AstNode? parent,
  }) {
    /// Macro name is current token value
    final args = <AstNode>[];
    loop:
    for (var i = 0; i < argSpec.length; i++) {
      final spec = argSpec[i];
      switch (spec) {
        case 'o':
          if (peek().type == TokenType.optionBegin) {
            advance();
            final arg = parseBlock(optional: true);
            args.add(arg);
            continue loop;
          }
        case 'm':
          expect(TokenType.groupBegin);
          final arg = parseBlock(optional: false);
          args.add(arg);
        default:
          throw Exception(
            'Unknown argument specification: $spec, it is either "o" (optional) or "m" (mandatory)',
          );
      }
    }

    return OtherMacroNode(name: name, children: args);
  }
}

DocumentNode parseDocument({required String source}) {
  final tokens = tokenize(source);
  final parser = DocumentParser(tokens);
  return parser.parse();
}
