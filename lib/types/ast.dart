/// Hold document nodes with meaningful contents (that we care about)
/// All the [path] attribute in this data type is the resource path
/// relative to the root directory
library;

part 'ast.copy.dart';

/// Node can have content only (no chidren)
/// multiple children (blocks, bib commands)
/// and single children (path node, input, etc)
enum AstNodeChildrenType {
  none,
  single,
  multiple,
}

sealed class AstNode {
  final List<AstNode> children;
  final AstNode? parent;
  AstNode({this.children = const [], this.parent});

  void traverse(void Function(AstNode node) visitor) {
    visitor(this);
    for (final child in children) {
      child.traverse(visitor);
    }
  }

  Map<String, Object> toJson() {
    return {
      'type': runtimeType.toString(),
      'children': children.map((child) => child.toJson()).toList(),
    };
  }
}

class FreeText extends AstNode {
  final String text;
  FreeText(this.text, {super.parent});

  @override
  String toString() => 'FreeText("$text")';

  @override
  Map<String, Object> toJson() => {
    'type': 'FreeText',
    'text': text,
  };
}

class GroupNode extends AstNode {
  GroupNode({required super.children, super.parent});

  @override
  String toString() => 'GroupNode(${children.length} children)';

  @override
  Map<String, Object> toJson() => {
    'type': 'Group',
    'children': children.map((child) => child.toJson()).toList(),
  };
}

class OptionNode extends AstNode {
  OptionNode({required super.children, super.parent});

  @override
  Map<String, Object> toJson() => {
    'type': 'OptionalGroup',
    'children': children.map((child) => child.toJson()).toList(),
  };
}

sealed class MacroNode extends AstNode {
  final String name;

  MacroNode({required this.name, super.children, super.parent});
}

class OtherMacroNode extends MacroNode {
  OtherMacroNode({required super.name, super.children, super.parent});

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
  final String path;
  InputNode({required this.path, super.parent}) : super(name: r'\input');

  @override
  String toString() => 'InputNode(path: $path)';
}

class BlockCommentNode extends AstNode {
  final String content;
  BlockCommentNode({required this.content, super.parent});

  @override
  String toString() => 'BlockCommentNode()';

  @override
  Map<String, Object> toJson() => {
    'type': runtimeType.toString(),
    'comment': content,
  };
}

class BibliographyNode extends MacroNode {
  final List<String> sources;
  BibliographyNode({required this.sources, super.parent})
    : super(name: r'\bibliography');

  @override
  String toString() => 'BibliographyNode(sources: $sources)';

  @override
  Map<String, Object> toJson() => {
    'type': runtimeType.toString(),
    'sources': sources,
  };
}

class IncludeGraphicsNode extends MacroNode {
  final String path;
  final AstNode? options;
  IncludeGraphicsNode({required this.path, this.options, super.parent})
    : super(name: r'\includegraphics');

  @override
  String toString() => 'IncludeGraphicsNode(path: $path, options: $options)';

  @override
  Map<String, Object> toJson() => {
    'type': runtimeType.toString(),
    'path': path,
    'options': options?.toJson() ?? {},
  };
}

class DocumentNode extends AstNode {
  DocumentNode({super.children});
}

AstNodeChildrenType getChildrenType<T extends AstNode>(T node) {
  return switch (node) {
    FreeText() || BlockCommentNode() => AstNodeChildrenType.none,
    // InputNode extends OtherMacroNode, so it must come first
    InputNode() || IncludeGraphicsNode() => AstNodeChildrenType.single,
    GroupNode() ||
    OptionNode() ||
    OtherMacroNode() ||
    BibliographyNode() ||
    DocumentNode() => AstNodeChildrenType.multiple,
  };
}
