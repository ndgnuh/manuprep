/// Hold document nodes with meaningful contents (that we care about)
library;

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
  final PathNode path;
  InputNode({required this.path, super.parent}) : super(name: r'\input');

  @override
  List<AstNode> get children => [path];

  @override
  String toString() => 'InputNode(path: $path)';
}

class PathNode extends AstNode {
  String path;
  PathNode({required this.path, super.parent});

  void replacePath(String newPath) {
    path = newPath;
  }

  @override
  String toString() => 'PathNode(path: $path)';

  @override
  Map<String, Object> toJson() => {
    'type': runtimeType.toString(),
    'path': path,
  };
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
  final List<PathNode> sources;
  BibliographyNode({required this.sources, super.parent})
    : super(name: r'\bibliography');

  @override
  List<AstNode> get children => sources;

  @override
  String toString() => 'BibliographyNode(sources: $sources)';

  @override
  Map<String, Object> toJson() => {
    'type': runtimeType.toString(),
    'sources': sources,
  };
}

class IncludeGraphicsNode extends MacroNode {
  final PathNode path;
  final AstNode? options;
  IncludeGraphicsNode({required this.path, this.options, super.parent})
    : super(name: r'\includegraphics');

  @override
  List<AstNode> get children => [
    if (options != null) options!,
    path,
  ];

  IncludeGraphicsNode copyWith({
    PathNode? path,
    AstNode? options,
  }) => IncludeGraphicsNode(
    path: path ?? this.path,
    options: options ?? this.options,
  );

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
    FreeText() || PathNode() || BlockCommentNode() => AstNodeChildrenType.none,
    // InputNode extends OtherMacroNode, so it must come first
    InputNode() || IncludeGraphicsNode() => AstNodeChildrenType.single,
    GroupNode() ||
    OptionNode() ||
    OtherMacroNode() ||
    BibliographyNode() ||
    DocumentNode() => AstNodeChildrenType.multiple,
  };
}
