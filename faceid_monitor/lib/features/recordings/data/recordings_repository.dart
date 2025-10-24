import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/recording.dart';

/// Repositório de gravações (mock)
class RecordingsRepository {
  /// Buscar gravações com paginação
  /// TODO: Integrar com API/Firebase
  Future<List<Recording>> fetchRecordings({
    required int page,
    required DateTime date,
    int pageSize = 10,
  }) async {
    // Simular delay de rede
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock de dados
    final recordings = <Recording>[];

    for (int i = 0; i < pageSize; i++) {
      final index = (page * pageSize) + i;
      
      // Simular fim da lista após 25 itens
      if (index >= 25) break;

      recordings.add(
        Recording(
          id: 'rec_$index',
          timestamp: date.subtract(Duration(hours: index)),
          cameraName: 'Câmera Principal',
          duration: Duration(minutes: 15 + (index % 30)),
          status: index % 3 == 0
              ? RecordingStatus.processing
              : RecordingStatus.available,
          thumbnailUrl: null,
          videoUrl: null,
        ),
      );
    }

    return recordings;
  }

  /// Buscar gravação específica
  Future<Recording?> getRecording(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // TODO: Buscar do backend/Firebase
    return Recording(
      id: id,
      timestamp: DateTime.now(),
      cameraName: 'Câmera Principal',
      duration: const Duration(minutes: 20),
      status: RecordingStatus.available,
    );
  }

  /// Deletar gravação
  Future<void> deleteRecording(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: Deletar do backend/Firebase
  }
}

/// Provider do repositório de gravações
final recordingsRepositoryProvider = Provider<RecordingsRepository>(
  (ref) => RecordingsRepository(),
);
