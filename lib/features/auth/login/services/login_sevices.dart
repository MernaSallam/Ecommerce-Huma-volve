import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/core/storage/secure_storage.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/model/login_model.dart';

class LoginServices {
  ApiClient apiClient;
  LoginServices(this.apiClient);

  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.authLoginEndpoint,
      data: {'email': email, 'password': password},
    );
    final Map<String, dynamic> jsonData = response.data;
    final modelData = LoginModel.fromJson(jsonData);
    final accessToken = modelData.accessToken;
    if (accessToken == null) {
      throw StateError('Login response did not include an access token.');
    }
    final refreshToken = modelData.refreshToken;
    if (refreshToken == null) {
      throw StateError('Login response did not include a refresh token.');
    }
    SecureStorage.saveAccessToken(accessToken);
    SecureStorage.saveRefreshAccessToken(refreshToken);

    return modelData;
  }
}
