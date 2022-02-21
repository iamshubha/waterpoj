import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waterpoj/provider/cart_provider.dart';
import 'package:waterpoj/view/ui/home_page.dart';

import 'view/ui/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CartProvider())],
      builder: (context, snapshot) {
        return MyApp();
      }));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: FirebaseAuth.instance.currentUser.uid.isEmpty
      //     ? LoginPage()
      //     : HomePage(),
      home: StreamBuilder<User>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            return snapshot.data == null ? LoginPage() : HomePage();
          }),
    );
  }
}
