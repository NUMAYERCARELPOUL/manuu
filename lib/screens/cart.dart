import 'package:flutter/material.dart';
class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedProducts;

  const CheckoutScreen({required this.selectedProducts});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final List<Map<String, dynamic>> dishData = [];

  final List<Color> leadingIconColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  double get totalAmount {
    double total = 0.0;
    for (var dish in dishData) {
      total += dish['count'] * double.parse(dish['price'].replaceAll('INR ', ''));
    }
    return total;
  }

  int calculateSelectedDishesCount() {
    int count = 0;
    for (final dish in dishData) {
      if (dish['count'] > 0) {
        count++;
      }
    }
    return count;
  }

  List<Widget> buildSelectedDishesWidgets() {
    List<Widget> selectedDishesWidgets = [];

    for (final dish in dishData) {
      if (dish['count'] > 0) {
        selectedDishesWidgets.add(
          Padding(
            padding: EdgeInsets.only(right: 8.0), // Adjust spacing as needed
            child: Text(
              '${dish['title']} (${dish['count']}x)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        );
      }
    }

    return selectedDishesWidgets;
  }

  int calculateTotalDishItemsCount() {
    int totalCount = 0;
    for (final dish in dishData) {
      final countValue = dish['count'];
      if (countValue is int) {
        totalCount += countValue;
      } else if (countValue is double) {
        totalCount += countValue.toInt();
      } else if (countValue is String) {
        totalCount += int.tryParse(countValue) ?? 0;
      }
    }
    return totalCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Summary"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
        child: Expanded(
          child: Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50, // Adjust the height as needed
                    color: Colors.green[900], // Change the color to your desired one
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ' ${calculateSelectedDishesCount()} Dishes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "-",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '${calculateTotalDishItemsCount()} Items',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.selectedProducts.length, // Use widget.selectedProducts
                    itemBuilder: (BuildContext context, int index) {
                      final leadingIconColor =
                      leadingIconColors[index % leadingIconColors.length];
                      final product = widget.selectedProducts[index]; // Use widget.selectedProducts

                      return Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              radius: 7,
                              backgroundColor: leadingIconColor,
                              child: Icon(
                                Icons.adjust_rounded,
                                size: 10,
                                color: Colors.white,
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['title'], // Use product from widget.selectedProducts
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(product['price']), // Use product from widget.selectedProducts
                                    Text(product['calories']), // Use product from widget.selectedProducts
                                  ],
                                ),
                              ],
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 110,
                                  height: 40,
                                  margin: EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.green[900],
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        color: Colors.white,
                                        onPressed: () {
                                          // Handle subtraction
                                          setState(() {
                                            if (product['count'] > 0) {
                                              product['count']--;
                                            }
                                          });
                                        },
                                      ),
                                      Text(
                                        product['count'].toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        color: Colors.white,
                                        onPressed: () {
                                          // Handle addition
                                          setState(() {
                                            product['count']++;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(), // Add a Divider between ListTiles
                        ],
                      );
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    'INR ${totalAmount.toStringAsFixed(2)}', // Format the total amount
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.green[900]),
          onPressed: () {
            // Show a confirmation dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Order Confirmation'),
                  content: Text('Order successfully placed!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Clear selected products and navigate to the homepage
                        Navigator.of(context).pop(); // Close the dialog
                        Navigator.of(context).pop(); // Pop the checkout screen
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
          child: Text('Place Order', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
