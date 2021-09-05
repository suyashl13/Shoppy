import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/contexts/Cart.dart';
import 'package:shoppy/contexts/Order.dart';
import 'package:shoppy/contexts/Product.dart';
import 'package:shoppy/helpers/BackendCartsHelper.dart';
import 'package:shoppy/helpers/BackendProductsHelper.dart';
import 'package:shoppy/screens/cart/CartPage.dart';
import 'package:shoppy/screens/history/HistoryPage.dart';
import 'package:shoppy/screens/home/HomePage.dart';
import 'package:shoppy/screens/search/SearchPage.dart';
import 'package:shoppy/screens/shop/ShopPage.dart';
import 'package:shoppy/screens/static/ErrorPage.dart';

class ContainerPage extends StatefulWidget {
  @override
  _ContainerPageState createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  List<Widget> _screens = [
    HomePage(),
    ShopPage(),
    SearchPage(),
    HistoryPage(),
    CartPage(),
  ];

  int _activeIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setGlobals();
  }

  _setGlobals() async {
    await BackendProductsHelper().getAvailableProducts((data) {
      Provider.of<Product>(context, listen: false).setProducts(data);
    }, (err) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => ErrorPage()));
    });
    await BackendCartsHelper().getUserCarts((data) {
      Provider.of<Order>(context, listen: false).setOrders(data);
    }, (err) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => ErrorPage()));
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : IndexedStack(
                index: _activeIndex,
                children: _screens,
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 4,
        unselectedItemColor: Colors.black54,
        selectedItemColor: Colors.green,
        currentIndex: _activeIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              label: "Home", icon: Icon(Icons.home_outlined)),
          BottomNavigationBarItem(label: "Shop", icon: Icon(Icons.storefront)),
          BottomNavigationBarItem(label: "Search", icon: Icon(Icons.search)),
          BottomNavigationBarItem(label: "History", icon: Icon(Icons.history)),
          Provider.of<Cart>(context).getCartItems().length == 0
              ? BottomNavigationBarItem(
                  label: "Cart", icon: Icon(Icons.shopping_cart_outlined))
              : BottomNavigationBarItem(
                  icon: Stack(
                    children: <Widget>[
                      Icon(Icons.shopping_cart_outlined),
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 14,
                            minHeight: 12,
                          ),
                          child: Text(
                            '${Provider.of<Cart>(context).getCartItems().length}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                  label: "Cart"),
        ],
        onTap: (i) {
          setState(() {
            _activeIndex = i;
          });
        },
      ),
    );
  }
}
