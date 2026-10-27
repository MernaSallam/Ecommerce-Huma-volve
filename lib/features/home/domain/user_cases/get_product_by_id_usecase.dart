import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/constants/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_product_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repository/home_repository.dart';

class GetProductByIdUseCase {
  final HomeRepository homeRepository;

  GetProductByIdUseCase(this.homeRepository);

  Future<Either<Failure, HomeProductEntity>> invoke(int productId) =>
      homeRepository.getProductById(productId);
}
