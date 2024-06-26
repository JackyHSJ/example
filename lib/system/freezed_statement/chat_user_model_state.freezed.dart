// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'chat_user_model_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$ChatUserModelStateTearOff {
  const _$ChatUserModelStateTearOff();

  ChatUserModelInitial init() {
    return const ChatUserModelInitial();
  }

  ChatUserModelLoading loading() {
    return const ChatUserModelLoading();
  }

  ChatUserModelData data({required List<ChatUserModel> chatUserModelList}) {
    return ChatUserModelData(
      chatUserModelList: chatUserModelList,
    );
  }

  ChatUserModelError error({required String msg}) {
    return ChatUserModelError(
      msg: msg,
    );
  }
}

/// @nodoc
const $ChatUserModelState = _$ChatUserModelStateTearOff();

/// @nodoc
mixin _$ChatUserModelState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(List<ChatUserModel> chatUserModelList) data,
    required TResult Function(String msg) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(List<ChatUserModel> chatUserModelList)? data,
    TResult Function(String msg)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(List<ChatUserModel> chatUserModelList)? data,
    TResult Function(String msg)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatUserModelInitial value) init,
    required TResult Function(ChatUserModelLoading value) loading,
    required TResult Function(ChatUserModelData value) data,
    required TResult Function(ChatUserModelError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ChatUserModelInitial value)? init,
    TResult Function(ChatUserModelLoading value)? loading,
    TResult Function(ChatUserModelData value)? data,
    TResult Function(ChatUserModelError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatUserModelInitial value)? init,
    TResult Function(ChatUserModelLoading value)? loading,
    TResult Function(ChatUserModelData value)? data,
    TResult Function(ChatUserModelError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatUserModelStateCopyWith<$Res> {
  factory $ChatUserModelStateCopyWith(
          ChatUserModelState value, $Res Function(ChatUserModelState) then) =
      _$ChatUserModelStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$ChatUserModelStateCopyWithImpl<$Res> implements $ChatUserModelStateCopyWith<$Res> {
  _$ChatUserModelStateCopyWithImpl(this._value, this._then);

  final ChatUserModelState _value;
  // ignore: unused_field
  final $Res Function(ChatUserModelState) _then;
}

/// @nodoc
abstract class $ChatUserModelInitialCopyWith<$Res> {
  factory $ChatUserModelInitialCopyWith(
          ChatUserModelInitial value, $Res Function(ChatUserModelInitial) then) =
      _$ChatUserModelInitialCopyWithImpl<$Res>;
}

/// @nodoc
class _$ChatUserModelInitialCopyWithImpl<$Res>
    extends _$ChatUserModelStateCopyWithImpl<$Res>
    implements $ChatUserModelInitialCopyWith<$Res> {
  _$ChatUserModelInitialCopyWithImpl(
      ChatUserModelInitial _value, $Res Function(ChatUserModelInitial) _then)
      : super(_value, (v) => _then(v as ChatUserModelInitial));

  @override
  ChatUserModelInitial get _value => super._value as ChatUserModelInitial;
}

/// @nodoc

class _$ChatUserModelInitial implements ChatUserModelInitial {
  const _$ChatUserModelInitial();

  @override
  String toString() {
    return 'ChatUserModelState.init()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ChatUserModelInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(List<ChatUserModel> chatUserModelList) data,
    required TResult Function(String msg) error,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(List<ChatUserModel> chatUserModelList)? data,
    TResult Function(String msg)? error,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(List<ChatUserModel> chatUserModelList)? data,
    TResult Function(String msg)? error,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatUserModelInitial value) init,
    required TResult Function(ChatUserModelLoading value) loading,
    required TResult Function(ChatUserModelData value) data,
    required TResult Function(ChatUserModelError value) error,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ChatUserModelInitial value)? init,
    TResult Function(ChatUserModelLoading value)? loading,
    TResult Function(ChatUserModelData value)? data,
    TResult Function(ChatUserModelError value)? error,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatUserModelInitial value)? init,
    TResult Function(ChatUserModelLoading value)? loading,
    TResult Function(ChatUserModelData value)? data,
    TResult Function(ChatUserModelError value)? error,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class ChatUserModelInitial implements ChatUserModelState {
  const factory ChatUserModelInitial() = _$ChatUserModelInitial;
}

/// @nodoc
abstract class $ChatUserModelLoadingCopyWith<$Res> {
  factory $ChatUserModelLoadingCopyWith(
          ChatUserModelLoading value, $Res Function(ChatUserModelLoading) then) =
      _$ChatUserModelLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class _$ChatUserModelLoadingCopyWithImpl<$Res>
    extends _$ChatUserModelStateCopyWithImpl<$Res>
    implements $ChatUserModelLoadingCopyWith<$Res> {
  _$ChatUserModelLoadingCopyWithImpl(
      ChatUserModelLoading _value, $Res Function(ChatUserModelLoading) _then)
      : super(_value, (v) => _then(v as ChatUserModelLoading));

  @override
  ChatUserModelLoading get _value => super._value as ChatUserModelLoading;
}

/// @nodoc

class _$ChatUserModelLoading implements ChatUserModelLoading {
  const _$ChatUserModelLoading();

  @override
  String toString() {
    return 'ChatUserModelState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ChatUserModelLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(List<ChatUserModel> chatUserModelList) data,
    required TResult Function(String msg) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(List<ChatUserModel> chatUserModelList)? data,
    TResult Function(String msg)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(List<ChatUserModel> chatUserModelList)? data,
    TResult Function(String msg)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatUserModelInitial value) init,
    required TResult Function(ChatUserModelLoading value) loading,
    required TResult Function(ChatUserModelData value) data,
    required TResult Function(ChatUserModelError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ChatUserModelInitial value)? init,
    TResult Function(ChatUserModelLoading value)? loading,
    TResult Function(ChatUserModelData value)? data,
    TResult Function(ChatUserModelError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatUserModelInitial value)? init,
    TResult Function(ChatUserModelLoading value)? loading,
    TResult Function(ChatUserModelData value)? data,
    TResult Function(ChatUserModelError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class ChatUserModelLoading implements ChatUserModelState {
  const factory ChatUserModelLoading() = _$ChatUserModelLoading;
}

/// @nodoc
abstract class $ChatUserModelDataCopyWith<$Res> {
  factory $ChatUserModelDataCopyWith(
          ChatUserModelData value, $Res Function(ChatUserModelData) then) =
      _$ChatUserModelDataCopyWithImpl<$Res>;
  $Res call({List<ChatUserModel> chatUserModelList});
}

/// @nodoc
class _$ChatUserModelDataCopyWithImpl<$Res> extends _$ChatUserModelStateCopyWithImpl<$Res>
    implements $ChatUserModelDataCopyWith<$Res> {
  _$ChatUserModelDataCopyWithImpl(
      ChatUserModelData _value, $Res Function(ChatUserModelData) _then)
      : super(_value, (v) => _then(v as ChatUserModelData));

  @override
  ChatUserModelData get _value => super._value as ChatUserModelData;

  @override
  $Res call({
    Object? chatUserModelList = freezed,
  }) {
    return _then(ChatUserModelData(
      chatUserModelList: chatUserModelList == freezed
          ? _value.chatUserModelList
          : chatUserModelList // ignore: cast_nullable_to_non_nullable
              as List<ChatUserModel>,
    ));
  }
}

/// @nodoc

class _$ChatUserModelData implements ChatUserModelData {
  const _$ChatUserModelData({required this.chatUserModelList});

  @override
  final List<ChatUserModel> chatUserModelList;

  @override
  String toString() {
    return 'ChatUserModelState.data(chatUserModelList: $chatUserModelList)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatUserModelData &&
            const DeepCollectionEquality()
                .equals(other.chatUserModelList, chatUserModelList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(chatUserModelList));

  @JsonKey(ignore: true)
  @override
  $ChatUserModelDataCopyWith<ChatUserModelData> get copyWith =>
      _$ChatUserModelDataCopyWithImpl<ChatUserModelData>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(List<ChatUserModel> chatUserModelList) data,
    required TResult Function(String msg) error,
  }) {
    return data(chatUserModelList);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(List<ChatUserModel> chatUserModelList)? data,
    TResult Function(String msg)? error,
  }) {
    return data?.call(chatUserModelList);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(List<ChatUserModel> chatUserModelList)? data,
    TResult Function(String msg)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(chatUserModelList);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatUserModelInitial value) init,
    required TResult Function(ChatUserModelLoading value) loading,
    required TResult Function(ChatUserModelData value) data,
    required TResult Function(ChatUserModelError value) error,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ChatUserModelInitial value)? init,
    TResult Function(ChatUserModelLoading value)? loading,
    TResult Function(ChatUserModelData value)? data,
    TResult Function(ChatUserModelError value)? error,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatUserModelInitial value)? init,
    TResult Function(ChatUserModelLoading value)? loading,
    TResult Function(ChatUserModelData value)? data,
    TResult Function(ChatUserModelError value)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class ChatUserModelData implements ChatUserModelState {
  const factory ChatUserModelData({required List<ChatUserModel> chatUserModelList}) =
      _$ChatUserModelData;

  List<ChatUserModel> get chatUserModelList;
  @JsonKey(ignore: true)
  $ChatUserModelDataCopyWith<ChatUserModelData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatUserModelErrorCopyWith<$Res> {
  factory $ChatUserModelErrorCopyWith(
          ChatUserModelError value, $Res Function(ChatUserModelError) then) =
      _$ChatUserModelErrorCopyWithImpl<$Res>;
  $Res call({String msg});
}

/// @nodoc
class _$ChatUserModelErrorCopyWithImpl<$Res> extends _$ChatUserModelStateCopyWithImpl<$Res>
    implements $ChatUserModelErrorCopyWith<$Res> {
  _$ChatUserModelErrorCopyWithImpl(
      ChatUserModelError _value, $Res Function(ChatUserModelError) _then)
      : super(_value, (v) => _then(v as ChatUserModelError));

  @override
  ChatUserModelError get _value => super._value as ChatUserModelError;

  @override
  $Res call({
    Object? msg = freezed,
  }) {
    return _then(ChatUserModelError(
      msg: msg == freezed
          ? _value.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ChatUserModelError implements ChatUserModelError {
  const _$ChatUserModelError({required this.msg});

  @override
  final String msg;

  @override
  String toString() {
    return 'ChatUserModelState.error(msg: $msg)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatUserModelError &&
            const DeepCollectionEquality().equals(other.msg, msg));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(msg));

  @JsonKey(ignore: true)
  @override
  $ChatUserModelErrorCopyWith<ChatUserModelError> get copyWith =>
      _$ChatUserModelErrorCopyWithImpl<ChatUserModelError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(List<ChatUserModel> chatUserModelList) data,
    required TResult Function(String msg) error,
  }) {
    return error(msg);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(List<ChatUserModel> chatUserModelList)? data,
    TResult Function(String msg)? error,
  }) {
    return error?.call(msg);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(List<ChatUserModel> chatUserModelList)? data,
    TResult Function(String msg)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(msg);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatUserModelInitial value) init,
    required TResult Function(ChatUserModelLoading value) loading,
    required TResult Function(ChatUserModelData value) data,
    required TResult Function(ChatUserModelError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ChatUserModelInitial value)? init,
    TResult Function(ChatUserModelLoading value)? loading,
    TResult Function(ChatUserModelData value)? data,
    TResult Function(ChatUserModelError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatUserModelInitial value)? init,
    TResult Function(ChatUserModelLoading value)? loading,
    TResult Function(ChatUserModelData value)? data,
    TResult Function(ChatUserModelError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ChatUserModelError implements ChatUserModelState {
  const factory ChatUserModelError({required String msg}) = _$ChatUserModelError;

  String get msg;
  @JsonKey(ignore: true)
  $ChatUserModelErrorCopyWith<ChatUserModelError> get copyWith =>
      throw _privateConstructorUsedError;
}
