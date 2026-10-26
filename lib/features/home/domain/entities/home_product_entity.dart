import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_category_entity.dart';

class HomeProductEntity {
  final int id;
  final String title;
  final String slug;
  final int price;
  final String description;
  final HomeCategoryEntity category;
   List<String> images;

  HomeProductEntity({
    this.id = 0,
    this.title = '',
    this.slug = '',
    this.price = 0,
    this.description = '',
    HomeCategoryEntity? category,
    this.images = const [],
  }) : category = category ?? HomeCategoryEntity();
}
