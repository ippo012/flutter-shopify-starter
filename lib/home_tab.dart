import 'package:flutter/material.dart';
import 'package:flutter_simple_shopify/flutter_simple_shopify.dart';
import 'product_detail_screen.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<Product> products = [];
  bool _isLoading = true;

  @override
  void initState() {
    _fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              size: 16,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.6,
                ),
                itemCount: products.length,
                itemBuilder: (_, int index) =>
                    _buildProductThumbnail(products[index]),
              ),
      ),
    );
  }

  Future<void> _fetchProducts() async {
    try {
      final shopifyStore = ShopifyStore.instance;
      final bestSellingProducts = await shopifyStore.getNProducts(false,
          n: 20, sortKey: SortKeyProduct.BEST_SELLING);
      if (mounted) {
        setState(() {
          products = bestSellingProducts;
          _isLoading = false;
        });
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      print(e);
    }
  }

  Widget _buildProductThumbnail(Product product) {
    final productVariants = product.productVariants;
    return InkWell(
      onTap: () => _navigateToProductDetailScreen(product),
      child: Container(
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: (MediaQuery.of(context).size.width - 48) / 2,
                decoration: product?.images?.first?.originalSource != null
                    ? BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              product.images.first.originalSource,
                            )))
                    : const BoxDecoration(),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  product.title,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.normal),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 4),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  // ignore: lines_longer_than_80_chars
                  '${product.productVariants.first.price.currencySymbol}${productVariants.first.price.amount.replaceFirst(".0", "")}',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )),
    );
  }

  void _navigateToProductDetailScreen(Product product) {
    Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (context) => ProductDetailScreen(
                  product: product,
                )));
  }
}
