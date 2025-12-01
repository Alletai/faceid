import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

part 'log_entry.freezed.dart';
part 'log_entry.g.dart';

@freezed
class LogEntry with _$LogEntry {
  const factory LogEntry({
    required String id,
    required DateTime logsDate,
    required String title,
    required String description,
    String? username,
    String? usersId,
    String? personId,
    String? personName,
  }) = _LogEntry;

  factory LogEntry.fromJson(Map<String, dynamic> json) => _$LogEntryFromJson(json);

  static LogEntry fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> doc, {
    String? username,
    String? usersId,
  }) {
    final data = doc.data();
    final rawDate = data['logsDate'];
    DateTime date;
    if (rawDate is Timestamp) {
      date = rawDate.toDate();
    } else if (rawDate is String) {
      date = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else {
      date = DateTime.now();
    }

    final rawDesc = data['description'] ?? data['info'] ?? '';
    final desc = rawDesc is String ? rawDesc : rawDesc.toString();
    final formattedDesc = desc.startsWith('Aluno não identificado - ')
        ? desc
        : 'Aluno não identificado - $desc';

    return LogEntry(
      id: doc.id,
      logsDate: date,
      title: 'Registros de alunos',
      description: formattedDesc,
      username: username,
      usersId: usersId,
    );
  }
}

extension LogEntryFormatting on LogEntry {
  String get logsDateFormatted {
    final local = logsDate.toLocal();
    final fmt = DateFormat("d 'de' MMMM 'de' y 'às' HH:mm:ss", 'pt_BR');
    final offsetHours = local.timeZoneOffset.inHours;
    final sign = offsetHours >= 0 ? '+' : '';
    return '${fmt.format(local)} UTC$sign$offsetHours';
  }
}

extension LogEntryCompat on LogEntry {
  DateTime get timestamp => logsDate;
}
