import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<int> countList = [];
  bool regularDeliverySelected = true;

  double calculateDeliveryFee() {
    return regularDeliverySelected ? 40.0 : 0.0;
  }

  double calculateTotalAmount(List<dynamic> cartItems) {
    double deliveryFee = calculateDeliveryFee();
    double totalPrice = 0.0;

    for (int i = 0; i < cartItems.length; i++) {
      dynamic product = cartItems[i];
      dynamic price = product['price'];

      if (price is int) {
        totalPrice += (price.toDouble() * countList[i]);
      } else if (price is double) {
        totalPrice += (price * countList[i]);
      }
    }

    return totalPrice + deliveryFee;
  }


  @override
  Widget build(BuildContext context) {
    final List<dynamic> cartItems =
    ModalRoute.of(context)!.settings.arguments as List<dynamic>;



    if (countList.length != cartItems.length) {
      countList = List<int>.filled(cartItems.length, 1);
    }

    double deliveryFee = calculateDeliveryFee();
    double totalAmount = calculateTotalAmount(cartItems).toDouble();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final product = cartItems[index];

          return ListTile(
            leading: Image.network(
              product['image'],
              width: 80.0,
              height: 80.0,
              fit: BoxFit.cover,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    product['title'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: EdgeInsets.all(4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (countList[index] > 1) {
                              countList[index]--;
                            }
                          });
                        },
                        child: Icon(
                          Icons.remove,
                          color: Colors.black,
                          size: 16,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        countList[index].toString(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            countList[index]++;
                          });
                        },
                        child: Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            subtitle: Text(
              'Price: \$${product['price']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          );
        },
      ),
      bottomSheet: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select delivery type:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      regularDeliverySelected = true;
                    });
                  },
                  child: Container(
                    width: 24.0,
                    height: 24.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: regularDeliverySelected
                          ? Color(0xFF1A466A)
                          : Colors.transparent,
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check,
                        size: 16.0,
                        color: regularDeliverySelected
                            ? Colors.white
                            : Colors.transparent,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Text('Regular delivery',
                    style: TextStyle(color: Colors.black)),
                SizedBox(width: 176.0),
                Text('₹ 40.00',
                    style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      regularDeliverySelected = false;
                    });
                  },
                  child: Container(
                    width: 24.0,
                    height: 24.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: regularDeliverySelected
                          ? Colors.transparent
                          : Color(0xFF1A466A),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check,
                        size: 16.0,
                        color: regularDeliverySelected
                            ? Colors.transparent
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Text('Takeaway delivery',
                    style: TextStyle(color: Colors.black)),
                SizedBox(width: 160.0),
                Text('No fees',
                    style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Billing Information:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Items in Cart:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Product price:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  '\₹${calculateTotalAmount(cartItems).toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Delivery fees:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  '\₹${deliveryFee.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Divider(),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Grand Total:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '\₹${totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Continue payment',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      '\₹${totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // Continue button onPressed logic
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF1A466A), // Set the custom color
                  ),
                  child: Text('Continue'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
