import 'package:ecommerce_app_huma_volve/core/constants/product_link.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_product_entity.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareProductButton extends StatelessWidget {
  final HomeProductEntity product;

  const ShareProductButton({super.key, required this.product});

  Future<void> _shareProduct(BuildContext context) async {
    final link = ProductLink.forProduct(product.id);
    final shareText =
        'Check out ${product.title} for \$${product.price}!\n$link';

    try {
      await SharePlus.instance.share(ShareParams(text: shareText));
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not share this product: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Share product',
      onPressed: () => _shareProduct(context),
      icon: const Icon(Icons.share_outlined),
    );
  }
}
