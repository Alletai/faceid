import 'package:flutter/material.dart';

class KSpacer {
  // Vertical spacers
  static const SizedBox v4 = SizedBox(height: 4);
  static const SizedBox v8 = SizedBox(height: 8);
  static const SizedBox v12 = SizedBox(height: 12);
  static const SizedBox v16 = SizedBox(height: 16);
  static const SizedBox v24 = SizedBox(height: 24);
  static const SizedBox v32 = SizedBox(height: 32);
  static const SizedBox v48 = SizedBox(height: 48);
  
  // Horizontal spacers
  static const SizedBox h4 = SizedBox(width: 4);
  static const SizedBox h8 = SizedBox(width: 8);
  static const SizedBox h12 = SizedBox(width: 12);
  static const SizedBox h16 = SizedBox(width: 16);
  static const SizedBox h24 = SizedBox(width: 24);
  static const SizedBox h32 = SizedBox(width: 32);
  static const SizedBox h48 = SizedBox(width: 48);
}

/// Padding constante
class KPadding {
  static const EdgeInsets a4 = EdgeInsets.all(4);
  static const EdgeInsets a8 = EdgeInsets.all(8);
  static const EdgeInsets a12 = EdgeInsets.all(12);
  static const EdgeInsets a16 = EdgeInsets.all(16);
  static const EdgeInsets a24 = EdgeInsets.all(24);
  static const EdgeInsets a32 = EdgeInsets.all(32);
  
  static const EdgeInsets h8 = EdgeInsets.symmetric(horizontal: 8);
  static const EdgeInsets h16 = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets h24 = EdgeInsets.symmetric(horizontal: 24);
  
  static const EdgeInsets v8 = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsets v16 = EdgeInsets.symmetric(vertical: 16);
  static const EdgeInsets v24 = EdgeInsets.symmetric(vertical: 24);
}
