import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/home/services/models/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/services/models/product_model.dart';

class HomeServices {
  final ApiClient apiClient;
  HomeServices(this.apiClient);

  Future<List<CategoryModel>> getCategories() async {
    // Implementation for fetching categories
    final response = await apiClient.dio.get(ApiEndpoints.categoriesEndpoint);
    final List data = response.data;
    final List<CategoryModel> categories = data
        .map((json) => CategoryModel.fromJson(json))
        .toList();
    return categories;
  }

  Future<List<ProductModel>> getProducts(int? categoryId) async {
    // Implementation for fetching products
    final response = await apiClient.dio.get(
      '${ApiEndpoints.categoriesEndpoint}/$categoryId/${ApiEndpoints.productsEndpoint}',
    );
    final List jsondata = response.data;
    final List<ProductModel> products = jsondata
        .map((json) => ProductModel.fromJson(json))
        .toList();
    return products;
  }
}
