import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../data/repositories/category_repository.dart';
import '../../data/models/category_model.dart';
import '../../data/services/api_service.dart';
import 'package:dio/dio.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final apiService = ApiService(dio);
  final categoriesBox = Hive.box<CategoryModel>('categories_box');
  return CategoryRepositoryImpl(apiService, categoriesBox);
});

final categoryControllerProvider =
    AsyncNotifierProvider<CategoryController, List<CategoryModel>>(
      CategoryController.new,
    );

class CategoryController extends AsyncNotifier<List<CategoryModel>> {
  @override
  Future<List<CategoryModel>> build() async {
    final repo = ref.read(categoryRepositoryProvider);
    return repo.getCategories();
  }

  Future<void> retry() async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(categoryRepositoryProvider);
      final freshData = await repo.getCategories(forceRefresh: true);
      state = AsyncData(freshData);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  // Optional: refresh without showing loading (background refresh)
  Future<void> silentRefresh() async {
    try {
      final repo = ref.read(categoryRepositoryProvider);
      final fresh = await repo.getCategories(forceRefresh: true);
      state = AsyncData(fresh);
    } catch (_) {
      // silent fail – keep old data
    }
  }
}
