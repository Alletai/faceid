import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/log_entry.dart';

/// Repositório de logs (mock)
class LogsRepository {
  /// Buscar logs com paginação
  /// TODO: Integrar com API/Firebase
  Future<List<LogEntry>> fetchLogs({
    required int page,
    int pageSize = 10,
  }) async {
    // Simular delay de rede
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock de dados
    final logs = <LogEntry>[];

    final now = DateTime.now();

    for (int i = 0; i < pageSize; i++) {
      final index = (page * pageSize) + i;
      
      // Simular fim da lista após 50 itens
      if (index >= 50) break;

      final day = now.subtract(Duration(days: index ~/ 5));
      final time = DateTime(
        day.year,
        day.month,
        day.day,
        8 + (index % 12),
        (index * 23) % 60,
        (index * 17) % 60,
      );

      logs.add(
        LogEntry(
          id: 'log_$index',
          timestamp: time,
          title: 'Logs - ${time.day.toString().padLeft(2, '0')}/${time.month.toString().padLeft(2, '0')}/${time.year}',
          description: _getRandomLogDescription(index),
          status: _getRandomStatus(index),
          personId: index % 2 == 0 ? 'person_$index' : null,
          personName: index % 2 == 0 ? 'Pessoa ${index + 1}' : null,
        ),
      );
    }

    return logs;
  }

  /// Marcar log como visualizado
  Future<void> markAsViewed(String logId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // TODO: Atualizar no backend/Firebase
  }

  String _getRandomLogDescription(int index) {
    final descriptions = [
      '00:${index.toString().padLeft(2, '0')} - Aluno N.Mateus, Identificado',
      '00:${(index + 1).toString().padLeft(2, '0')} - Não Aluno Identificado',
      '00:${(index + 2).toString().padLeft(2, '0')} - Sinal de alerta detectado',
      '00:${(index + 3).toString().padLeft(2, '0')} - Mantenhém suas origens fortes',
    ];
    
    return descriptions[index % descriptions.length];
  }

  LogStatus _getRandomStatus(int index) {
    final statuses = [
      LogStatus.pending,
      LogStatus.visualized,
      LogStatus.alert,
      LogStatus.success,
    ];
    
    return statuses[index % statuses.length];
  }
}

/// Provider do repositório de logs
final logsRepositoryProvider = Provider<LogsRepository>(
  (ref) => LogsRepository(),
);
