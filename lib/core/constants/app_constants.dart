// lib/core/constants/app_constants.dart
import 'package:flutter/material.dart';

class AppConstants {
  static const String apiUrl =
      'https://api.jsonbin.io/v3/b/68c1656c43b1c97be93db48e';
  static const double hubRadiusFactor = 0.14;
  static const double itemRadiusFactor = 0.11;
  static const double orbitRadiusFactor = 0.40;
  static const Duration animationDuration = Duration(milliseconds: 800);
  static const Curve animationCurve = Curves.easeOutBack;
}
