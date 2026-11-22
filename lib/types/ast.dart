/// Hold document nodes with meaningful contents (that we care about)
library;

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
  final PathNode path;
  InputNode({required this.path, super.parent}) : super(name: r'\input');

  @override
  List<Node> get children => [path];

  @override
  String compose() => '\\input{${path.compose()}}';

  @override
  String toString() => 'InputNode(path: $path)';
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
