// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_list_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ItemListState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(AppErrors error, VoidCallback callback) error,
    required TResult Function(List<T> data) loaded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(AppErrors error, VoidCallback callback)? error,
    TResult? Function(List<T> data)? loaded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(AppErrors error, VoidCallback callback)? error,
    TResult Function(List<T> data)? loaded,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ItemListInitState<T> value) initial,
    required TResult Function(ItemListLoadingState<T> value) loading,
    required TResult Function(ItemListErrorState<T> value) error,
    required TResult Function(ItemListLoadedState<T> value) loaded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ItemListInitState<T> value)? initial,
    TResult? Function(ItemListLoadingState<T> value)? loading,
    TResult? Function(ItemListErrorState<T> value)? error,
    TResult? Function(ItemListLoadedState<T> value)? loaded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ItemListInitState<T> value)? initial,
    TResult Function(ItemListLoadingState<T> value)? loading,
    TResult Function(ItemListErrorState<T> value)? error,
    TResult Function(ItemListLoadedState<T> value)? loaded,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemListStateCopyWith<T, $Res> {
  factory $ItemListStateCopyWith(
          ItemListState<T> value, $Res Function(ItemListState<T>) then) =
      _$ItemListStateCopyWithImpl<T, $Res, ItemListState<T>>;
}

/// @nodoc
class _$ItemListStateCopyWithImpl<T, $Res, $Val extends ItemListState<T>>
    implements $ItemListStateCopyWith<T, $Res> {
  _$ItemListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ItemListInitStateImplCopyWith<T, $Res> {
  factory _$$ItemListInitStateImplCopyWith(_$ItemListInitStateImpl<T> value,
          $Res Function(_$ItemListInitStateImpl<T>) then) =
      __$$ItemListInitStateImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$ItemListInitStateImplCopyWithImpl<T, $Res>
    extends _$ItemListStateCopyWithImpl<T, $Res, _$ItemListInitStateImpl<T>>
    implements _$$ItemListInitStateImplCopyWith<T, $Res> {
  __$$ItemListInitStateImplCopyWithImpl(_$ItemListInitStateImpl<T> _value,
      $Res Function(_$ItemListInitStateImpl<T>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ItemListInitStateImpl<T>
    with DiagnosticableTreeMixin
    implements ItemListInitState<T> {
  const _$ItemListInitStateImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ItemListState<$T>.initial()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'ItemListState<$T>.initial'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemListInitStateImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(AppErrors error, VoidCallback callback) error,
    required TResult Function(List<T> data) loaded,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(AppErrors error, VoidCallback callback)? error,
    TResult? Function(List<T> data)? loaded,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(AppErrors error, VoidCallback callback)? error,
    TResult Function(List<T> data)? loaded,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ItemListInitState<T> value) initial,
    required TResult Function(ItemListLoadingState<T> value) loading,
    required TResult Function(ItemListErrorState<T> value) error,
    required TResult Function(ItemListLoadedState<T> value) loaded,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ItemListInitState<T> value)? initial,
    TResult? Function(ItemListLoadingState<T> value)? loading,
    TResult? Function(ItemListErrorState<T> value)? error,
    TResult? Function(ItemListLoadedState<T> value)? loaded,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ItemListInitState<T> value)? initial,
    TResult Function(ItemListLoadingState<T> value)? loading,
    TResult Function(ItemListErrorState<T> value)? error,
    TResult Function(ItemListLoadedState<T> value)? loaded,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class ItemListInitState<T> implements ItemListState<T> {
  const factory ItemListInitState() = _$ItemListInitStateImpl<T>;
}

/// @nodoc
abstract class _$$ItemListLoadingStateImplCopyWith<T, $Res> {
  factory _$$ItemListLoadingStateImplCopyWith(
          _$ItemListLoadingStateImpl<T> value,
          $Res Function(_$ItemListLoadingStateImpl<T>) then) =
      __$$ItemListLoadingStateImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$ItemListLoadingStateImplCopyWithImpl<T, $Res>
    extends _$ItemListStateCopyWithImpl<T, $Res, _$ItemListLoadingStateImpl<T>>
    implements _$$ItemListLoadingStateImplCopyWith<T, $Res> {
  __$$ItemListLoadingStateImplCopyWithImpl(_$ItemListLoadingStateImpl<T> _value,
      $Res Function(_$ItemListLoadingStateImpl<T>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ItemListLoadingStateImpl<T>
    with DiagnosticableTreeMixin
    implements ItemListLoadingState<T> {
  const _$ItemListLoadingStateImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ItemListState<$T>.loading()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'ItemListState<$T>.loading'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemListLoadingStateImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(AppErrors error, VoidCallback callback) error,
    required TResult Function(List<T> data) loaded,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(AppErrors error, VoidCallback callback)? error,
    TResult? Function(List<T> data)? loaded,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(AppErrors error, VoidCallback callback)? error,
    TResult Function(List<T> data)? loaded,
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
    required TResult Function(ItemListInitState<T> value) initial,
    required TResult Function(ItemListLoadingState<T> value) loading,
    required TResult Function(ItemListErrorState<T> value) error,
    required TResult Function(ItemListLoadedState<T> value) loaded,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ItemListInitState<T> value)? initial,
    TResult? Function(ItemListLoadingState<T> value)? loading,
    TResult? Function(ItemListErrorState<T> value)? error,
    TResult? Function(ItemListLoadedState<T> value)? loaded,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ItemListInitState<T> value)? initial,
    TResult Function(ItemListLoadingState<T> value)? loading,
    TResult Function(ItemListErrorState<T> value)? error,
    TResult Function(ItemListLoadedState<T> value)? loaded,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class ItemListLoadingState<T> implements ItemListState<T> {
  const factory ItemListLoadingState() = _$ItemListLoadingStateImpl<T>;
}

/// @nodoc
abstract class _$$ItemListErrorStateImplCopyWith<T, $Res> {
  factory _$$ItemListErrorStateImplCopyWith(_$ItemListErrorStateImpl<T> value,
          $Res Function(_$ItemListErrorStateImpl<T>) then) =
      __$$ItemListErrorStateImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({AppErrors error, VoidCallback callback});

  $AppErrorsCopyWith<$Res> get error;
}

/// @nodoc
class __$$ItemListErrorStateImplCopyWithImpl<T, $Res>
    extends _$ItemListStateCopyWithImpl<T, $Res, _$ItemListErrorStateImpl<T>>
    implements _$$ItemListErrorStateImplCopyWith<T, $Res> {
  __$$ItemListErrorStateImplCopyWithImpl(_$ItemListErrorStateImpl<T> _value,
      $Res Function(_$ItemListErrorStateImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? callback = null,
  }) {
    return _then(_$ItemListErrorStateImpl<T>(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as AppErrors,
      callback: null == callback
          ? _value.callback
          : callback // ignore: cast_nullable_to_non_nullable
              as VoidCallback,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $AppErrorsCopyWith<$Res> get error {
    return $AppErrorsCopyWith<$Res>(_value.error, (value) {
      return _then(_value.copyWith(error: value));
    });
  }
}

/// @nodoc

class _$ItemListErrorStateImpl<T>
    with DiagnosticableTreeMixin
    implements ItemListErrorState<T> {
  const _$ItemListErrorStateImpl({required this.error, required this.callback});

  @override
  final AppErrors error;
  @override
  final VoidCallback callback;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ItemListState<$T>.error(error: $error, callback: $callback)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ItemListState<$T>.error'))
      ..add(DiagnosticsProperty('error', error))
      ..add(DiagnosticsProperty('callback', callback));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemListErrorStateImpl<T> &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.callback, callback) ||
                other.callback == callback));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error, callback);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemListErrorStateImplCopyWith<T, _$ItemListErrorStateImpl<T>>
      get copyWith => __$$ItemListErrorStateImplCopyWithImpl<T,
          _$ItemListErrorStateImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(AppErrors error, VoidCallback callback) error,
    required TResult Function(List<T> data) loaded,
  }) {
    return error(this.error, callback);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(AppErrors error, VoidCallback callback)? error,
    TResult? Function(List<T> data)? loaded,
  }) {
    return error?.call(this.error, callback);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(AppErrors error, VoidCallback callback)? error,
    TResult Function(List<T> data)? loaded,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this.error, callback);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ItemListInitState<T> value) initial,
    required TResult Function(ItemListLoadingState<T> value) loading,
    required TResult Function(ItemListErrorState<T> value) error,
    required TResult Function(ItemListLoadedState<T> value) loaded,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ItemListInitState<T> value)? initial,
    TResult? Function(ItemListLoadingState<T> value)? loading,
    TResult? Function(ItemListErrorState<T> value)? error,
    TResult? Function(ItemListLoadedState<T> value)? loaded,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ItemListInitState<T> value)? initial,
    TResult Function(ItemListLoadingState<T> value)? loading,
    TResult Function(ItemListErrorState<T> value)? error,
    TResult Function(ItemListLoadedState<T> value)? loaded,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ItemListErrorState<T> implements ItemListState<T> {
  const factory ItemListErrorState(
      {required final AppErrors error,
      required final VoidCallback callback}) = _$ItemListErrorStateImpl<T>;

  AppErrors get error;
  VoidCallback get callback;
  @JsonKey(ignore: true)
  _$$ItemListErrorStateImplCopyWith<T, _$ItemListErrorStateImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ItemListLoadedStateImplCopyWith<T, $Res> {
  factory _$$ItemListLoadedStateImplCopyWith(_$ItemListLoadedStateImpl<T> value,
          $Res Function(_$ItemListLoadedStateImpl<T>) then) =
      __$$ItemListLoadedStateImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({List<T> data});
}

/// @nodoc
class __$$ItemListLoadedStateImplCopyWithImpl<T, $Res>
    extends _$ItemListStateCopyWithImpl<T, $Res, _$ItemListLoadedStateImpl<T>>
    implements _$$ItemListLoadedStateImplCopyWith<T, $Res> {
  __$$ItemListLoadedStateImplCopyWithImpl(_$ItemListLoadedStateImpl<T> _value,
      $Res Function(_$ItemListLoadedStateImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$ItemListLoadedStateImpl<T>(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<T>,
    ));
  }
}

/// @nodoc

class _$ItemListLoadedStateImpl<T>
    with DiagnosticableTreeMixin
    implements ItemListLoadedState<T> {
  const _$ItemListLoadedStateImpl({required final List<T> data}) : _data = data;

  final List<T> _data;
  @override
  List<T> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ItemListState<$T>.loaded(data: $data)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ItemListState<$T>.loaded'))
      ..add(DiagnosticsProperty('data', data));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemListLoadedStateImpl<T> &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemListLoadedStateImplCopyWith<T, _$ItemListLoadedStateImpl<T>>
      get copyWith => __$$ItemListLoadedStateImplCopyWithImpl<T,
          _$ItemListLoadedStateImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(AppErrors error, VoidCallback callback) error,
    required TResult Function(List<T> data) loaded,
  }) {
    return loaded(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(AppErrors error, VoidCallback callback)? error,
    TResult? Function(List<T> data)? loaded,
  }) {
    return loaded?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(AppErrors error, VoidCallback callback)? error,
    TResult Function(List<T> data)? loaded,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ItemListInitState<T> value) initial,
    required TResult Function(ItemListLoadingState<T> value) loading,
    required TResult Function(ItemListErrorState<T> value) error,
    required TResult Function(ItemListLoadedState<T> value) loaded,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ItemListInitState<T> value)? initial,
    TResult? Function(ItemListLoadingState<T> value)? loading,
    TResult? Function(ItemListErrorState<T> value)? error,
    TResult? Function(ItemListLoadedState<T> value)? loaded,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ItemListInitState<T> value)? initial,
    TResult Function(ItemListLoadingState<T> value)? loading,
    TResult Function(ItemListErrorState<T> value)? error,
    TResult Function(ItemListLoadedState<T> value)? loaded,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class ItemListLoadedState<T> implements ItemListState<T> {
  const factory ItemListLoadedState({required final List<T> data}) =
      _$ItemListLoadedStateImpl<T>;

  List<T> get data;
  @JsonKey(ignore: true)
  _$$ItemListLoadedStateImplCopyWith<T, _$ItemListLoadedStateImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}
