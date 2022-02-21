import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waterpoj/model/product.dart';
import 'package:waterpoj/provider/cart_provider.dart';
import 'package:waterpoj/view/ui/login_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) =>
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: ListView.builder(
        itemCount: _provider.getcart().length,
        itemBuilder: (_, i) {
          return ListTile(
            leading: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _provider.increaseCartValue(i);
              },
            ),
            trailing: IconButton(
              icon: Icon(Icons.minimize),
              onPressed: () {
                _provider.dicrimentCartValue(i);
              },
            ),
            title: Text(_provider.getcart()[i].name),
            subtitle: Text("Quantity,: ${_provider.getcart()[i].quantity}"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _provider.addCart(
                Product(id: 1, name: "shubha", price: 45, quantity: 1));
          },
          child: Icon(Icons.add)),
    );
  }
}
