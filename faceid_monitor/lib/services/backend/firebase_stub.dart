import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import '../../firebase_options.dart' as options;

/// Firebase facade (real implementation)
class FirebaseStub {
  static bool _initialized = false;

  /// Initializes Firebase once, using DefaultFirebaseOptions when needed.
  static Future<void> initialize() async {
    if (_initialized) return;

    if (Firebase.apps.isEmpty) {
      if (kIsWeb) {
        await Firebase.initializeApp(
          options: options.DefaultFirebaseOptions.currentPlatform,
        );
      } else {
        await Firebase.initializeApp();
      }
    }

    _initialized = true;
  }

  /// Whether Firebase was initialized by this facade
  static bool get isInitialized => _initialized || Firebase.apps.isNotEmpty;

  /// Firestore access
  static FirestoreStub get firestore => FirestoreStub(FirebaseFirestore.instance);

  /// Auth access
  static AuthStub get auth => AuthStub(fb_auth.FirebaseAuth.instance);
}

/// Firestore facade
class FirestoreStub {
  final FirebaseFirestore _firestore;
  FirestoreStub(this._firestore);

  CollectionStub collection(String path) =>
      CollectionStub(_firestore.collection(path));
}

/// Firestore collection facade
class CollectionStub {
  final CollectionReference<Map<String, dynamic>> _collection;
  CollectionStub(this._collection);

  Future<String> add(Map<String, dynamic> data) async {
    final ref = await _collection.add(data);
    return ref.id;
  }

  Future<List<Map<String, dynamic>>> get() async {
    final snap = await _collection.get();
    return snap.docs.map((d) => d.data()).toList(growable: false);
  }

  DocumentStub doc(String id) => DocumentStub(_collection.doc(id));
}

/// Firestore document facade
class DocumentStub {
  final DocumentReference<Map<String, dynamic>> _doc;
  DocumentStub(this._doc);

  Future<void> update(Map<String, dynamic> data) => _doc.update(data);

  Future<void> delete() => _doc.delete();

  Future<Map<String, dynamic>?> get() async {
    final snap = await _doc.get();
    return snap.data();
  }
}

/// Firebase Auth facade
class AuthStub {
  final fb_auth.FirebaseAuth _auth;
  AuthStub(this._auth);

  UserStub? get currentUser =>
      _auth.currentUser != null ? UserStub(_auth.currentUser!) : null;

  Future<UserStub> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return UserStub(cred.user!);
  }

  Future<void> signOut() => _auth.signOut();
}

/// Firebase Auth user facade
class UserStub {
  final fb_auth.User _user;
  UserStub(this._user);

  String get uid => _user.uid;
  String? get email => _user.email;
  String? get displayName => _user.displayName;
}
