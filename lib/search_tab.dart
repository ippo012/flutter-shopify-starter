import 'package:flutter/material.dart';
import 'package:flutter_simple_shopify/flutter_simple_shopify.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final _controller = TextEditingController(text: '');
  List<Product> products = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'Search...',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(),
                        ),
                        //fillColor: Colors.green
                      )),
                ),
                const Padding(padding: EdgeInsets.all(8)),
                IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => _searchForProduct(_controller.text)),
              ],
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: _buildProductList(),
                    ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _searchForProduct(String searchKeyword) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final shopifyStore = ShopifyStore.instance;
      final products = await shopifyStore.getXProductsOnQueryAfterCursor(
          null, 4, SortKeyProduct.RELEVANCE, searchKeyword);
      if (mounted) {
        setState(() {
          this.products = products;
          _isLoading = false;
        });
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      print(e);
    }
  }

  List<Widget> _buildProductList() {
    final widgetList = <Widget>[];
    // ignore: avoid_function_literals_in_foreach_calls
    products.forEach((product) => widgetList.add(ListTile(
          title: Text(product.title),
        )));
    return widgetList;
  }
}
