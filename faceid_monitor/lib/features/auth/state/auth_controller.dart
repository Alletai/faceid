import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../services/backend/firebase_stub.dart';

part 'auth_controller.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isAuthenticated,
    @Default(false) bool isLoading,
    String? userId,
    String? userEmail,
    String? errorMessage,
  }) = _AuthState;
}

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(const AuthState());

  /// Login com email e senha
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Simular delay de rede
      await Future.delayed(const Duration(seconds: 1));

      // Mock: aceitar qualquer email/senha para demonstração
      // TODO: Integrar com Firebase Auth real
      final user = await FirebaseStub.auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        userId: user.uid,
        userEmail: email,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao fazer login. Verifique suas credenciais.',
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await FirebaseStub.auth.signOut();

      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao fazer logout.',
      );
    }
  }

  void checkAuthStatus() {
    final user = FirebaseStub.auth.currentUser;

    if (user != null) {
      state = state.copyWith(
        isAuthenticated: true,
        userId: user.uid,
        userEmail: user.email,
      );
    }
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(),
);
