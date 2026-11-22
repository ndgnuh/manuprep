/// Hold document nodes with meaningful contents (that we care about)
/// All the [path] attribute in this data type is the resource path
/// relative to the root directory
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'ast.freezed.dart';
part 'ast.g.dart';

/// Node can have content only (no chidren)
/// multiple children (blocks, bib commands)
/// and single children (path node, input, etc)
enum AstNodeChildrenType {
  none,
  single,
  multiple,
}

typedef AstTransformer<T> = T Function(T node);

abstract mixin class BranchNode {
  List<AstNode> get children;

  /// Returns list of updated children node, lazily
  List<AstNode> _transformChildren(AstTransformer f) {
    List<AstNode>? newChildren;
    for (int i = 0; i < children.length; i++) {
      final old = children[i];
      final updated = old.transform(f);
      if (newChildren == null && !identical(old, updated)) {
        newChildren = List.of(children.take(i));
      }
      newChildren?.add(updated);
    }

    return newChildren ?? children;
  }
}

@Freezed(unionKey: 'type')
sealed class AstNode with _$AstNode {
  const AstNode._();

  const factory AstNode.freeText(String text) = FreeText;

  /// A latex group
  /// `children`: list of content
  /// `isOption`: the surrounding is [ ... ] instead of { ... }
  @With<BranchNode>()
  const factory AstNode.group({
    required List<AstNode> children,
    @Default(false) bool isOption,
  }) = GroupNode;

  /// This is just for other macros, might or might not be important
  @With<BranchNode>()
  const factory AstNode.otherMacro({
    required String name,
    required List<AstNode> children,
  }) = OtherMacroNode;

  /// Input another tex file
  const factory AstNode.input({
    required String path,
  }) = InputNode;

  /// comment environment, they might contains \input and \includegraphics
  /// but they shouldn't be included in the final outputs
  const factory AstNode.blockComment({
    required String content,
  }) = BlockCommentNode;

  /// bibliography command, track bib files
  const factory AstNode.bibliography({
    required List<String> sources,
  }) = BibliographyNode;

  const factory AstNode.includeGraphics({
    required String path,
    GroupNode? options,
  }) = IncludeGraphicsNode;

  @With<BranchNode>()
  const factory AstNode.document({
    required List<AstNode> children,
  }) = DocumentNode;

  factory AstNode.fromJson(Map<String, dynamic> json) =>
      _$AstNodeFromJson(json);

  /// Not every node has children, so freezed doesn't generate this getter on
  /// the base class. Nodes with a `children` field override it.
  List<AstNode> get children => const [];

  AstNode transform(AstTransformer transformFunc) {
    return switch (this) {
      /// Leaf nodes
      FreeText() ||
      InputNode() ||
      BlockCommentNode() ||
      BibliographyNode() => transformFunc(this),

      /// Branch nodes
      GroupNode node => transformFunc(
        node.copyWith(children: node._transformChildren(transformFunc)),
      ),
      DocumentNode node => transformFunc(
        node.copyWith(children: node._transformChildren(transformFunc)),
      ),
      OtherMacroNode node => transformFunc(
        node.copyWith(children: node._transformChildren(transformFunc)),
      ),

      /// Include graphics, options is not really a child, but it is a node
      IncludeGraphicsNode node => transformFunc(
        node.copyWith(
          options: transformFunc(node.options),
        ),
      ),
    };
  }

  void traverse(void Function(AstNode node) visitor) {
    visitor(this);
    for (final child in children) {
      child.traverse(visitor);
    }
  }
}

AstNodeChildrenType getChildrenType<T extends AstNode>(T node) {
  return switch (node) {
    FreeText() || BlockCommentNode() => AstNodeChildrenType.none,
    InputNode() || IncludeGraphicsNode() => AstNodeChildrenType.single,
    GroupNode() ||
    OtherMacroNode() ||
    BibliographyNode() ||
    DocumentNode() => AstNodeChildrenType.multiple,
  };
}
