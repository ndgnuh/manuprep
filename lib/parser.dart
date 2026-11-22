/// From tokens -> AST
library;

import 'compose.dart';
import 'types/token.dart';
import 'types/ast.dart';

import 'tokenize.dart';

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
    while (notEof) {
      final token = advance();
      if (token.type == TokenType.eof) {
        break;
      }
      final parsed = parseFromToken(token);

      children.add(parsed);
    }
    return DocumentNode(children: children);
  }

  /// The main hub of token handling
  /// Route each token type to appropriate parsing function
  AstNode parseFromToken(Token token, {AstNode? parent}) {
    switch (token.type) {
      case TokenType.macro:
        return switch (token.value) {
          r"\bibliography" => parseBibliographyCommand(parent: parent),
          r"\includegraphics" => parseIncludeGraphicsCommand(parent: parent),
          r"\input" => parseInputNode(parent: parent),
          r"\usepackage" => parseOtherMacro(
            name: token.value,
            argSpec: "om",
            parent: parent,
          ),
          _ => parseOtherMacro(name: token.value, parent: parent),
        };
      case TokenType.groupBegin:
        return parseBlock(optional: false, parent: parent);
      case TokenType.optionBegin:
        return parseBlock(optional: true, parent: parent);
      case TokenType.other:
        return FreeText(token.value, parent: parent);
      case TokenType.eof:
        throw Exception('Unexpected end of file');
      case TokenType.blockCommentBegin:
        return parseCommentEnvironment(parent: parent);
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
    return InputNode(
      path: path,
      parent: parent,
    );
  }

  AstNode parseFreeText({AstNode? parent}) {
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

    return FreeText(buffer.toString(), parent: parent);
  }

  AstNode parseBlock({bool optional = false, AstNode? parent}) {
    final children = <AstNode>[];
    while (notEof) {
      final token = advance();
      switch ((token.type, optional)) {
        case (TokenType.groupEnd, false):
          return GroupNode(children: children, parent: parent);
        case (TokenType.optionEnd, true):
          return OptionNode(children: children, parent: parent);
        case (TokenType.eof, _):
          throw Exception('Unexpected end of file while parsing block');
        default:
          children.add(parseFromToken(token));
      }
    }
    throw Exception('Unclosed block');
  }

  BibliographyNode parseBibliographyCommand({AstNode? parent}) {
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
    return BibliographyNode(sources: bibSources, parent: parent);
  }

  IncludeGraphicsNode parseIncludeGraphicsCommand({AstNode? parent}) {
    // Check if the next token is an optional argument
    final currentToken = peek();
    late final AstNode? options;
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
      parent: parent,
    );
  }

  BlockCommentNode parseCommentEnvironment({AstNode? parent}) {
    final buffer = StringBuffer();
    while (notEof) {
      final token = advance();
      if (token.type == TokenType.blockCommentEnd) {
        return BlockCommentNode(content: buffer.toString(), parent: parent);
      } else {
        buffer.write(token.value);
      }
    }
    throw Exception('Unclosed comment environment');
  }

  MacroNode parseOtherMacro({
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

    return OtherMacroNode(name: name, children: args, parent: parent);
  }
}

DocumentNode parseDocument({required String source}) {
  final tokens = tokenize(source);
  final parser = DocumentParser(tokens);
  return parser.parse();
}
