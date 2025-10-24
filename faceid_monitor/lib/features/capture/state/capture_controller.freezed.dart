// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'capture_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CaptureState {
  List<String> get capturedPhotos => throw _privateConstructorUsedError;
  bool get isCapturing => throw _privateConstructorUsedError;
  bool get isCameraActive => throw _privateConstructorUsedError;

  /// Create a copy of CaptureState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CaptureStateCopyWith<CaptureState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CaptureStateCopyWith<$Res> {
  factory $CaptureStateCopyWith(
          CaptureState value, $Res Function(CaptureState) then) =
      _$CaptureStateCopyWithImpl<$Res, CaptureState>;
  @useResult
  $Res call(
      {List<String> capturedPhotos, bool isCapturing, bool isCameraActive});
}

/// @nodoc
class _$CaptureStateCopyWithImpl<$Res, $Val extends CaptureState>
    implements $CaptureStateCopyWith<$Res> {
  _$CaptureStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CaptureState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? capturedPhotos = null,
    Object? isCapturing = null,
    Object? isCameraActive = null,
  }) {
    return _then(_value.copyWith(
      capturedPhotos: null == capturedPhotos
          ? _value.capturedPhotos
          : capturedPhotos // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isCapturing: null == isCapturing
          ? _value.isCapturing
          : isCapturing // ignore: cast_nullable_to_non_nullable
              as bool,
      isCameraActive: null == isCameraActive
          ? _value.isCameraActive
          : isCameraActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CaptureStateImplCopyWith<$Res>
    implements $CaptureStateCopyWith<$Res> {
  factory _$$CaptureStateImplCopyWith(
          _$CaptureStateImpl value, $Res Function(_$CaptureStateImpl) then) =
      __$$CaptureStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> capturedPhotos, bool isCapturing, bool isCameraActive});
}

/// @nodoc
class __$$CaptureStateImplCopyWithImpl<$Res>
    extends _$CaptureStateCopyWithImpl<$Res, _$CaptureStateImpl>
    implements _$$CaptureStateImplCopyWith<$Res> {
  __$$CaptureStateImplCopyWithImpl(
      _$CaptureStateImpl _value, $Res Function(_$CaptureStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CaptureState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? capturedPhotos = null,
    Object? isCapturing = null,
    Object? isCameraActive = null,
  }) {
    return _then(_$CaptureStateImpl(
      capturedPhotos: null == capturedPhotos
          ? _value._capturedPhotos
          : capturedPhotos // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isCapturing: null == isCapturing
          ? _value.isCapturing
          : isCapturing // ignore: cast_nullable_to_non_nullable
              as bool,
      isCameraActive: null == isCameraActive
          ? _value.isCameraActive
          : isCameraActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$CaptureStateImpl implements _CaptureState {
  const _$CaptureStateImpl(
      {final List<String> capturedPhotos = const [],
      this.isCapturing = false,
      this.isCameraActive = true})
      : _capturedPhotos = capturedPhotos;

  final List<String> _capturedPhotos;
  @override
  @JsonKey()
  List<String> get capturedPhotos {
    if (_capturedPhotos is EqualUnmodifiableListView) return _capturedPhotos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_capturedPhotos);
  }

  @override
  @JsonKey()
  final bool isCapturing;
  @override
  @JsonKey()
  final bool isCameraActive;

  @override
  String toString() {
    return 'CaptureState(capturedPhotos: $capturedPhotos, isCapturing: $isCapturing, isCameraActive: $isCameraActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CaptureStateImpl &&
            const DeepCollectionEquality()
                .equals(other._capturedPhotos, _capturedPhotos) &&
            (identical(other.isCapturing, isCapturing) ||
                other.isCapturing == isCapturing) &&
            (identical(other.isCameraActive, isCameraActive) ||
                other.isCameraActive == isCameraActive));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_capturedPhotos),
      isCapturing,
      isCameraActive);

  /// Create a copy of CaptureState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CaptureStateImplCopyWith<_$CaptureStateImpl> get copyWith =>
      __$$CaptureStateImplCopyWithImpl<_$CaptureStateImpl>(this, _$identity);
}

abstract class _CaptureState implements CaptureState {
  const factory _CaptureState(
      {final List<String> capturedPhotos,
      final bool isCapturing,
      final bool isCameraActive}) = _$CaptureStateImpl;

  @override
  List<String> get capturedPhotos;
  @override
  bool get isCapturing;
  @override
  bool get isCameraActive;

  /// Create a copy of CaptureState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CaptureStateImplCopyWith<_$CaptureStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
