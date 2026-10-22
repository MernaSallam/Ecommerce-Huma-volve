import 'package:ecommerce_app_huma_volve/features/home/services/home_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerce_app_huma_volve/features/home/cubit/home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  final HomeServices homeServices;
  HomeCubit(this.homeServices) : super(HomeInitial());

  void loadhomeData() async {
    emit(CategoriesLoading());
    try {
      final categories = await homeServices.getCategories();
      emit(CategoriesSuccess(categories));
      final products = await homeServices.getProducts(categories.isNotEmpty ? categories[0].id : null);
      emit(ProductsSuccess(products));
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }
}
