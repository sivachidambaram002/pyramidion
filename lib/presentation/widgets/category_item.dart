// lib/presentation/widgets/category_item.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/models/category_model.dart';
import '../../core/constants/app_constants.dart';

class CategoryItem extends StatefulWidget {
  final CategoryModel category;
  final double size;

  const CategoryItem({super.key, required this.category, required this.size});

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  bool _isSelected = false;

  void _showCategoryDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          widget.category.name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white, // ← force white color
            fontWeight: FontWeight.bold, // optional: makes it stand out more
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: widget.category.image,
                height: 160,
                width: 220,
                fit: BoxFit.cover,
                placeholder: (context, url) => const SizedBox(
                  height: 160,
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.broken_image,
                  size: 80,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'ID: ${widget.category.id}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
                fontFamily: 'monospace',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Category: ${widget.category.name} - Tap to view details',
      button: true,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isSelected = !_isSelected;
          });
          _showCategoryDetails();
        },
        child: Animate(
          effects: _isSelected
              ? [
                  ScaleEffect(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.12, 1.12),
                  ),
                  ShimmerEffect(
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeInOut,
                    color: Colors.white.withOpacity(0.25),
                  ),
                ]
              : [],
          child: Container(
            width: widget.size,
            height: widget.size, // square again – better proportions
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor,
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipOval(
              child: Column(
                children: [
                  Expanded(
                    flex: 10,
                    child: CachedNetworkImage(
                      imageUrl: widget.category.image,
                      width: widget.size,
                      height: widget.size,
                      fit: BoxFit.contain,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Text(
                          widget.category.name,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontSize: widget.size * 0.105,
                                fontWeight: FontWeight.w600,
                                height: 1.15,
                              ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
