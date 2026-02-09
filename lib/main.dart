// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart'; // ← ADD THIS IMPORT (critical!)
import 'package:path_provider/path_provider.dart';

import 'core/theme/app_theme.dart';
import 'presentation/screens/home_categories_screen.dart';
import 'data/models/category_model.dart'; // for adapter

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive with Flutter extension
  await Hive.initFlutter(); // ← now works after correct import

  Hive.registerAdapter(CategoryModelAdapter());

  // Open box for categories
  await Hive.openBox<CategoryModel>('categories_box');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop by Categories',
      theme: AppTheme.lightTheme.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      darkTheme: AppTheme.darkTheme.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      themeMode: ThemeMode.system,
      home: const HomeCategoriesScreen(),
    );
  }
}
