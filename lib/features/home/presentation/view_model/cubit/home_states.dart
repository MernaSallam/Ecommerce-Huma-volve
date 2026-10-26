import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_product_entity.dart';

abstract class HomeStates {}

class HomeInitial extends HomeStates {}

class CategoriesLoading extends HomeStates {}

class CategoriesSuccess extends HomeStates {
  final List<HomeCategoryEntity> categories;

  CategoriesSuccess(this.categories);
}

class CategoriesError extends HomeStates {
  final String errorMessage;

  CategoriesError(this.errorMessage);
}

//////////////////////////////////////////////////////////////

class ProductsLoading extends HomeStates {}

class ProductsSuccess extends HomeStates {
  final List<HomeProductEntity> products;

  ProductsSuccess(this.products);
}

class ProductsError extends HomeStates {
  final String errorMessage;

  ProductsError(this.errorMessage);
}

class ProductsLoadingMore extends HomeStates {
  final List<HomeProductEntity> products;

  ProductsLoadingMore(this.products);
}

class ProductsLoadingMoreSuccess extends HomeStates {
  final List<HomeProductEntity> products;

  ProductsLoadingMoreSuccess(this.products);
}

class ProductsLoadingMoreError extends HomeStates {
  final String errorMessage;
  final List<HomeProductEntity> products;

  ProductsLoadingMoreError(this.errorMessage, this.products);
}
