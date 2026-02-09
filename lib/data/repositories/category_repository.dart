import 'package:hive/hive.dart';

import '../models/category_model.dart';
import '../services/api_service.dart';

abstract class CategoryRepository {
  Future<List<CategoryModel>> getCategories({bool forceRefresh = false});
}

class CategoryRepositoryImpl implements CategoryRepository {
  final ApiService _apiService;
  final Box<CategoryModel> _cacheBox;

  CategoryRepositoryImpl(this._apiService, this._cacheBox);

  @override
  Future<List<CategoryModel>> getCategories({bool forceRefresh = false}) async {
    // If force refresh → skip cache
    if (forceRefresh) {
      return _fetchAndCache();
    }

    // Return cache if available
    if (_cacheBox.isNotEmpty) {
      return _cacheBox.values.toList();
    }

    // No cache → fetch from network
    return _fetchAndCache();
  }

  Future<List<CategoryModel>> _fetchAndCache() async {
    try {
      final freshCategories = await _apiService.fetchCategories();

      // Save to Hive
      await _cacheBox.clear();
      await _cacheBox.addAll(freshCategories);

      return freshCategories;
    } catch (e) {
      // On network error: fallback to cache if exists
      if (_cacheBox.isNotEmpty) {
        return _cacheBox.values.toList();
      }
      rethrow;
    }
  }
}
