import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_controller.freezed.dart';

/// Estado do dashboard
@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default('Câmera Principal') String cameraName,
    @Default(true) bool isCameraLive,
    @Default(30) int fps,
    @Default({}) Map<String, dynamic> stats,
    @Default(false) bool isLoading,
  }) = _DashboardState;
}

/// Controller do dashboard
class DashboardController extends StateNotifier<DashboardState> {
  DashboardController() : super(const DashboardState()) {
    _loadData();
  }

  /// Carregar dados do dashboard
  Future<void> _loadData() async {
    state = state.copyWith(isLoading: true);

    // Simular carregamento de dados
    await Future.delayed(const Duration(seconds: 1));

    // Mock de estatísticas
    state = state.copyWith(
      isLoading: false,
      stats: {
        'totalIds': 127,
        'accuracy': 94,
        'alerts': 3,
        'uptime': 18,
      },
    );
  }

  /// Atualizar dados
  Future<void> refresh() async {
    await _loadData();
  }

  /// Toggle status da câmera (para teste)
  void toggleCameraStatus() {
    state = state.copyWith(isCameraLive: !state.isCameraLive);
  }
}

/// Provider do controller do dashboard
final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, DashboardState>(
  (ref) => DashboardController(),
);
