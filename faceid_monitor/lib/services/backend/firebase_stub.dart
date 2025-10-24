import 'package:flutter/foundation.dart';

/// Stub do Firebase para desenvolvimento
/// TODO: Integrar Firebase real após configurar projeto
/// 1. Adicionar google-services.json (Android) em android/app/
/// 2. Adicionar GoogleService-Info.plist (iOS) em ios/Runner/
/// 3. Executar `flutterfire configure` para configurar
/// 4. Descomentar Firebase.initializeApp() no main.dart
class FirebaseStub {
  static bool _initialized = false;
  
  /// Inicializa stubs do Firebase
  static Future<void> initialize() async {
    if (_initialized) return;
    
    if (kDebugMode) {
      debugPrint('🔥 Firebase Stub: Initialized (mock mode)');
    }
    
    // Simular delay de inicialização
    await Future.delayed(const Duration(milliseconds: 500));
    
    _initialized = true;
  }
  
  /// Verifica se Firebase está inicializado
  static bool get isInitialized => _initialized;
  
  /// Mock: Referência ao Firestore
  static FirestoreStub get firestore => FirestoreStub();
  
  /// Mock: Autenticação
  static AuthStub get auth => AuthStub();
}

/// Stub do Firestore
class FirestoreStub {
  /// Mock: Coleção
  CollectionStub collection(String path) {
    return CollectionStub(path);
  }
}

/// Stub de coleção Firestore
class CollectionStub {
  final String path;
  
  CollectionStub(this.path);
  
  /// Mock: Adicionar documento
  Future<String> add(Map<String, dynamic> data) async {
    if (kDebugMode) {
      debugPrint('🔥 Firestore Mock: add($path) => $data');
    }
    await Future.delayed(const Duration(milliseconds: 200));
    return 'mock_doc_${DateTime.now().millisecondsSinceEpoch}';
  }
  
  /// Mock: Buscar documentos
  Future<List<Map<String, dynamic>>> get() async {
    if (kDebugMode) {
      debugPrint('🔥 Firestore Mock: get($path)');
    }
    await Future.delayed(const Duration(milliseconds: 300));
    return [];
  }
  
  /// Mock: Documento específico
  DocumentStub doc(String id) {
    return DocumentStub('$path/$id');
  }
}

/// Stub de documento Firestore
class DocumentStub {
  final String path;
  
  DocumentStub(this.path);
  
  /// Mock: Atualizar documento
  Future<void> update(Map<String, dynamic> data) async {
    if (kDebugMode) {
      debugPrint('🔥 Firestore Mock: update($path) => $data');
    }
    await Future.delayed(const Duration(milliseconds: 200));
  }
  
  /// Mock: Deletar documento
  Future<void> delete() async {
    if (kDebugMode) {
      debugPrint('🔥 Firestore Mock: delete($path)');
    }
    await Future.delayed(const Duration(milliseconds: 200));
  }
  
  /// Mock: Buscar documento
  Future<Map<String, dynamic>?> get() async {
    if (kDebugMode) {
      debugPrint('🔥 Firestore Mock: get($path)');
    }
    await Future.delayed(const Duration(milliseconds: 200));
    return null;
  }
}

/// Stub de autenticação Firebase
class AuthStub {
  String? _mockUserId;
  
  /// Mock: Usuário atual
  UserStub? get currentUser => _mockUserId != null ? UserStub(_mockUserId!) : null;
  
  /// Mock: Login
  Future<UserStub> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (kDebugMode) {
      debugPrint('🔥 Auth Mock: signIn($email)');
    }
    await Future.delayed(const Duration(seconds: 1));
    _mockUserId = 'mock_user_${DateTime.now().millisecondsSinceEpoch}';
    return UserStub(_mockUserId!);
  }
  
  /// Mock: Logout
  Future<void> signOut() async {
    if (kDebugMode) {
      debugPrint('🔥 Auth Mock: signOut()');
    }
    await Future.delayed(const Duration(milliseconds: 300));
    _mockUserId = null;
  }
}

/// Stub de usuário Firebase
class UserStub {
  final String uid;
  
  UserStub(this.uid);
  
  String get email => 'user@citylabsecurity.com';
  String get displayName => 'Usuário Mock';
}
