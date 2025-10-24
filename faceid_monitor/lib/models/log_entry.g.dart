// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LogEntryImpl _$$LogEntryImplFromJson(Map<String, dynamic> json) =>
    _$LogEntryImpl(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      title: json['title'] as String,
      description: json['description'] as String,
      status: $enumDecode(_$LogStatusEnumMap, json['status']),
      personId: json['personId'] as String?,
      personName: json['personName'] as String?,
    );

Map<String, dynamic> _$$LogEntryImplToJson(_$LogEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'title': instance.title,
      'description': instance.description,
      'status': _$LogStatusEnumMap[instance.status]!,
      'personId': instance.personId,
      'personName': instance.personName,
    };

const _$LogStatusEnumMap = {
  LogStatus.pending: 'pending',
  LogStatus.visualized: 'visualized',
  LogStatus.alert: 'alert',
  LogStatus.success: 'success',
};
