import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'services/backend/firebase_stub.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // TODO: Configurar Firebase quando adicionar google-services.json / GoogleService-Info.plist
  // await Firebase.initializeApp();
  
  // Inicializar stubs do Firebase (mock)
  await FirebaseStub.initialize();
  
  runApp(
    const ProviderScope(
      child: CityLabSecurityApp(),
    ),
  );
}
