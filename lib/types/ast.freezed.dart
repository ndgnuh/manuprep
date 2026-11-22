// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ast.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
AstNode _$AstNodeFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'freeText':
          return FreeText.fromJson(
            json
          );
                case 'group':
          return GroupNode.fromJson(
            json
          );
                case 'otherMacro':
          return OtherMacroNode.fromJson(
            json
          );
                case 'input':
          return InputNode.fromJson(
            json
          );
                case 'blockComment':
          return BlockCommentNode.fromJson(
            json
          );
                case 'bibliography':
          return BibliographyNode.fromJson(
            json
          );
                case 'includeGraphics':
          return IncludeGraphicsNode.fromJson(
            json
          );
                case 'document':
          return DocumentNode.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'type',
  'AstNode',
  'Invalid union type "${json['type']}"!'
);
        }
      
}

/// @nodoc
mixin _$AstNode {



  /// Serializes this AstNode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AstNode);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AstNode()';
}


}

/// @nodoc
class $AstNodeCopyWith<$Res>  {
$AstNodeCopyWith(AstNode _, $Res Function(AstNode) __);
}


/// Adds pattern-matching-related methods to [AstNode].
extension AstNodePatterns on AstNode {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FreeText value)?  freeText,TResult Function( GroupNode value)?  group,TResult Function( OtherMacroNode value)?  otherMacro,TResult Function( InputNode value)?  input,TResult Function( BlockCommentNode value)?  blockComment,TResult Function( BibliographyNode value)?  bibliography,TResult Function( IncludeGraphicsNode value)?  includeGraphics,TResult Function( DocumentNode value)?  document,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FreeText() when freeText != null:
return freeText(_that);case GroupNode() when group != null:
return group(_that);case OtherMacroNode() when otherMacro != null:
return otherMacro(_that);case InputNode() when input != null:
return input(_that);case BlockCommentNode() when blockComment != null:
return blockComment(_that);case BibliographyNode() when bibliography != null:
return bibliography(_that);case IncludeGraphicsNode() when includeGraphics != null:
return includeGraphics(_that);case DocumentNode() when document != null:
return document(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FreeText value)  freeText,required TResult Function( GroupNode value)  group,required TResult Function( OtherMacroNode value)  otherMacro,required TResult Function( InputNode value)  input,required TResult Function( BlockCommentNode value)  blockComment,required TResult Function( BibliographyNode value)  bibliography,required TResult Function( IncludeGraphicsNode value)  includeGraphics,required TResult Function( DocumentNode value)  document,}){
final _that = this;
switch (_that) {
case FreeText():
return freeText(_that);case GroupNode():
return group(_that);case OtherMacroNode():
return otherMacro(_that);case InputNode():
return input(_that);case BlockCommentNode():
return blockComment(_that);case BibliographyNode():
return bibliography(_that);case IncludeGraphicsNode():
return includeGraphics(_that);case DocumentNode():
return document(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FreeText value)?  freeText,TResult? Function( GroupNode value)?  group,TResult? Function( OtherMacroNode value)?  otherMacro,TResult? Function( InputNode value)?  input,TResult? Function( BlockCommentNode value)?  blockComment,TResult? Function( BibliographyNode value)?  bibliography,TResult? Function( IncludeGraphicsNode value)?  includeGraphics,TResult? Function( DocumentNode value)?  document,}){
final _that = this;
switch (_that) {
case FreeText() when freeText != null:
return freeText(_that);case GroupNode() when group != null:
return group(_that);case OtherMacroNode() when otherMacro != null:
return otherMacro(_that);case InputNode() when input != null:
return input(_that);case BlockCommentNode() when blockComment != null:
return blockComment(_that);case BibliographyNode() when bibliography != null:
return bibliography(_that);case IncludeGraphicsNode() when includeGraphics != null:
return includeGraphics(_that);case DocumentNode() when document != null:
return document(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String text)?  freeText,TResult Function( List<AstNode> children,  bool isOption)?  group,TResult Function( String name,  List<AstNode> children)?  otherMacro,TResult Function( String path)?  input,TResult Function( String content)?  blockComment,TResult Function( List<String> sources)?  bibliography,TResult Function( String path,  GroupNode? options)?  includeGraphics,TResult Function( List<AstNode> children)?  document,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FreeText() when freeText != null:
return freeText(_that.text);case GroupNode() when group != null:
return group(_that.children,_that.isOption);case OtherMacroNode() when otherMacro != null:
return otherMacro(_that.name,_that.children);case InputNode() when input != null:
return input(_that.path);case BlockCommentNode() when blockComment != null:
return blockComment(_that.content);case BibliographyNode() when bibliography != null:
return bibliography(_that.sources);case IncludeGraphicsNode() when includeGraphics != null:
return includeGraphics(_that.path,_that.options);case DocumentNode() when document != null:
return document(_that.children);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String text)  freeText,required TResult Function( List<AstNode> children,  bool isOption)  group,required TResult Function( String name,  List<AstNode> children)  otherMacro,required TResult Function( String path)  input,required TResult Function( String content)  blockComment,required TResult Function( List<String> sources)  bibliography,required TResult Function( String path,  GroupNode? options)  includeGraphics,required TResult Function( List<AstNode> children)  document,}) {final _that = this;
switch (_that) {
case FreeText():
return freeText(_that.text);case GroupNode():
return group(_that.children,_that.isOption);case OtherMacroNode():
return otherMacro(_that.name,_that.children);case InputNode():
return input(_that.path);case BlockCommentNode():
return blockComment(_that.content);case BibliographyNode():
return bibliography(_that.sources);case IncludeGraphicsNode():
return includeGraphics(_that.path,_that.options);case DocumentNode():
return document(_that.children);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String text)?  freeText,TResult? Function( List<AstNode> children,  bool isOption)?  group,TResult? Function( String name,  List<AstNode> children)?  otherMacro,TResult? Function( String path)?  input,TResult? Function( String content)?  blockComment,TResult? Function( List<String> sources)?  bibliography,TResult? Function( String path,  GroupNode? options)?  includeGraphics,TResult? Function( List<AstNode> children)?  document,}) {final _that = this;
switch (_that) {
case FreeText() when freeText != null:
return freeText(_that.text);case GroupNode() when group != null:
return group(_that.children,_that.isOption);case OtherMacroNode() when otherMacro != null:
return otherMacro(_that.name,_that.children);case InputNode() when input != null:
return input(_that.path);case BlockCommentNode() when blockComment != null:
return blockComment(_that.content);case BibliographyNode() when bibliography != null:
return bibliography(_that.sources);case IncludeGraphicsNode() when includeGraphics != null:
return includeGraphics(_that.path,_that.options);case DocumentNode() when document != null:
return document(_that.children);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class FreeText extends AstNode {
  const FreeText(this.text, { String? $type}): $type = $type ?? 'freeText',super._();
  factory FreeText.fromJson(Map<String, dynamic> json) => _$FreeTextFromJson(json);

 final  String text;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of AstNode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FreeTextCopyWith<FreeText> get copyWith => _$FreeTextCopyWithImpl<FreeText>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FreeTextToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is FreeText&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,text);
}

@override
String toString() {
    return 'AstNode.freeText(text: $text)';
}


}

/// @nodoc
abstract mixin class $FreeTextCopyWith<$Res> implements $AstNodeCopyWith<$Res> {
  factory $FreeTextCopyWith(FreeText value, $Res Function(FreeText) _then) = _$FreeTextCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class _$FreeTextCopyWithImpl<$Res>
    implements $FreeTextCopyWith<$Res> {
  _$FreeTextCopyWithImpl(this._self, this._then);

  final FreeText _self;
  final $Res Function(FreeText) _then;

/// Create a copy of AstNode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(FreeText(
null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class GroupNode extends AstNode with BranchNode {
  const GroupNode({required  List<AstNode> children, this.isOption = false,  String? $type}): _children = children,$type = $type ?? 'group',super._();
  factory GroupNode.fromJson(Map<String, dynamic> json) => _$GroupNodeFromJson(json);

 final  List<AstNode> _children;
 List<AstNode> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}

@JsonKey() final  bool isOption;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of AstNode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupNodeCopyWith<GroupNode> get copyWith => _$GroupNodeCopyWithImpl<GroupNode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupNodeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupNode&&const DeepCollectionEquality().equals(other.children, _children)&&(identical(other.isOption, isOption) || other.isOption == isOption));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_children),isOption);
}

@override
String toString() {
    return 'AstNode.group(children: $children, isOption: $isOption)';
}


}

/// @nodoc
abstract mixin class $GroupNodeCopyWith<$Res> implements $AstNodeCopyWith<$Res> {
  factory $GroupNodeCopyWith(GroupNode value, $Res Function(GroupNode) _then) = _$GroupNodeCopyWithImpl;
@useResult
$Res call({
 List<AstNode> children, bool isOption
});




}
/// @nodoc
class _$GroupNodeCopyWithImpl<$Res>
    implements $GroupNodeCopyWith<$Res> {
  _$GroupNodeCopyWithImpl(this._self, this._then);

  final GroupNode _self;
  final $Res Function(GroupNode) _then;

/// Create a copy of AstNode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? children = null,Object? isOption = null,}) {
  return _then(GroupNode(
children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<AstNode>,isOption: null == isOption ? _self.isOption : isOption // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
@JsonSerializable()

class OtherMacroNode extends AstNode with BranchNode {
  const OtherMacroNode({required this.name, required  List<AstNode> children,  String? $type}): _children = children,$type = $type ?? 'otherMacro',super._();
  factory OtherMacroNode.fromJson(Map<String, dynamic> json) => _$OtherMacroNodeFromJson(json);

 final  String name;
 final  List<AstNode> _children;
 List<AstNode> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of AstNode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtherMacroNodeCopyWith<OtherMacroNode> get copyWith => _$OtherMacroNodeCopyWithImpl<OtherMacroNode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OtherMacroNodeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is OtherMacroNode&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.children, _children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,const DeepCollectionEquality().hash(_children));
}

@override
String toString() {
    return 'AstNode.otherMacro(name: $name, children: $children)';
}


}

/// @nodoc
abstract mixin class $OtherMacroNodeCopyWith<$Res> implements $AstNodeCopyWith<$Res> {
  factory $OtherMacroNodeCopyWith(OtherMacroNode value, $Res Function(OtherMacroNode) _then) = _$OtherMacroNodeCopyWithImpl;
@useResult
$Res call({
 String name, List<AstNode> children
});




}
/// @nodoc
class _$OtherMacroNodeCopyWithImpl<$Res>
    implements $OtherMacroNodeCopyWith<$Res> {
  _$OtherMacroNodeCopyWithImpl(this._self, this._then);

  final OtherMacroNode _self;
  final $Res Function(OtherMacroNode) _then;

/// Create a copy of AstNode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,Object? children = null,}) {
  return _then(OtherMacroNode(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<AstNode>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class InputNode extends AstNode {
  const InputNode({required this.path,  String? $type}): $type = $type ?? 'input',super._();
  factory InputNode.fromJson(Map<String, dynamic> json) => _$InputNodeFromJson(json);

 final  String path;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of AstNode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InputNodeCopyWith<InputNode> get copyWith => _$InputNodeCopyWithImpl<InputNode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InputNodeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is InputNode&&(identical(other.path, path) || other.path == path));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,path);
}

@override
String toString() {
    return 'AstNode.input(path: $path)';
}


}

/// @nodoc
abstract mixin class $InputNodeCopyWith<$Res> implements $AstNodeCopyWith<$Res> {
  factory $InputNodeCopyWith(InputNode value, $Res Function(InputNode) _then) = _$InputNodeCopyWithImpl;
@useResult
$Res call({
 String path
});




}
/// @nodoc
class _$InputNodeCopyWithImpl<$Res>
    implements $InputNodeCopyWith<$Res> {
  _$InputNodeCopyWithImpl(this._self, this._then);

  final InputNode _self;
  final $Res Function(InputNode) _then;

/// Create a copy of AstNode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? path = null,}) {
  return _then(InputNode(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class BlockCommentNode extends AstNode {
  const BlockCommentNode({required this.content,  String? $type}): $type = $type ?? 'blockComment',super._();
  factory BlockCommentNode.fromJson(Map<String, dynamic> json) => _$BlockCommentNodeFromJson(json);

 final  String content;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of AstNode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockCommentNodeCopyWith<BlockCommentNode> get copyWith => _$BlockCommentNodeCopyWithImpl<BlockCommentNode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlockCommentNodeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockCommentNode&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,content);
}

@override
String toString() {
    return 'AstNode.blockComment(content: $content)';
}


}

/// @nodoc
abstract mixin class $BlockCommentNodeCopyWith<$Res> implements $AstNodeCopyWith<$Res> {
  factory $BlockCommentNodeCopyWith(BlockCommentNode value, $Res Function(BlockCommentNode) _then) = _$BlockCommentNodeCopyWithImpl;
@useResult
$Res call({
 String content
});




}
/// @nodoc
class _$BlockCommentNodeCopyWithImpl<$Res>
    implements $BlockCommentNodeCopyWith<$Res> {
  _$BlockCommentNodeCopyWithImpl(this._self, this._then);

  final BlockCommentNode _self;
  final $Res Function(BlockCommentNode) _then;

/// Create a copy of AstNode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? content = null,}) {
  return _then(BlockCommentNode(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class BibliographyNode extends AstNode {
  const BibliographyNode({required  List<String> sources,  String? $type}): _sources = sources,$type = $type ?? 'bibliography',super._();
  factory BibliographyNode.fromJson(Map<String, dynamic> json) => _$BibliographyNodeFromJson(json);

 final  List<String> _sources;
 List<String> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of AstNode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BibliographyNodeCopyWith<BibliographyNode> get copyWith => _$BibliographyNodeCopyWithImpl<BibliographyNode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BibliographyNodeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BibliographyNode&&const DeepCollectionEquality().equals(other.sources, _sources));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_sources));
}

@override
String toString() {
    return 'AstNode.bibliography(sources: $sources)';
}


}

/// @nodoc
abstract mixin class $BibliographyNodeCopyWith<$Res> implements $AstNodeCopyWith<$Res> {
  factory $BibliographyNodeCopyWith(BibliographyNode value, $Res Function(BibliographyNode) _then) = _$BibliographyNodeCopyWithImpl;
@useResult
$Res call({
 List<String> sources
});




}
/// @nodoc
class _$BibliographyNodeCopyWithImpl<$Res>
    implements $BibliographyNodeCopyWith<$Res> {
  _$BibliographyNodeCopyWithImpl(this._self, this._then);

  final BibliographyNode _self;
  final $Res Function(BibliographyNode) _then;

/// Create a copy of AstNode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? sources = null,}) {
  return _then(BibliographyNode(
sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class IncludeGraphicsNode extends AstNode {
  const IncludeGraphicsNode({required this.path, this.options,  String? $type}): $type = $type ?? 'includeGraphics',super._();
  factory IncludeGraphicsNode.fromJson(Map<String, dynamic> json) => _$IncludeGraphicsNodeFromJson(json);

 final  String path;
 final  GroupNode? options;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of AstNode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IncludeGraphicsNodeCopyWith<IncludeGraphicsNode> get copyWith => _$IncludeGraphicsNodeCopyWithImpl<IncludeGraphicsNode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IncludeGraphicsNodeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is IncludeGraphicsNode&&(identical(other.path, path) || other.path == path)&&const DeepCollectionEquality().equals(other.options, options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,path,const DeepCollectionEquality().hash(options));
}

@override
String toString() {
    return 'AstNode.includeGraphics(path: $path, options: $options)';
}


}

/// @nodoc
abstract mixin class $IncludeGraphicsNodeCopyWith<$Res> implements $AstNodeCopyWith<$Res> {
  factory $IncludeGraphicsNodeCopyWith(IncludeGraphicsNode value, $Res Function(IncludeGraphicsNode) _then) = _$IncludeGraphicsNodeCopyWithImpl;
@useResult
$Res call({
 String path, GroupNode? options
});




}
/// @nodoc
class _$IncludeGraphicsNodeCopyWithImpl<$Res>
    implements $IncludeGraphicsNodeCopyWith<$Res> {
  _$IncludeGraphicsNodeCopyWithImpl(this._self, this._then);

  final IncludeGraphicsNode _self;
  final $Res Function(IncludeGraphicsNode) _then;

/// Create a copy of AstNode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? path = null,Object? options = freezed,}) {
  return _then(IncludeGraphicsNode(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as GroupNode?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class DocumentNode extends AstNode with BranchNode {
  const DocumentNode({required  List<AstNode> children,  String? $type}): _children = children,$type = $type ?? 'document',super._();
  factory DocumentNode.fromJson(Map<String, dynamic> json) => _$DocumentNodeFromJson(json);

 final  List<AstNode> _children;
 List<AstNode> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of AstNode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentNodeCopyWith<DocumentNode> get copyWith => _$DocumentNodeCopyWithImpl<DocumentNode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DocumentNodeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentNode&&const DeepCollectionEquality().equals(other.children, _children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_children));
}

@override
String toString() {
    return 'AstNode.document(children: $children)';
}


}

/// @nodoc
abstract mixin class $DocumentNodeCopyWith<$Res> implements $AstNodeCopyWith<$Res> {
  factory $DocumentNodeCopyWith(DocumentNode value, $Res Function(DocumentNode) _then) = _$DocumentNodeCopyWithImpl;
@useResult
$Res call({
 List<AstNode> children
});




}
/// @nodoc
class _$DocumentNodeCopyWithImpl<$Res>
    implements $DocumentNodeCopyWith<$Res> {
  _$DocumentNodeCopyWithImpl(this._self, this._then);

  final DocumentNode _self;
  final $Res Function(DocumentNode) _then;

/// Create a copy of AstNode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? children = null,}) {
  return _then(DocumentNode(
children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<AstNode>,
  ));
}


}

// dart format on
