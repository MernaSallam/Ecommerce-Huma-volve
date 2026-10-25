import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_category_entity.dart';

abstract class HomeRepository {
  Future<List<HOMECategoryEntity>> getCategories();
}