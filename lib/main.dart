import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_simple_shopify/flutter_simple_shopify.dart';
import 'collection_tab.dart';
import 'home_tab.dart';
import 'profile_tab.dart';
import 'search_tab.dart';

Future<void> main() async {
  await DotEnv().load('.env');
  ShopifyConfig.setConfig(
    DotEnv().env['STOREFRONT_API_ACCESS_TOKEN'],
    DotEnv().env['STORE_URL'],
    '2020-04',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopify Example',
      theme: ThemeData(primaryColor: Colors.redAccent),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final _tabs = [
    HomeTab(),
    CollectionTab(),
    SearchTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavigationBarItemClick,
        fixedColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.black,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text('Home')),
          const BottomNavigationBarItem(
              icon: Icon(Icons.category), title: Text('Collections')),
          const BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text('Search')),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Profile')),
        ],
      ),
    );
  }

  void _onNavigationBarItemClick(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
