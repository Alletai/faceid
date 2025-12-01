import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider para alternar entre modo claro e escuro.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);
