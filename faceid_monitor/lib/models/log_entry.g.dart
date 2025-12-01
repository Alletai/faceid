// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LogEntryImpl _$$LogEntryImplFromJson(Map<String, dynamic> json) =>
    _$LogEntryImpl(
      id: json['id'] as String,
      logsDate: DateTime.parse(json['logsDate'] as String),
      title: json['title'] as String,
      description: json['description'] as String,
      username: json['username'] as String?,
      usersId: json['usersId'] as String?,
      personId: json['personId'] as String?,
      personName: json['personName'] as String?,
    );

Map<String, dynamic> _$$LogEntryImplToJson(_$LogEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'logsDate': instance.logsDate.toIso8601String(),
      'title': instance.title,
      'description': instance.description,
      'username': instance.username,
      'usersId': instance.usersId,
      'personId': instance.personId,
      'personName': instance.personName,
    };
