import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/core/constants/product_link.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/home_remote_datasource.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/home_remote_datasource_imp.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/repository/home_repository_imp.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repository/home_repository.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/user_cases/get_categories_usecase.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/user_cases/get_product_by_id_usecase.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/user_cases/get_products_usecase.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/view_model/cubit/home_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/details/presentation/screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme.dart';
import '../../home/presentation/view/screens/home_screen.dart';
import '../../cart/screens/cart_screen.dart';
import '../../profile/screens/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  late final ApiClient apiClient;
  late final HomeRemoteDataSource homeRemoteDataSource;
  late final HomeRepository homeRepository;
  late final GetCategoriesUseCase getCategoriesUseCase;
  late final GetProductsUseCase getProductsUseCase;
  late final GetProductByIdUseCase getProductByIdUseCase;
  late final HomeCubit homeCubit;
  late final AppLinks appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  int _linkRequestGeneration = 0;

  @override
  initState() {
    super.initState();
    apiClient = ApiClient();
    homeRemoteDataSource = HomeRemoteDataSourceImp(apiClient);
    homeRepository = HomeRepositoryImp(homeRemoteDataSource);
    getCategoriesUseCase = GetCategoriesUseCase(homeRepository);
    getProductsUseCase = GetProductsUseCase(homeRepository);
    getProductByIdUseCase = GetProductByIdUseCase(homeRepository);
    homeCubit = HomeCubit(
      getProductsUseCase: getProductsUseCase,
      getCategoriesUseCase: getCategoriesUseCase,
    );
    _initializeDeepLinks();
  }

  Future<void> _initializeDeepLinks() async {
    appLinks = AppLinks();
    _linkSubscription = appLinks.uriLinkStream.listen(
      _handleIncomingLink,
      onError: (Object error) {
        debugPrint('Product deep-link stream failed: $error');
      },
    );

    final initialLink = await appLinks.getInitialLink();
    if (initialLink != null) {
      await _handleIncomingLink(initialLink);
    }
  }

  Future<void> _handleIncomingLink(Uri uri) async {
    if (uri.scheme != ProductLink.scheme ||
        uri.host != ProductLink.productHost ||
        uri.pathSegments.length != 1) {
      return;
    }

    final productId = int.tryParse(uri.pathSegments.single);
    if (productId == null) return;

    final requestGeneration = ++_linkRequestGeneration;
    final result = await getProductByIdUseCase.invoke(productId);
    if (!mounted || requestGeneration != _linkRequestGeneration) return;

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not open shared product: ${failure.failureMessage}',
            ),
          ),
        );
      },
      (product) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    homeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      BlocProvider.value(value: homeCubit, child: const HomeScreen()),
      const CartScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: Colors.white,
            selectedItemColor: AppTheme.primary,
            unselectedItemColor: Colors.grey.shade400,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Icon(Icons.home_filled, size: 28),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Icon(Icons.home_filled, size: 32),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Icon(Icons.shopping_cart_outlined, size: 28),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Icon(Icons.shopping_cart, size: 32),
                ),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Icon(Icons.person_outline, size: 28),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Icon(Icons.person, size: 32),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
