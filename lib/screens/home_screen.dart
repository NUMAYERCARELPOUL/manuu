import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled13/screens/drawer.dart';
import 'package:untitled13/screens/tab_view/salad.dart';
import '../model/cartmodel.dart';
import 'cart.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> selectedProducts = [];

  // ... Rest of your code ...
  // Simulated data (replace with your actual data)
  final List<Map<String, dynamic>> dishData = [
    {
      'title': 'Dish Title 1',
      'price': 'SAR 7.95',
      'calories': '15 calories',
      'additionalText': 'Additional Information: Some additional text here',
      'imageUrls': [
        'https://www.gimmesomeoven.com/wp-content/uploads/2016/09/Apple-Spinach-Recipe-3.jpg',
      ],
      'count': 0,
    },
    {
      'title': 'Dish Title 2',
      'price': 'SAR 9.95',
      'calories': '20 calories',
      'additionalText': 'Additional Information: Some additional text here',
      'imageUrls': [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRorzJTp6aMNeLR0JX2M_VEBwPcliuzNM7Xzg&usqp=CAU',
      ],
      'count': 0,
    },
    // Add more dish data as needed
  ];
  void _addToCart(BuildContext context, Map<String, dynamic> product) {
    final cart = Provider.of<CartModel>(context, listen: false);

    setState(() {
      product['count']++;
      if (!selectedProducts.contains(product)) {
        selectedProducts.add(product);
      }
    });

    // Add the product to the cart using the Provider
    cart.addToCart(product);

    // Show a snackbar to confirm the item was added to the cart
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['title']} added to cart'),
        duration: Duration(seconds: 2),
      ),
    );
  }


  final List<Color> leadingIconColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];
  Future<void> fetchDataWithParameters() async {
    // Define your parameters here
    final Map<String, String> parameters = {
      'param1': 'value1',
      'param2': 'value2',
      // Add more parameters as needed
    };

    // Construct the URL with query parameters
    final Uri uri = Uri.https(
      'www.example.com', // Replace with your API base URL
      '/endpoint',        // Replace with your API endpoint
      parameters,
    );

    try {
      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        // Parse the JSON response here
        final jsonData = json.decode(response.body);
        // Process and use the data as needed
      } else {
        // Handle errors, such as network issues or invalid response
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle exceptions (e.g., network errors)
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          // ... Your other app bar properties ...
          actions: [
            Stack(
              children: [
                Consumer<CartModel>(
                  builder: (context, cart, child) {
                    return IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen()));
                      },
                    );
                  },
                ),
                Positioned(
                  right: 5, // Adjust the position as needed
                  top: 5, // Adjust the position as needed
                  child: Consumer<CartModel>(
                    builder: (context, cart, child) {
                      return Container(
                        padding: EdgeInsets.all(6), // Adjust the padding as needed
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red, // Customize the color as needed
                        ),
                        child: Text(
                          cart.cartCount.toString(), // Display the cart count from the Provider
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

          ],
        ),
        drawer: MyDrawer(),
        body: TabBarView(
          children: [
        ListView.builder(
          itemCount: jsonModel.tableMenuList.length,
          itemBuilder: (BuildContext context, int index) {
            final dish = dishData[index];
            final List<String> imageUrls = List<String>.from(dish['imageUrls']);
            final leadingIconColor = leadingIconColors[index % leadingIconColors.length];
            final tableMenu = jsonModel.tableMenuList[index];

            return Column(
              children: [
                ListTile(
                  onTap: () {
                    _addToCart(context, dish);
                  },
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tableMenu.menuCategory,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(dish['price']),
                          Text(dish['calories']),
                        ],
                      ),
                      Text(
                        dish['additionalText'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150,
                        height: 40,
                        margin: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.green,
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
                                  if (dish['count'] > 0) {
                                    dish['count']--;
                                  }
                                });
                              },
                            ),
                            Text(
                              dish['count'].toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              color: Colors.white,
                              onPressed: () {
                                // Handle addition
                                setState(() {
                                  dish['count']++;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  trailing: SizedBox(
                    width: 100,
                    height: 100,
                    // Adjust the width as needed
                    child: ListView.builder(
                      itemCount: imageUrls.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int imageIndex) {
                        return Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Image.network(
                            imageUrls[imageIndex],
                            width: 70,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  leading: CircleAvatar(
                    radius: 7,
                    backgroundColor: leadingIconColor,
                    child: Icon(
                      Icons.adjust_rounded,
                      size: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
                Divider(), // Add a Divider between ListTiles
              ],
            );
          },
        )
          ],
        ),

      ),
    );
  }
}
