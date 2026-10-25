import 'package:ecommerce_app_huma_volve/features/home/data/models/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_product_entity.dart';

class HomeProductModel extends HomeProductEntity {
  
  HomeProductModel({
    super.id,
    super.title,
    super.slug,
    super.price,
    super.description,
    required super.category,
    super.images,
  });

  HomeProductModel.fromJson(Map<String, dynamic> json)
      : super(
          id: json['id'],
          title: json['title'],
          slug: json['slug'],
          price: json['price'],
          description: json['description'],
          category: HomeCategoryModel.fromJson(
            json['category'] as Map<String, dynamic>,
          ),
          images: (json['images'] as List<dynamic>).cast<String>(),
        );
}
