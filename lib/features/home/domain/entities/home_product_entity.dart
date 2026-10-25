import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_category_entity.dart';

class ProductEntity {
  final int id;
  final String title;
  final String slug;
  final int price;
  final String description;
  final HOMECategoryEntity category;
  final List<String> images;

  ProductEntity({
    this.id = 0,
    this.title = '',
    this.slug = '',
    this.price = 0,
    this.description = '',
    this.category= const HOMECategoryEntity(),
    this.images = const [],
  });
}
