import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final LogsDataSource _repository;
  final List<DocumentSnapshot> _pageCursors = [];
  Stream<List<LogEntry>>? _stream;
  StreamSubscription<List<LogEntry>>? _sub;

  LogsController(this._repository) : super(const LogsState());

  /// Buscar logs com paginação
  Future<List<LogEntry>> fetchLogs(int page) async {
    try {
      Future(() {
        state = state.copyWith(isLoading: true, errorMessage: null);
      });
      final startAfter = page == 0 ? null : _pageCursors.elementAt(page - 1);
      final result = await _repository.fetchLogsPage(
        startAfter: startAfter,
        pageSize: 10,
      );
      if (result.lastDoc != null) {
        if (_pageCursors.length <= page) {
          _pageCursors.add(result.lastDoc!);
        } else {
          _pageCursors[page] = result.lastDoc!;
        }
      }
      final merged = page == 0 ? result.items : [...state.logs, ...result.items];
      Future(() {
        state = state.copyWith(isLoading: false, logs: merged);
      });
      return result.items;
    } catch (e) {
      Future(() {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Erro ao carregar logs: $e',
        );
      });
      rethrow;
    }
  }

  /// Marcar log como visualizado
  Future<void> markAsViewed(String logId) async {
    try {
      await _repository.markAsViewed(logId);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Erro ao marcar log como visualizado: $e',
      );
    }
  }

  void startRealtime() {
    _sub?.cancel();
    _stream = _repository.watchLatestLogs(limit: 10);
    _sub = _stream!.listen((items) {
      Future(() {
        state = state.copyWith(logs: items);
      });
    }, onError: (e) {
      Future(() {
        state = state.copyWith(errorMessage: 'Erro no stream de logs: $e');
      });
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

/// Provider do controller de logs
final logsControllerProvider =
    StateNotifierProvider<LogsController, LogsState>(
  (ref) => LogsController(ref.watch(logsRepositoryProvider)),
);
