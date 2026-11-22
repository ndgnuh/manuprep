import 'dart:convert';

import 'types/ast.dart';

String texCompose({required AstNode astNode}) {
  final io = StringBuffer();
  _texComposeVisit(io: io, node: astNode);
  return io.toString();
}

String dumpAst({required AstNode astNode}) {
  final io = StringBuffer();
  _dumpComposeVisit(io: io, node: astNode);
  return io.toString();
}

void _texComposeVisit({
  required StringBuffer io,
  required AstNode node,
}) {
  void visitAll(Iterable<AstNode> nodes) {
    for (final child in nodes) {
      _texComposeVisit(io: io, node: child);
    }
  }

  switch (node) {
    case FreeText(:final text):
      io.write(text);
    case GroupNode(:final children):
      final (open, close) = switch (node.isOption) {
        true => ("[", "]"),
        false => ("{", "}"),
      };
      io.write(open);
      visitAll(children);
      io.write(close);
    case BlockCommentNode(:final content):
      io.write(r'\begin{comment}');
      io.write(content);
      io.write(r'\end{comment}');
    // InputNode extends OtherMacroNode, so it must come first
    case InputNode(:final path):
      io.write(r'\input{');
      io.write(path);
      io.write('}');
    case OtherMacroNode(:final name, :final children):
      io.write(name);
      visitAll(children);
    case BibliographyNode(:final sources):
      io.write(r'\bibliography{');
      for (final (i, source) in sources.indexed) {
        if (i > 0) io.write(',');
        io.write(source);
      }
      io.write('}');
    case IncludeGraphicsNode(:final path, :final options):
      io.write(r'\includegraphics');
      if (options != null) _texComposeVisit(io: io, node: options);
      io.write('{');
      io.write(path);
      io.write('}');
    case DocumentNode(:final children):
      visitAll(children);
  }
}

/// Dump the tree in the style of Julia's `Meta.@dump`: a node prints its type
/// name, then one indented `field: value` line per field. Lists print their
/// element type and length, then one numbered line per item.
///
/// ```
/// DocumentNode
///   children: List<AstNode> (2)
///     1: GroupNode
///       children: List<AstNode> (1)
///         1: FreeText
///           text: String "Intro"
///       isOption: bool false
///     2: InputNode
///       path: String "chapters/intro"
/// ```
///
/// Strings are JSON-quoted so newlines and whitespace stay visible.
void _dumpComposeVisit({
  required StringBuffer io,
  required Object? node,
  int depth = 0,
}) {
  void visitFields(List<(String, Object?)> fields) {
    for (final (name, value) in fields) {
      io.write('  ' * (depth + 1));
      io.write('$name: ');
      _dumpComposeVisit(io: io, node: value, depth: depth + 1);
    }
  }

  switch (node) {
    case AstNode():
      io.writeln(node.runtimeType);
      visitFields(switch (node) {
        FreeText(:final text) => [('text', text)],
        GroupNode(:final children, :final isOption) => [
          ('children', children),
          ('isOption', isOption),
        ],
        BlockCommentNode(:final content) => [('content', content)],
        InputNode(:final path) => [('path', path)],
        OtherMacroNode(:final name, :final children) => [
          ('name', name),
          ('children', children),
        ],
        BibliographyNode(:final sources) => [('sources', sources)],
        IncludeGraphicsNode(:final path, :final options) => [
          ('path', path),
          ('options', options),
        ],
        DocumentNode(:final children) => [('children', children)],
      });
    case List():
      final type = switch (node) {
        List<AstNode>() => 'List<AstNode>',
        List<String>() => 'List<String>',
        _ => 'List',
      };
      io.writeln('$type (${node.length})');
      visitFields([
        for (final (i, item) in node.indexed) ('${i + 1}', item),
      ]);
    case String():
      io.writeln('String ${jsonEncode(node)}');
    case null:
      io.writeln('null');
    default:
      io.writeln('${node.runtimeType} $node');
  }
}
