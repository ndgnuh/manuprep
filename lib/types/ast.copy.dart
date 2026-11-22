/// copyWith for every concrete AST node.
///
/// These are extensions because Dart has no partial classes. Extensions are
/// resolved by the *static* type, so call them on a value typed as the
/// concrete node (e.g. after a `switch`/`is` check). An [InputNode] typed as
/// [OtherMacroNode] would pick [OtherMacroNodeCopy] and lose its `path`.
///
/// `parent` is intentionally not copied.
part of 'ast.dart';

extension FreeTextCopy on FreeText {
  FreeText copyWith({String? text}) => FreeText(text ?? this.text);
}

extension GroupNodeCopy on GroupNode {
  GroupNode copyWith({List<AstNode>? children}) =>
      GroupNode(children: children ?? this.children);
}

extension OptionNodeCopy on OptionNode {
  OptionNode copyWith({List<AstNode>? children}) =>
      OptionNode(children: children ?? this.children);
}

extension OtherMacroNodeCopy on OtherMacroNode {
  OtherMacroNode copyWith({String? name, List<AstNode>? children}) =>
      OtherMacroNode(
        name: name ?? this.name,
        children: children ?? this.children,
      );
}

extension InputNodeCopy on InputNode {
  InputNode copyWith({String? path}) => InputNode(path: path ?? this.path);
}

extension BlockCommentNodeCopy on BlockCommentNode {
  BlockCommentNode copyWith({String? content}) =>
      BlockCommentNode(content: content ?? this.content);
}

extension BibliographyNodeCopy on BibliographyNode {
  BibliographyNode copyWith({List<String>? sources}) =>
      BibliographyNode(sources: sources ?? this.sources);
}

extension IncludeGraphicsNodeCopy on IncludeGraphicsNode {
  IncludeGraphicsNode copyWith({String? path, AstNode? options}) =>
      IncludeGraphicsNode(
        path: path ?? this.path,
        options: options ?? this.options,
      );
}

extension DocumentNodeCopy on DocumentNode {
  DocumentNode copyWith({List<AstNode>? children}) =>
      DocumentNode(children: children ?? this.children);
}
