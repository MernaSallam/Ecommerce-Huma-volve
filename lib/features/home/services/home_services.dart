import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/product_model.dart';

class HomeServices {
  final ApiClient apiClient;
  HomeServices(this.apiClient);

  Future<List<HomeCategoryModel>> getCategories() async {
    // Implementation for fetching categories
    final response = await apiClient.dio.get(ApiEndpoints.categoriesEndpoint);
    final List data = response.data;
    final List<HomeCategoryModel> categories = data
        .map((json) => HomeCategoryModel.fromJson(json))
        .toList();
    return categories;
  }

  Future<List<HomeProductModel>> getProducts(int? categoryId) async {
    // Implementation for fetching products
    final response = await apiClient.dio.get(
      '${ApiEndpoints.categoriesEndpoint}/$categoryId/${ApiEndpoints.productsEndpoint}',
    );
    final List jsondata = response.data;
    final List<HomeProductModel> products = jsondata
        .map((json) => HomeProductModel.fromJson(json))
        .toList();
    return products;
  }
}
