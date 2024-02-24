import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ricoz_flutter_assignment/views/Screen/product%20list/provider/product_provider.dart';
import 'package:ricoz_flutter_assignment/views/Screen/product%20list/product_detail.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late List<Product> products;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://dummyjson.com/products'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final productList = jsonData['products'] as List<dynamic>;
      setState(() {
        products = productList.map((json) => Product.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Products',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                fontFamily: 'Lato',
              ),
            ),
            Text(
              'Super summer sale',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                fontFamily: 'Lato',
              ),
            ),
          ],
        ),
      ),
      body: products != null
          ? ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                double originalPrice = products[index].price;
                double discountPercentage = products[index].discountPercentage;

                double discountedPrice = originalPrice -
                    (originalPrice * (discountPercentage / 100));
                final product = products[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                            product: product,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.14,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                height: double.infinity,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.fill,
                                    imageUrl: product.thumbnail,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ),
                              if (discountPercentage > 0)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Positioned(
                                    top: 0,
                                    left: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:  BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: Text(
                                        '-${products[index].discountPercentage.toStringAsFixed(0)}%',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Lato',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ]),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(1, 22, 16, 0),
                                child: Container(
                                  height: double.infinity,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          _buildRatingStars(product.rating),
                                          Text(
                                            '\(${products[index].rating.toString()})',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Color(0xff9B9B9B),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Lato',
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        product.brand,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xff9B9B9B),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Lato',
                                        ),
                                      ),
                                      Text(
                                        product.title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff000000),
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'Lato',
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            '\₹${products[index].price.toString()}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff9B9B9B),
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Lato',
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            '\₹${discountedPrice.toStringAsFixed(0)}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xffDB3022),
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Lato',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

Widget _buildRatingStars(double rating) {
  return Row(
    children: List.generate(
      5,
      (index) => Icon(
        index < rating.floor() ? Icons.star : Icons.star_border,
        color: Colors.amber,
      ),
    ),
  );
}
