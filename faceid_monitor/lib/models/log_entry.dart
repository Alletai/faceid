import 'package:freezed_annotation/freezed_annotation.dart';

part 'log_entry.freezed.dart';
part 'log_entry.g.dart';

/// Modelo de entrada de log
@freezed
class LogEntry with _$LogEntry {
  const factory LogEntry({
    required String id,
    required DateTime timestamp,
    required String title,
    required String description,
    required LogStatus status,
    String? personId,
    String? personName,
  }) = _LogEntry;
  
  factory LogEntry.fromJson(Map<String, dynamic> json) => _$LogEntryFromJson(json);
}

/// Status do log
enum LogStatus {
  pending,
  visualized,
  alert,
  success,
}

extension LogStatusX on LogStatus {
  String get displayName {
    switch (this) {
      case LogStatus.pending:
        return 'Clique para visualizar';
      case LogStatus.visualized:
        return 'Visualizado';
      case LogStatus.alert:
        return 'Alerta';
      case LogStatus.success:
        return 'Sucesso';
    }
  }
}
