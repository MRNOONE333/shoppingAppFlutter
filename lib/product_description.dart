import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductDescriptionPage extends StatefulWidget {
  final dynamic product;
  final Function(dynamic) addToCart;
  final Function(dynamic) removeFromCart;

  ProductDescriptionPage({
    required this.product,
    required this.addToCart,
    required this.removeFromCart,
  });

  @override
  _ProductDescriptionPageState createState() => _ProductDescriptionPageState();
}

class _ProductDescriptionPageState extends State<ProductDescriptionPage> {
  String? description;
  bool addedToCart = false;

  List<dynamic> cartItems = [];

  @override
  void initState() {
    super.initState();
    fetchProductDescription();
  }

  Future<void> fetchProductDescription() async {
    try {
      final response = await http.get(
          Uri.parse('https://fakestoreapi.com/products/${widget.product['id']}'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          description = data['description'];
        });
      } else {
        throw Exception('Failed to fetch product description');
      }
    } catch (error) {
      setState(() {
        description = 'Failed to fetch description';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.network(
                widget.product['image'],
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 15),
            Text(
              widget.product['title'],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (int i = 0; i < widget.product['rating']['rate']; i++)
                  Icon(Icons.star, color: Colors.yellow),
                SizedBox(width: 5),
                Text(
                  '${widget.product['rating']['rate']} (${widget.product['rating']['count']} ratings)',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 15),
            Divider(color: Colors.grey),
            SizedBox(height: 15),
            Text(
              'Price: \$${widget.product['price']}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Text(
              'About the product',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            if (description != null)
              Text(
                description!,
                style: TextStyle(fontSize: 16),
              ),
            if (description == null) CircularProgressIndicator(),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  addedToCart = !addedToCart;
                  if (addedToCart) {
                    widget.addToCart(widget.product);
                  } else {
                    widget.removeFromCart(widget.product);
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                primary: addedToCart ? Colors.orange : Color(0xFF1A466A),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                addedToCart ? 'Remove from Cart' : 'Add to Cart',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
