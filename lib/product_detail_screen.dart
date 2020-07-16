import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_simple_shopify/flutter_simple_shopify.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  // ignore: sort_constructors_first
  const ProductDetailScreen({Key key, @required this.product})
      : super(key: key);
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState(product);
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final Product product;

  // ignore: sort_constructors_first
  _ProductDetailScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    final controller = PageController();
    final images = product.images
        .map((image) => Image.network(
              image.originalSource,
              fit: BoxFit.cover,
            ))
        .toList();
    final variant = product.productVariants.first;
    final price =
        // ignore: lines_longer_than_80_chars
        '${variant.price.currencySymbol}${variant.price.amount.replaceFirst(".0", "")}';
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        automaticallyImplyLeading: false,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 16,
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            child: PageView(
              controller: controller,
              children: images,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8),
            alignment: Alignment.bottomCenter,
            child: SmoothPageIndicator(
              controller: controller,
              count: images.length,
              effect: const SlideEffect(
                  spacing: 6,
                  radius: 6,
                  dotWidth: 6,
                  dotHeight: 6,
                  dotColor: Colors.black12,
                  activeDotColor: Colors.blue),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(product.title,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(
                  price,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Html(
                  data: product.descriptionHtml,
                  onLinkTap: (url) {
                    print(url);
                    // open url in a webview
                  },
                ),
                Text(product.handle)
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildProductVariants() {
    final widgetList = <Widget>[];
    product.productVariants.forEach((variant) => widgetList.add(ListTile(
          title: Text(variant.title),
          trailing: Text(variant.price.formattedPrice),
        )));
    return widgetList;
  }

  ///Adds a product variant to the checkout
  Future<void> _addProductToShoppingCart(ProductVariant variant) async {
    final shopifyCheckout = ShopifyCheckout.instance;
    final checkoutId = await shopifyCheckout.createCheckout();
    print(checkoutId);
    //Adds a product variant to a specific checkout id
    await shopifyCheckout.checkoutLineItemsReplace(checkoutId, [variant.id]);
  }
}
