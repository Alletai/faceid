// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recording.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecordingImpl _$$RecordingImplFromJson(Map<String, dynamic> json) =>
    _$RecordingImpl(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      cameraName: json['cameraName'] as String,
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      status: $enumDecode(_$RecordingStatusEnumMap, json['status']),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
    );

Map<String, dynamic> _$$RecordingImplToJson(_$RecordingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'cameraName': instance.cameraName,
      'duration': instance.duration.inMicroseconds,
      'status': _$RecordingStatusEnumMap[instance.status]!,
      'thumbnailUrl': instance.thumbnailUrl,
      'videoUrl': instance.videoUrl,
    };

const _$RecordingStatusEnumMap = {
  RecordingStatus.available: 'available',
  RecordingStatus.processing: 'processing',
  RecordingStatus.error: 'error',
};
