import 'dart:convert';
import 'package:api_project/product_description.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'cart_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => HomePage(),
        '/cart': (context) => CartPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = '';
  String selectedCategory = 'all';
  List<String> categories = [];
  List<dynamic>? products;
  List<dynamic> cartItems = [];

  Future<List<dynamic>?> fetchProducts() async {
    final response =
    await http.get(Uri.parse('https://fakestoreapi.com/products'));
    if (response.statusCode == 200) {
      List<dynamic> decodedResponse = jsonDecode(response.body);
      for (var product in decodedResponse) {
        product['addedToCart'] = false;
      }
      return decodedResponse;
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  Future<List<String>> fetchCategories() async {
    final response = await http
        .get(Uri.parse('https://fakestoreapi.com/products/categories'));
    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch categories');
    }
  }

  void fetchFilteredProducts() async {
    final response = await http.get(Uri.parse(
        'https://fakestoreapi.com/products/category/$selectedCategory'));
    if (response.statusCode == 200) {
      setState(() {
        products = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  void addToCart(dynamic product) {
    setState(() {
      product['addedToCart'] = true;
      cartItems.add(product);
    });
  }


  void removeFromCart(dynamic product) {
    setState(() {
      product['addedToCart'] = false;
      cartItems.remove(product);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCategories().then((value) {
      setState(() {
        categories = value;
      });
    });
    fetchProducts().then((value) {
      setState(() {
        products = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic>? filteredProducts = products;
    if (selectedCategory != 'all') {
      filteredProducts = products
          ?.where((product) => product['category'] == selectedCategory)
          .toList();
    }
    if (searchQuery.isNotEmpty) {
      filteredProducts = filteredProducts
          ?.where((product) =>
          product['title'].toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    filteredProducts ??= [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'API app',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/cart', arguments: cartItems);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
                bottom: Radius.circular(10),
              ),
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Color(0xFF7D7D7D)),
                hintText: 'Search',
                hintStyle: TextStyle(color: Color(0xFF7D7D7D)),
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.grey[200],
                    child: ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = categories[index];
                              fetchFilteredProducts();
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: selectedCategory == categories[index]
                                  ? Colors.orange[100]
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Image.asset(
                                  'assets/category_${index + 1}.png',
                                  width: 30,
                                  height: 30,
                                ),
                                SizedBox(height: 10),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    categories[index],
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: selectedCategory ==
                                          categories[index]
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio:
                      120 / 240, // Set the aspect ratio of the containers
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts?[index];
                      final addedToCart = product['addedToCart'] as bool?;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDescriptionPage(
                                product: product,
                                addToCart: addToCart,
                                removeFromCart: removeFromCart,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 120,
                          height: 240,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Image.network(
                                  product['image'],
                                  width: 240,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 4),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  product['title'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              SizedBox(height: 4),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  '\$${product['price']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  SizedBox(width: 4),
                                  Text(
                                    '${product['rating']['rate']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(Icons.star,
                                      size: 14, color: Colors.yellow),
                                  Text(
                                    ' ${product['rating']['count']} Rating',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      product['addedToCart'] =
                                      !(addedToCart ?? false);
                                      if (!(addedToCart ?? false)) {
                                        addToCart(product);
                                      } else {
                                        removeFromCart(product);
                                      }
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(50),
                                    primary: addedToCart ?? false
                                        ? Colors.orange
                                        : Color(0xFF1A466A),
                                  ),
                                  child: Text(
                                    addedToCart ?? false
                                        ? 'Remove product'
                                        : 'Add to Cart',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
