import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:untitled13/screens/drawer.dart';
import '../model/cartmodel.dart';
import 'cart.dart';

class HomePage extends StatefulWidget {

  final List<Map<String, dynamic>> selectedProducts = [];


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> selectedProducts = [];

  List<Map<String, dynamic>> dishData = [];

  // Define the list of leading icon colors here
  final List<Color> leadingIconColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
  }

  Future<List<Map<String, dynamic>>> fetchDataFromAPI() async {
    final apiUrl = Uri.parse('https://www.mocky.io/v2/5dfccffc310000efc8d2c1ad');

    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData != null && jsonData is List) {
          return List<Map<String, dynamic>>.from(jsonData);
        } else {
          throw Exception('API response is not a valid JSON array');
        }
      } else {
        throw Exception('Failed to load data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      if (e is SocketException) {
        print('Error: No internet connection');
      } else if (e is TimeoutException) {
        print('Error: Request timed out');
      } else {
        print('Error: $e');
      }
      // Return an empty list or handle the error as needed.
      return [];
    }
  }

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

    // Check if any items are in the cart and navigate to CheckoutScreen
    if (cart.cartCount > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutScreen(selectedProducts: selectedProducts),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Stack(
              children: [
                Consumer<CartModel>(
                  builder: (context, cart, child) {
                    return IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen(selectedProducts: widget.selectedProducts)));
                      },
                    );
                  },
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: Consumer<CartModel>(
                    builder: (context, cart, child) {
                      return Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Text(
                          cart.cartCount.toString(),
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
          bottom: const TabBar(
            labelColor: Colors.red,
            indicatorColor: Colors.red,
            isScrollable: true,
            tabs: [
              Text("Salads and Soup"),
              Text("From The Barnyard"),
              Text("From The Barnyard")

            ],
          ),
        ),
        drawer: MyDrawer(),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchDataFromAPI(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a loading indicator
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              // Display an error message
              return Center(
                child: Text('Error fetching data: ${snapshot.error}'),
              );
            } else {
              // Data has been fetched, build the TabBarView
              return TabBarView(
                children: [
                  buildTab1Content(snapshot.data ?? []), // Pass the data to buildTab1Content
                  buildTab2Content(),
                  buildTab3Content(),
                ],
              );
            }
          },
        )

      ),
    );
  }
  Widget buildTab1Content(List<Map<String, dynamic>> data) {
    if (dishData.isEmpty) {
      // Display a loading indicator or error message
      return Center(
        child: CircularProgressIndicator(), // Loading indicator
      );
    }
    return ListView.builder(
      itemCount: widget.selectedProducts.length,
      itemBuilder: (BuildContext context, int index) {
        final dish = dishData[index];
        final List<String> imageUrls = List<String>.from(dish['imageUrls']);
        final leadingIconColor = leadingIconColors[index % leadingIconColors.length];

        return Column(
          children: [
            ListTile(
              onTap: () {
                _addToCart(context, dish);
              },
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dish['title'],
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
    );
  }

  Widget buildTab2Content() {
    return Center(
      child: Text('Tab 2 Content'),
    );
  }

  Widget buildTab3Content() {
    return Center(
      child: Text('Tab 3 Content'),
    );
  }

}
