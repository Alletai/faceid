// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'logs_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LogsState {
  List<LogEntry> get logs => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of LogsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LogsStateCopyWith<LogsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogsStateCopyWith<$Res> {
  factory $LogsStateCopyWith(LogsState value, $Res Function(LogsState) then) =
      _$LogsStateCopyWithImpl<$Res, LogsState>;
  @useResult
  $Res call({List<LogEntry> logs, bool isLoading, String? errorMessage});
}

/// @nodoc
class _$LogsStateCopyWithImpl<$Res, $Val extends LogsState>
    implements $LogsStateCopyWith<$Res> {
  _$LogsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LogsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? logs = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      logs: null == logs
          ? _value.logs
          : logs // ignore: cast_nullable_to_non_nullable
              as List<LogEntry>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LogsStateImplCopyWith<$Res>
    implements $LogsStateCopyWith<$Res> {
  factory _$$LogsStateImplCopyWith(
          _$LogsStateImpl value, $Res Function(_$LogsStateImpl) then) =
      __$$LogsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<LogEntry> logs, bool isLoading, String? errorMessage});
}

/// @nodoc
class __$$LogsStateImplCopyWithImpl<$Res>
    extends _$LogsStateCopyWithImpl<$Res, _$LogsStateImpl>
    implements _$$LogsStateImplCopyWith<$Res> {
  __$$LogsStateImplCopyWithImpl(
      _$LogsStateImpl _value, $Res Function(_$LogsStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of LogsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? logs = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$LogsStateImpl(
      logs: null == logs
          ? _value._logs
          : logs // ignore: cast_nullable_to_non_nullable
              as List<LogEntry>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$LogsStateImpl implements _LogsState {
  const _$LogsStateImpl(
      {final List<LogEntry> logs = const [],
      this.isLoading = false,
      this.errorMessage})
      : _logs = logs;

  final List<LogEntry> _logs;
  @override
  @JsonKey()
  List<LogEntry> get logs {
    if (_logs is EqualUnmodifiableListView) return _logs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_logs);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'LogsState(logs: $logs, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogsStateImpl &&
            const DeepCollectionEquality().equals(other._logs, _logs) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_logs), isLoading, errorMessage);

  /// Create a copy of LogsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LogsStateImplCopyWith<_$LogsStateImpl> get copyWith =>
      __$$LogsStateImplCopyWithImpl<_$LogsStateImpl>(this, _$identity);
}

abstract class _LogsState implements LogsState {
  const factory _LogsState(
      {final List<LogEntry> logs,
      final bool isLoading,
      final String? errorMessage}) = _$LogsStateImpl;

  @override
  List<LogEntry> get logs;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;

  /// Create a copy of LogsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LogsStateImplCopyWith<_$LogsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
