class ProductLink {
  static const String scheme = 'ecommercehumavolve';
  static const String productHost = 'product';

  static Uri forProduct(int productId) =>
      Uri(scheme: scheme, host: productHost, pathSegments: ['$productId']);
}
