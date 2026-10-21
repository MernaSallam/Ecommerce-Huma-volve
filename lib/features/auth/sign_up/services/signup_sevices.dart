import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/signup_model.dart';

class SignUpServices {
  ApiClient apiClient;
  SignUpServices(this.apiClient);
  signUp(SignUpReqModel signUpReqModel) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.users,
      data: {
        "email": signUpReqModel.email,
        "name": signUpReqModel.name,
        "password": signUpReqModel.password,
        "avatar": "https://cdn-icons-png.magnific.com/256/15329/15329351.png?semt=ais_white_label",
      },
    );
    return response;
  }
}
