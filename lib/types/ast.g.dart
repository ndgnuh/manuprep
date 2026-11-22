// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FreeText _$FreeTextFromJson(Map<String, dynamic> json) =>
    FreeText(json['text'] as String, $type: json['type'] as String?);

Map<String, dynamic> _$FreeTextToJson(FreeText instance) => <String, dynamic>{
  'text': instance.text,
  'type': instance.$type,
};

GroupNode _$GroupNodeFromJson(Map<String, dynamic> json) => GroupNode(
  children: (json['children'] as List<dynamic>)
      .map((e) => AstNode.fromJson(e as Map<String, dynamic>))
      .toList(),
  isOption: json['isOption'] as bool? ?? false,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$GroupNodeToJson(GroupNode instance) => <String, dynamic>{
  'children': instance.children,
  'isOption': instance.isOption,
  'type': instance.$type,
};

OtherMacroNode _$OtherMacroNodeFromJson(Map<String, dynamic> json) =>
    OtherMacroNode(
      name: json['name'] as String,
      children: (json['children'] as List<dynamic>)
          .map((e) => AstNode.fromJson(e as Map<String, dynamic>))
          .toList(),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$OtherMacroNodeToJson(OtherMacroNode instance) =>
    <String, dynamic>{
      'name': instance.name,
      'children': instance.children,
      'type': instance.$type,
    };

InputNode _$InputNodeFromJson(Map<String, dynamic> json) =>
    InputNode(path: json['path'] as String, $type: json['type'] as String?);

Map<String, dynamic> _$InputNodeToJson(InputNode instance) => <String, dynamic>{
  'path': instance.path,
  'type': instance.$type,
};

BlockCommentNode _$BlockCommentNodeFromJson(Map<String, dynamic> json) =>
    BlockCommentNode(
      content: json['content'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$BlockCommentNodeToJson(BlockCommentNode instance) =>
    <String, dynamic>{'content': instance.content, 'type': instance.$type};

BibliographyNode _$BibliographyNodeFromJson(Map<String, dynamic> json) =>
    BibliographyNode(
      sources: (json['sources'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$BibliographyNodeToJson(BibliographyNode instance) =>
    <String, dynamic>{'sources': instance.sources, 'type': instance.$type};

IncludeGraphicsNode _$IncludeGraphicsNodeFromJson(Map<String, dynamic> json) =>
    IncludeGraphicsNode(
      path: json['path'] as String,
      options: json['options'] == null
          ? null
          : GroupNode.fromJson(json['options'] as Map<String, dynamic>),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$IncludeGraphicsNodeToJson(
  IncludeGraphicsNode instance,
) => <String, dynamic>{
  'path': instance.path,
  'options': instance.options,
  'type': instance.$type,
};

DocumentNode _$DocumentNodeFromJson(Map<String, dynamic> json) => DocumentNode(
  children: (json['children'] as List<dynamic>)
      .map((e) => AstNode.fromJson(e as Map<String, dynamic>))
      .toList(),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$DocumentNodeToJson(DocumentNode instance) =>
    <String, dynamic>{'children': instance.children, 'type': instance.$type};
