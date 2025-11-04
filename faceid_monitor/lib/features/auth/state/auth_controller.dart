import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final user = credential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'Usuário não encontrado.',
        );
      }

      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        userId: user.uid,
        userEmail: user.email ?? email,
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Erro ao fazer login. Verifique suas credenciais.';
      switch (e.code) {
        case 'invalid-email':
          message = 'Email inválido.';
          break;
        case 'user-disabled':
          message = 'Usuário desativado.';
          break;
        case 'user-not-found':
          message = 'Usuário não encontrado.';
          break;
        case 'wrong-password':
          message = 'Senha incorreta.';
          break;
        case 'too-many-requests':
          message = 'Muitas tentativas. Tente novamente mais tarde.';
          break;
      }
      state = state.copyWith(
        isLoading: false,
        errorMessage: message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao fazer login. Verifique suas credenciais.',
      );
    }
  }

  /// Envia email de redefinição de senha
  Future<bool> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      state = state.copyWith(isLoading: false);
      return true;
    } on FirebaseAuthException catch (e) {
      String message = 'Erro ao enviar email de recuperação.';
      switch (e.code) {
        case 'invalid-email':
          message = 'Email inválido.';
          break;
        case 'user-not-found':
          message = 'Usuário não encontrado.';
          break;
        case 'missing-email':
          message = 'Informe um e-mail válido.';
          break;
      }
      state = state.copyWith(isLoading: false, errorMessage: message);
      return false;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao enviar email de recuperação.',
      );
      return false;
    }
  }

  /// Login com Google
  Future<void> loginWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      User? user;

      if (kIsWeb) {
        final provider = GoogleAuthProvider();
        provider.setCustomParameters({'prompt': 'select_account'});
        final credential = await FirebaseAuth.instance.signInWithPopup(provider);
        user = credential.user;
      } else {
        final googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          // Usuário cancelou
          state = state.copyWith(isLoading: false);
          return;
        }
        final googleAuth = await googleUser.authentication;
        final authCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final cred =
            await FirebaseAuth.instance.signInWithCredential(authCredential);
        user = cred.user;
      }

      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-null',
          message: 'Falha no login com Google.',
        );
      }

      // After Google sign-in, check if profile exists and if password provider is linked
      final firestore = FirebaseFirestore.instance;
      final doc = await firestore.collection('users').doc(user.uid).get();
      // Avoid deprecated email enumeration API; inspect linked providers instead
      final hasPasswordProvider =
          (user.providerData).any((p) => p.providerId == 'password');

      final hasProfile = doc.exists &&
          (doc.data()?['firstName'] ?? '').toString().isNotEmpty &&
          (doc.data()?['lastName'] ?? '').toString().isNotEmpty;

      if (hasProfile && hasPasswordProvider) {
        state = state.copyWith(
          isAuthenticated: true,
          isLoading: false,
          userId: user.uid,
          userEmail: user.email,
        );
      } else {
        // Signal UI to route to registration page with prefilled email
        state = state.copyWith(
          isAuthenticated: false,
          isLoading: false,
          userId: user.uid,
          userEmail: user.email,
          errorMessage: '__NEEDS_PROFILE_SETUP__',
        );
      }
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message ?? 'Erro ao fazer login com Google.',
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao fazer login com Google.',
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await FirebaseAuth.instance.signOut();
      if (!kIsWeb) {
        // Tenta encerrar sessão do Google localmente
        final google = GoogleSignIn();
        try {
          if (await google.isSignedIn()) {
            await google.signOut();
          }
        } catch (_) {}
      }

      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao fazer logout.',
      );
    }
  }

  void checkAuthStatus() {
    final user = FirebaseAuth.instance.currentUser;

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
