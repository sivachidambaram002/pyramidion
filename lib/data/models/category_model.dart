// lib/data/models/category_model.dart

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 0)
class CategoryModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String image;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.image,
  });

  /// Creates a [CategoryModel] from JSON map (used when parsing API response)
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
    );
  }

  /// Converts this [CategoryModel] back to JSON map (useful for debugging or future API sends)
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image': image};
  }

  @override
  List<Object?> get props => [id, name, image];

  @override
  bool get stringify => true; // Optional: makes debugPrint nicer
}
