import 'package:flutter/material.dart';
import 'package:ricoz_flutter_assignment/views/Screen/product%20list/product_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProductList(),
      debugShowCheckedModeBanner: false,
    );
  }
}
