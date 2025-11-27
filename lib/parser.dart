import 'tokenizer.dart';

sealed class Node {
  final List<Node> children;
  final Node? parent;
  Node({this.children = const [], this.parent});

  void traverse(void Function(Node node) visitor) {
    visitor(this);
    for (final child in children) {
      child.traverse(visitor);
    }
  }

  String compose();

  Map<String, Object> toJson() {
    return {
      'type': runtimeType.toString(),
      'children': children.map((child) => child.toJson()).toList(),
    };
  }
}

class FreeText extends Node {
  final String text;
  FreeText(this.text, {super.parent});

  @override
  String compose() => text;

  @override
  String toString() => 'FreeText("$text")';

  @override
  Map<String, Object> toJson() => {
    'type': 'FreeText',
    'text': text,
  };
}

class GroupNode extends Node {
  GroupNode({required super.children, super.parent});

  @override
  String compose() => '{${children.map((e) => e.compose()).join()}}';

  @override
  String toString() => 'GroupNode(${children.length} children)';

  @override
  Map<String, Object> toJson() => {
    'type': 'Group',
    'children': children.map((child) => child.toJson()).toList(),
  };
}

class OptionNode extends Node {
  OptionNode({required super.children, super.parent});

  @override
  String compose() => '[${children.map((e) => e.compose()).join()}]';

  @override
  Map<String, Object> toJson() => {
    'type': 'OptionalGroup',
    'children': children.map((child) => child.toJson()).toList(),
  };
}

sealed class MacroNode extends Node {
  final String name;

  MacroNode({required this.name, super.children, super.parent});
}

class OtherMacroNode extends MacroNode {
  OtherMacroNode({required super.name, super.children, super.parent});

  @override
  String compose() {
    final parts = [
      name,
      ...children.map((child) => child.compose()),
    ];
    return parts.join();
  }

  @override
  Map<String, Object> toJson() {
    return {
      'type': runtimeType.toString(),
      'name': name,
      'args': children.map((child) => child.toJson()).toList(),
    };
  }
}

class InputNode extends OtherMacroNode {
  final List<PathNode> paths;
  InputNode({required this.paths}) : super(name: r'\input');

  @override
  List<Node> get children => paths;

  @override
  String compose() {
    final parts = [
      r'\input{',
      ...paths.map((e) => e.compose()),
      '}',
    ];
    return parts.join();
  }

  @override
  String toString() => 'InputNode(path: $paths)';
}

class PathNode extends Node {
  String path;
  PathNode({required this.path, super.parent});

  void replacePath(String newPath) {
    path = newPath;
  }

  @override
  String compose() => path;

  @override
  String toString() => 'PathNode(path: $path)';

  @override
  Map<String, Object> toJson() => {
    'type': runtimeType.toString(),
    'path': path,
  };
}

class BlockCommentNode extends Node {
  final String content;
  BlockCommentNode({required this.content, super.parent});

  @override
  String compose() => r"\begin{comment}" + content + r"\end{comment}";

  @override
  String toString() => 'BlockCommentNode()';

  @override
  Map<String, Object> toJson() => {
    'type': runtimeType.toString(),
    'comment': content,
  };
}

class BibliographyNode extends MacroNode {
  final List<PathNode> sources;
  BibliographyNode({required this.sources, super.parent})
    : super(name: r'\bibliography');

  @override
  List<Node> get children => sources;

  @override
  String toString() => 'BibliographyNode(sources: $sources)';

  @override
  String compose() {
    final paths = sources.map((e) => e.compose()).join(',');
    return '\\bibliography{$paths}';
  }

  @override
  Map<String, Object> toJson() => {
    'type': runtimeType.toString(),
    'sources': sources,
  };
}

class IncludeGraphicsNode extends MacroNode {
  final PathNode path;
  final Node? options;
  IncludeGraphicsNode({required this.path, this.options, super.parent})
    : super(name: r'\includegraphics');

  @override
  List<Node> get children => [
    if (options != null) options!,
    path,
  ];

  IncludeGraphicsNode copyWith({
    PathNode? path,
    Node? options,
  }) => IncludeGraphicsNode(
    path: path ?? this.path,
    options: options ?? this.options,
  );

  @override
  String compose() {
    final parts = [
      r"\includegraphics",
      if (options != null) options!.compose(),
      "{",
      path.compose(),
      "}",
    ];
    return parts.join();
  }

  @override
  String toString() => 'IncludeGraphicsNode(path: $path, options: $options)';

  @override
  Map<String, Object> toJson() => {
    'type': runtimeType.toString(),
    'path': path,
    'options': options?.toJson() ?? {},
  };
}

class DocumentNode extends Node {
  DocumentNode({super.children});

  @override
  String compose() {
    return children.map((e) => e.compose()).join();
  }
}

class DocumentParser {
  final List<Token> tokens;
  DocumentParser(this.tokens);

  int position = 0;
  bool get eof => position >= tokens.length;
  bool get notEof => position < tokens.length;

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

  InputNode parseInputNode({Node? parent}) {
    // Expecting \input{path}
    expect(TokenType.groupBegin);
    final pathNode = parseBlock(optional: false);
    final blockContent = pathNode.children.map((e) => e.compose()).join();
    final paths = blockContent
        .split(',')
        .map((path) => PathNode(path: path, parent: parent))
        .toList();
    return InputNode(paths: paths);
  }

  Node parseFreeText({Node? parent}) {
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

  Node parseBlock({bool optional = false, Node? parent}) {
    final children = <Node>[];
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

  BibliographyNode parseBibliographyCommand({Node? parent}) {
    // Expecting \bibliography{source1,source2,...}
    // Consume the '{'
    expect(TokenType.groupBegin);

    // Split the argument by commas and trim spaces
    final children = <Node>[];
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
    final sources = [for (final child in children) child.compose()].join();
    final bibSources = sources
        .split(',')
        .map((path) => PathNode(path: path))
        .toList();
    return BibliographyNode(sources: bibSources, parent: parent);
  }

  IncludeGraphicsNode parseIncludeGraphicsCommand({Node? parent}) {
    // Check if the next token is an optional argument
    final currentToken = peek();
    late final Node? options;
    if (currentToken.type == TokenType.optionBegin) {
      advance(); // Consume '['
      options = parseBlock(optional: true);
    } else {
      options = null;
    }

    expect(TokenType.groupBegin); // Consume any spaces between options and path

    // Expecting \includegraphics{path}
    final graphicPath = parseBlock(optional: false);
    final blockContent = graphicPath.children.map((e) => e.compose()).join();
    return IncludeGraphicsNode(
      path: PathNode(path: blockContent),
      options: options,
      parent: parent,
    );
  }

  BlockCommentNode parseCommentEnvironment({Node? parent}) {
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
    Node? parent,
  }) {
    /// Macro name is current token value
    final args = <Node>[];
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

  Node parseFromToken(Token token, {Node? parent}) {
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

  DocumentNode parse() {
    position = 0;
    final children = <Node>[];
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
}

DocumentNode parseDocument({required String source}) {
  final tokens = Tokenizer(source).tokenize();
  final parser = DocumentParser(tokens);
  return parser.parse();
}
