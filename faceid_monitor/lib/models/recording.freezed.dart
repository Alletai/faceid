// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recording.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Recording _$RecordingFromJson(Map<String, dynamic> json) {
  return _Recording.fromJson(json);
}

/// @nodoc
mixin _$Recording {
  String get id => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String get cameraName => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;
  RecordingStatus get status => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  String? get videoUrl => throw _privateConstructorUsedError;

  /// Serializes this Recording to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Recording
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecordingCopyWith<Recording> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordingCopyWith<$Res> {
  factory $RecordingCopyWith(Recording value, $Res Function(Recording) then) =
      _$RecordingCopyWithImpl<$Res, Recording>;
  @useResult
  $Res call(
      {String id,
      DateTime timestamp,
      String cameraName,
      Duration duration,
      RecordingStatus status,
      String? thumbnailUrl,
      String? videoUrl});
}

/// @nodoc
class _$RecordingCopyWithImpl<$Res, $Val extends Recording>
    implements $RecordingCopyWith<$Res> {
  _$RecordingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Recording
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestamp = null,
    Object? cameraName = null,
    Object? duration = null,
    Object? status = null,
    Object? thumbnailUrl = freezed,
    Object? videoUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cameraName: null == cameraName
          ? _value.cameraName
          : cameraName // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RecordingStatus,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecordingImplCopyWith<$Res>
    implements $RecordingCopyWith<$Res> {
  factory _$$RecordingImplCopyWith(
          _$RecordingImpl value, $Res Function(_$RecordingImpl) then) =
      __$$RecordingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime timestamp,
      String cameraName,
      Duration duration,
      RecordingStatus status,
      String? thumbnailUrl,
      String? videoUrl});
}

/// @nodoc
class __$$RecordingImplCopyWithImpl<$Res>
    extends _$RecordingCopyWithImpl<$Res, _$RecordingImpl>
    implements _$$RecordingImplCopyWith<$Res> {
  __$$RecordingImplCopyWithImpl(
      _$RecordingImpl _value, $Res Function(_$RecordingImpl) _then)
      : super(_value, _then);

  /// Create a copy of Recording
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestamp = null,
    Object? cameraName = null,
    Object? duration = null,
    Object? status = null,
    Object? thumbnailUrl = freezed,
    Object? videoUrl = freezed,
  }) {
    return _then(_$RecordingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cameraName: null == cameraName
          ? _value.cameraName
          : cameraName // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RecordingStatus,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecordingImpl implements _Recording {
  const _$RecordingImpl(
      {required this.id,
      required this.timestamp,
      required this.cameraName,
      required this.duration,
      required this.status,
      this.thumbnailUrl,
      this.videoUrl});

  factory _$RecordingImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecordingImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime timestamp;
  @override
  final String cameraName;
  @override
  final Duration duration;
  @override
  final RecordingStatus status;
  @override
  final String? thumbnailUrl;
  @override
  final String? videoUrl;

  @override
  String toString() {
    return 'Recording(id: $id, timestamp: $timestamp, cameraName: $cameraName, duration: $duration, status: $status, thumbnailUrl: $thumbnailUrl, videoUrl: $videoUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.cameraName, cameraName) ||
                other.cameraName == cameraName) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, timestamp, cameraName,
      duration, status, thumbnailUrl, videoUrl);

  /// Create a copy of Recording
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordingImplCopyWith<_$RecordingImpl> get copyWith =>
      __$$RecordingImplCopyWithImpl<_$RecordingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecordingImplToJson(
      this,
    );
  }
}

abstract class _Recording implements Recording {
  const factory _Recording(
      {required final String id,
      required final DateTime timestamp,
      required final String cameraName,
      required final Duration duration,
      required final RecordingStatus status,
      final String? thumbnailUrl,
      final String? videoUrl}) = _$RecordingImpl;

  factory _Recording.fromJson(Map<String, dynamic> json) =
      _$RecordingImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get timestamp;
  @override
  String get cameraName;
  @override
  Duration get duration;
  @override
  RecordingStatus get status;
  @override
  String? get thumbnailUrl;
  @override
  String? get videoUrl;

  /// Create a copy of Recording
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecordingImplCopyWith<_$RecordingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
