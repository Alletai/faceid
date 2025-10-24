import 'package:freezed_annotation/freezed_annotation.dart';

part 'recording.freezed.dart';
part 'recording.g.dart';

/// Modelo de gravação
@freezed
class Recording with _$Recording {
  const factory Recording({
    required String id,
    required DateTime timestamp,
    required String cameraName,
    required Duration duration,
    required RecordingStatus status,
    String? thumbnailUrl,
    String? videoUrl,
  }) = _Recording;
  
  factory Recording.fromJson(Map<String, dynamic> json) => _$RecordingFromJson(json);
}

/// Status da gravação
enum RecordingStatus {
  available,
  processing,
  error,
}

extension RecordingStatusX on RecordingStatus {
  String get displayName {
    switch (this) {
      case RecordingStatus.available:
        return 'Disponível';
      case RecordingStatus.processing:
        return 'Processando';
      case RecordingStatus.error:
        return 'Erro';
    }
  }
}
