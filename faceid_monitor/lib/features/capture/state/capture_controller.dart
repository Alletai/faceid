import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'capture_controller.freezed.dart';

/// Estado de captura
@freezed
class CaptureState with _$CaptureState {
  const factory CaptureState({
    @Default([]) List<String> capturedPhotos,
    @Default(false) bool isCapturing,
    @Default(true) bool isCameraActive,
  }) = _CaptureState;
}

/// Controller de captura
class CaptureController extends StateNotifier<CaptureState> {
  CaptureController() : super(const CaptureState());

  /// Capturar foto
  Future<void> capture() async {
    if (state.isCapturing) return;

    state = state.copyWith(isCapturing: true);

    // Simular captura
    await Future.delayed(const Duration(milliseconds: 300));

    // Adicionar foto mockada
    final photoId = 'photo_${DateTime.now().millisecondsSinceEpoch}';
    state = state.copyWith(
      capturedPhotos: [...state.capturedPhotos, photoId],
      isCapturing: false,
    );
  }

  /// Remover foto
  void removePhoto(String photoId) {
    state = state.copyWith(
      capturedPhotos: state.capturedPhotos.where((id) => id != photoId).toList(),
    );
  }

  /// Limpar todas as fotos
  void clear() {
    state = state.copyWith(capturedPhotos: []);
  }

  /// Salvar rascunho
  Future<void> saveDraft() async {
    // TODO: Salvar rascunho localmente ou no Firebase
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// Salvar todas as fotos
  Future<void> saveAll() async {
    // TODO: Upload para Firebase Storage
    await Future.delayed(const Duration(seconds: 1));
    
    // Limpar após salvar
    state = const CaptureState();
  }

  /// Toggle câmera
  void toggleCamera() {
    state = state.copyWith(isCameraActive: !state.isCameraActive);
  }
}

/// Provider do controller de captura
final captureControllerProvider =
    StateNotifierProvider<CaptureController, CaptureState>(
  (ref) => CaptureController(),
);
