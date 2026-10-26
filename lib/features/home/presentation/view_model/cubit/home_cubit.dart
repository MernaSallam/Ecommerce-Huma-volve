import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_product_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/user_cases/get_categories_usecase.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/user_cases/get_products_usecase.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/view_model/cubit/home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;
  final int limit = 10;
  int offset = 0;
  bool isLoadingMore = false;
  bool hasMore = false;
  int? selectedCategory;
  int _requestGeneration = 0;

  final List<HomeProductEntity> _products = [];

  HomeCubit({
    required this.getProductsUseCase,
    required this.getCategoriesUseCase,
  }) : super(HomeInitial());

  Future<void> loadHomeData() async {
    _requestGeneration++;
    isLoadingMore = false;
    hasMore = false;
    selectedCategory = null;
    offset = 0;
    emit(CategoriesLoading());

    final categoriesResult = await getCategoriesUseCase.invoke();
    if (isClosed) return;

    final categories = categoriesResult.fold<List<HomeCategoryEntity>?>(
      (failure) {
        emit(CategoriesError(failure.failureMessage));
        return null;
      },
      (categories) {
        emit(CategoriesSuccess(categories));
        return categories;
      },
    );

    if (categories == null) return;
    if (categories.isEmpty) {
      _products.clear();
      emit(ProductsSuccess(const []));
      return;
    }

    await getProductsByCategoryId(categories.first.id);
  }

  Future<void> getProductsByCategoryId(int id) async {
    final generation = ++_requestGeneration;
    isLoadingMore = false;
    selectedCategory = id;
    offset = 0;
    hasMore = false;
    _products.clear();
    emit(ProductsLoading());

    final result = await getProductsUseCase.invoke(id, limit: limit, offset: 0);
    if (isClosed || generation != _requestGeneration) return;

    result.fold(
      (failure) {
        emit(ProductsError(failure.failureMessage));
      },
      (products) {
        _products.addAll(products);
        offset += products.length;
        hasMore = products.length == limit;
        emit(ProductsSuccess(List.unmodifiable(_products)));
      },
    );
  }

  Future<void> loadMoreProducts() async {
    final categoryId = selectedCategory;
    if (isLoadingMore || !hasMore || categoryId == null) return;

    isLoadingMore = true;
    final generation = _requestGeneration;
    emit(ProductsLoadingMore(List.unmodifiable(_products)));

    try {
      final result = await getProductsUseCase.invoke(
        categoryId,
        limit: limit,
        offset: offset,
      );
      if (isClosed || generation != _requestGeneration) return;

      result.fold(
        (failure) {
          emit(
            ProductsLoadingMoreError(
              failure.failureMessage,
              List.unmodifiable(_products),
            ),
          );
        },
        (newProducts) {
          _products.addAll(newProducts);
          offset += newProducts.length;
          hasMore = newProducts.length == limit;
          emit(ProductsLoadingMoreSuccess(List.unmodifiable(_products)));
        },
      );
    } finally {
      if (generation == _requestGeneration) {
        isLoadingMore = false;
      }
    }
  }
}
