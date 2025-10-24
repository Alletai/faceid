import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../models/recording.dart';
import '../data/recordings_repository.dart';

part 'recordings_controller.freezed.dart';

/// Estado de gravações
@freezed
class RecordingsState with _$RecordingsState {
  const factory RecordingsState({
    @Default([]) List<Recording> recordings,
    required DateTime selectedDate,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _RecordingsState;

  factory RecordingsState.initial() => RecordingsState(
        selectedDate: DateTime.now(),
      );
}

class RecordingsController extends StateNotifier<RecordingsState> {
  final RecordingsRepository _repository;

  RecordingsController(this._repository) : super(RecordingsState.initial());

  Future<List<Recording>> fetchRecordings(int page) async {
    try {
      final recordings = await _repository.fetchRecordings(
        page: page,
        date: state.selectedDate,
      );
      return recordings;
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Erro ao carregar gravações: $e',
      );
      rethrow;
    }
  }

  /// Selecionar data
  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }
}

/// Provider do controller de gravações
final recordingsControllerProvider =
    StateNotifierProvider<RecordingsController, RecordingsState>(
  (ref) => RecordingsController(ref.watch(recordingsRepositoryProvider)),
);
