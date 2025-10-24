import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../models/log_entry.dart';
import '../data/logs_repository.dart';

part 'logs_controller.freezed.dart';

/// Estado de logs
@freezed
class LogsState with _$LogsState {
  const factory LogsState({
    @Default([]) List<LogEntry> logs,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _LogsState;
}

/// Controller de logs
class LogsController extends StateNotifier<LogsState> {
  final LogsRepository _repository;

  LogsController(this._repository) : super(const LogsState());

  /// Buscar logs com paginação
  Future<List<LogEntry>> fetchLogs(int page) async {
    try {
      final logs = await _repository.fetchLogs(page: page);
      return logs;
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Erro ao carregar logs: $e',
      );
      rethrow;
    }
  }

  /// Marcar log como visualizado
  Future<void> markAsViewed(String logId) async {
    try {
      await _repository.markAsViewed(logId);
      // TODO: Atualizar estado local
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Erro ao marcar log como visualizado: $e',
      );
    }
  }
}

/// Provider do controller de logs
final logsControllerProvider =
    StateNotifierProvider<LogsController, LogsState>(
  (ref) => LogsController(ref.watch(logsRepositoryProvider)),
);
