// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DashboardState {
  String get cameraName => throw _privateConstructorUsedError;
  bool get isCameraLive => throw _privateConstructorUsedError;
  int get fps => throw _privateConstructorUsedError;
  Map<String, dynamic> get stats => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardStateCopyWith<DashboardState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardStateCopyWith<$Res> {
  factory $DashboardStateCopyWith(
          DashboardState value, $Res Function(DashboardState) then) =
      _$DashboardStateCopyWithImpl<$Res, DashboardState>;
  @useResult
  $Res call(
      {String cameraName,
      bool isCameraLive,
      int fps,
      Map<String, dynamic> stats,
      bool isLoading});
}

/// @nodoc
class _$DashboardStateCopyWithImpl<$Res, $Val extends DashboardState>
    implements $DashboardStateCopyWith<$Res> {
  _$DashboardStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cameraName = null,
    Object? isCameraLive = null,
    Object? fps = null,
    Object? stats = null,
    Object? isLoading = null,
  }) {
    return _then(_value.copyWith(
      cameraName: null == cameraName
          ? _value.cameraName
          : cameraName // ignore: cast_nullable_to_non_nullable
              as String,
      isCameraLive: null == isCameraLive
          ? _value.isCameraLive
          : isCameraLive // ignore: cast_nullable_to_non_nullable
              as bool,
      fps: null == fps
          ? _value.fps
          : fps // ignore: cast_nullable_to_non_nullable
              as int,
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DashboardStateImplCopyWith<$Res>
    implements $DashboardStateCopyWith<$Res> {
  factory _$$DashboardStateImplCopyWith(_$DashboardStateImpl value,
          $Res Function(_$DashboardStateImpl) then) =
      __$$DashboardStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String cameraName,
      bool isCameraLive,
      int fps,
      Map<String, dynamic> stats,
      bool isLoading});
}

/// @nodoc
class __$$DashboardStateImplCopyWithImpl<$Res>
    extends _$DashboardStateCopyWithImpl<$Res, _$DashboardStateImpl>
    implements _$$DashboardStateImplCopyWith<$Res> {
  __$$DashboardStateImplCopyWithImpl(
      _$DashboardStateImpl _value, $Res Function(_$DashboardStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cameraName = null,
    Object? isCameraLive = null,
    Object? fps = null,
    Object? stats = null,
    Object? isLoading = null,
  }) {
    return _then(_$DashboardStateImpl(
      cameraName: null == cameraName
          ? _value.cameraName
          : cameraName // ignore: cast_nullable_to_non_nullable
              as String,
      isCameraLive: null == isCameraLive
          ? _value.isCameraLive
          : isCameraLive // ignore: cast_nullable_to_non_nullable
              as bool,
      fps: null == fps
          ? _value.fps
          : fps // ignore: cast_nullable_to_non_nullable
              as int,
      stats: null == stats
          ? _value._stats
          : stats // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$DashboardStateImpl implements _DashboardState {
  const _$DashboardStateImpl(
      {this.cameraName = 'Câmera Principal',
      this.isCameraLive = true,
      this.fps = 30,
      final Map<String, dynamic> stats = const {},
      this.isLoading = false})
      : _stats = stats;

  @override
  @JsonKey()
  final String cameraName;
  @override
  @JsonKey()
  final bool isCameraLive;
  @override
  @JsonKey()
  final int fps;
  final Map<String, dynamic> _stats;
  @override
  @JsonKey()
  Map<String, dynamic> get stats {
    if (_stats is EqualUnmodifiableMapView) return _stats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_stats);
  }

  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'DashboardState(cameraName: $cameraName, isCameraLive: $isCameraLive, fps: $fps, stats: $stats, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardStateImpl &&
            (identical(other.cameraName, cameraName) ||
                other.cameraName == cameraName) &&
            (identical(other.isCameraLive, isCameraLive) ||
                other.isCameraLive == isCameraLive) &&
            (identical(other.fps, fps) || other.fps == fps) &&
            const DeepCollectionEquality().equals(other._stats, _stats) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cameraName, isCameraLive, fps,
      const DeepCollectionEquality().hash(_stats), isLoading);

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardStateImplCopyWith<_$DashboardStateImpl> get copyWith =>
      __$$DashboardStateImplCopyWithImpl<_$DashboardStateImpl>(
          this, _$identity);
}

abstract class _DashboardState implements DashboardState {
  const factory _DashboardState(
      {final String cameraName,
      final bool isCameraLive,
      final int fps,
      final Map<String, dynamic> stats,
      final bool isLoading}) = _$DashboardStateImpl;

  @override
  String get cameraName;
  @override
  bool get isCameraLive;
  @override
  int get fps;
  @override
  Map<String, dynamic> get stats;
  @override
  bool get isLoading;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardStateImplCopyWith<_$DashboardStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
