import 'package:ecommerce_app_huma_volve/features/home/presentation/view_model/cubit/home_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/view_model/cubit/home_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/dummy_data.dart';
import '../../../../../core/theme.dart';
import 'widgets/product_card.dart';
import 'widgets/category_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_onListener);
    context.read<HomeCubit>().loadHomeData();
  }

  void _onListener() {
    if (!scrollController.hasClients) return;

    final pixels = scrollController.position.pixels;
    final max = scrollController.position.maxScrollExtent;
    const trigger = 200.0;

    if (pixels >= max - trigger) {
      context.read<HomeCubit>().loadMoreProducts();
    }
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(_onListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.menu,
                            color: AppTheme.primary,
                          ),
                        ),
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                            dummyUser.profilePictureUrl,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Explore',
                      style: Theme.of(context).textTheme.displayLarge
                          ?.copyWith(fontSize: 36),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Best trendy collection!',
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search clothes...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.tune,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    BlocBuilder<HomeCubit, HomeStates>(
                      buildWhen: (previous, current) {
                        if (current is CategoriesLoading ||
                            current is CategoriesError ||
                            current is CategoriesSuccess) {
                          return true;
                        } else {
                          return false;
                        }
                      },
                      builder: (context, state) {
                        if (state is CategoriesLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is CategoriesError) {
                          return Center(
                            child: Text(
                              'Error loading categories: ${state.errorMessage}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        } else if (state is CategoriesSuccess) {
                          final categories = state.categories;
                          return SizedBox(
                            height: 44,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final category = categories[index];
                                return CategoryChip(
                                  label: category.name,
                                  isSelected: _selectedCategoryIndex == index,
                                  onTap: () {
                                    setState(() {
                                      _selectedCategoryIndex = index;
                                    });
                                    context
                                        .read<HomeCubit>()
                                        .getProductsByCategoryId(category.id);
                                  },
                                );
                              },
                            ),
                          );
                        } else {
                          return const Center(
                            child: Text(
                              'Something went wrong. Please try again later.',
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: BlocBuilder<HomeCubit, HomeStates>(
                buildWhen: (previous, current) {
                  return current is ProductsLoading ||
                      current is ProductsError ||
                      current is ProductsSuccess ||
                      current is ProductsLoadingMore ||
                      current is ProductsLoadingMoreSuccess ||
                      current is ProductsLoadingMoreError;
                },

                builder: (context, state) {
                  if (state is ProductsLoading) {
                    return const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state is ProductsError) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          'Error loading products: ${state.errorMessage}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }
                  if (state is ProductsSuccess ||
                      state is ProductsLoadingMore ||
                      state is ProductsLoadingMoreSuccess ||
                      state is ProductsLoadingMoreError) {
                    final products = switch (state) {
                      ProductsSuccess(:final products) => products,
                      ProductsLoadingMore(:final products) => products,
                      ProductsLoadingMoreSuccess(:final products) => products,
                      ProductsLoadingMoreError(:final products) => products,
                      _ => const [],
                    };

                    if (products.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(child: Text('No products available')),
                      );
                    }

                    final footer = switch (state) {
                      ProductsLoadingMore() => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      ProductsLoadingMoreError(:final errorMessage) => Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              'Could not load more products: $errorMessage',
                              textAlign: TextAlign.center,
                            ),
                            TextButton(
                              onPressed: () =>
                                  context.read<HomeCubit>().loadMoreProducts(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                      _ => null,
                    };

                    return SliverMainAxisGroup(
                      slivers: [
                        SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.7,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) =>
                                ProductCard(product: products[index]),
                            childCount: products.length,
                          ),
                        ),
                        if (footer != null) SliverToBoxAdapter(child: footer),
                      ],
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}
