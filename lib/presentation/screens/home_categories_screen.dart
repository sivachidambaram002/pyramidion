// lib/presentation/screens/home_categories_screen.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/category_controller.dart';
import '../widgets/category_item.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/category_model.dart';

class HomeCategoriesScreen extends ConsumerStatefulWidget {
  const HomeCategoriesScreen({super.key});

  @override
  ConsumerState<HomeCategoriesScreen> createState() =>
      _HomeCategoriesScreenState();
}

class _HomeCategoriesScreenState extends ConsumerState<HomeCategoriesScreen> {
  final GlobalKey _animationKey = GlobalKey();

  void _handleHomeTap() {
    ref.read(categoryControllerProvider.notifier).retry();
    setState(() {}); // triggers rebuild → animations restart
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryControllerProvider);

    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = MediaQuery.of(context).size;
              final shortestSide = math.min(size.width, size.height);
              final centerX = constraints.maxWidth / 2;
              final centerY = constraints.maxHeight / 2;
              final orbitRadius = shortestSide * AppConstants.orbitRadiusFactor;
              final hubSize = shortestSide * AppConstants.hubRadiusFactor * 2;

              return Stack(
                fit: StackFit.expand,
                key: _animationKey,
                children: [
                  // Top-left title
                  Positioned(
                    top: 24,
                    left: 24,
                    child: Animate(
                      effects: const [
                        FadeEffect(
                          duration: Duration(milliseconds: 900),
                          curve: Curves.easeOut,
                        ),
                        SlideEffect(
                          begin: Offset(-0.4, 0),
                          end: Offset.zero,
                          curve: Curves.easeOutCubic,
                          duration: Duration(milliseconds: 800),
                        ),
                      ],
                      child: Text(
                        'Shop by Categories',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.6,
                              shadows: const [
                                Shadow(
                                  blurRadius: 12,
                                  color: Colors.black54,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                      ),
                    ),
                  ),

                  categoriesAsync.when(
                    data: (categories) => Stack(
                      children: [
                        // Center Hub – clickable
                        Positioned(
                          left: centerX - hubSize / 2,
                          top: centerY - hubSize / 2,
                          child: GestureDetector(
                            onTap: _handleHomeTap,
                            child: Animate(
                              effects: [
                                ScaleEffect(
                                  duration: AppConstants.animationDuration,
                                  curve: AppConstants.animationCurve,
                                  begin: const Offset(0.5, 0.5),
                                  end: const Offset(1.0, 1.0),
                                ),
                              ],
                              child: Container(
                                width: hubSize,
                                height: hubSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: AppTheme.hubGradient,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).shadowColor,
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.home_rounded,
                                    color: Colors.white,
                                    size: 48,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Items – call the private method
                        ..._buildCategoryItems(
                          context,
                          categories,
                          centerX,
                          centerY,
                          orbitRadius,
                          shortestSide,
                        ),
                      ],
                    ),

                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),

                    error: (error, stack) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              size: 64,
                              color: Colors.redAccent.withOpacity(0.8),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Something went wrong',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$error',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white70),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () => ref
                                  .read(categoryControllerProvider.notifier)
                                  .retry(),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.accentColor,
                                foregroundColor: Colors.black87,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Private method – now correctly inside the State class
  List<Widget> _buildCategoryItems(
    BuildContext context,
    List<CategoryModel> categories,
    double centerX,
    double centerY,
    double orbitRadius,
    double shortestSide,
  ) {
    final totalItems = categories.length;
    final itemSize = shortestSide * AppConstants.itemRadiusFactor * 2;

    return List.generate(totalItems, (index) {
      final angle = (index * (2 * math.pi / totalItems)) + (math.pi / 2);
      final x = centerX + orbitRadius * math.cos(angle) - itemSize / 2;
      final y = centerY + orbitRadius * math.sin(angle) - itemSize / 2;

      final delay = Duration(milliseconds: 100 * index);

      return Positioned(
        left: x,
        top: y,
        child: Animate(
          effects: [
            FadeEffect(
              delay: delay,
              duration: AppConstants.animationDuration,
              begin: 0.0,
              end: 1.0,
            ),
            ScaleEffect(
              delay: delay,
              duration: AppConstants.animationDuration,
              curve: AppConstants.animationCurve,
              begin: const Offset(0.0, 0.0),
              end: const Offset(1.0, 1.0),
            ),
            MoveEffect(
              delay: delay,
              duration: AppConstants.animationDuration,
              curve: AppConstants.animationCurve,
              begin: Offset(
                -(x - centerX + itemSize / 2),
                -(y - centerY + itemSize / 2),
              ),
              end: const Offset(0.0, 0.0),
            ),
          ],
          child: CategoryItem(category: categories[index], size: itemSize),
        ),
      );
    });
  }
}
