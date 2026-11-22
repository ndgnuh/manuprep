import 'types/ast.dart';

String texCompose({required AstNode astNode}) {
  final io = StringBuffer();
  texComposeVisit(io: io, node: astNode);
  return io.toString();
}

void texComposeVisit({
  required StringBuffer io,
  required AstNode node,
}) {
  void visitAll(Iterable<AstNode> nodes) {
    for (final child in nodes) {
      texComposeVisit(io: io, node: child);
    }
  }

  switch (node) {
    case FreeText(:final text):
      io.write(text);
    case GroupNode(:final children):
      io.write('{');
      visitAll(children);
      io.write('}');
    case OptionNode(:final children):
      io.write('[');
      visitAll(children);
      io.write(']');
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
      if (options != null) texComposeVisit(io: io, node: options);
      io.write('{');
      io.write(path);
      io.write('}');
    case DocumentNode(:final children):
      visitAll(children);
  }
}
