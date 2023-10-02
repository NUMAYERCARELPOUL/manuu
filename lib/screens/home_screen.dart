import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:untitled13/screens/drawer.dart';
import 'package:untitled13/screens/tab_view/salad.dart';
import '../model/cartmodel.dart';
import 'cart.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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

  Future<void> fetchDataFromAPI() async {
    final apiUrl = Uri.parse('https://www.mocky.io/v2/5dfccffc310000efc8d2c1ad');

    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData != null && jsonData is List) {
          setState(() {
            dishData = List<Map<String, dynamic>>.from(jsonData);
          });
        } else {
          throw Exception('API response is not a valid JSON array');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error: $error');
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen(selectedProducts: selectedProducts)));
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
        body:  FutureBuilder(
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
                  buildTab1Content(),
                  buildTab2Content(),
                  buildTab3Content(),
                ],
              );
            }
          },
        ),
      ),
    );
  }
  Widget buildTab1Content() {
    if (dishData.isEmpty) {
      // Display a loading indicator or error message
      return Center(
        child: CircularProgressIndicator(), // Loading indicator
      );
    }
    return ListView.builder(
      itemCount: dishData.length,
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

class JsonModel {
  final String restaurantId;
  final String restaurantName;
  final String restaurantImage;
  final String tableId;
  final String tableName;
  final String branchName;
  final String nexturl;
  final List<TableMenuList> tableMenuList;

  JsonModel({
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantImage,
    required this.tableId,
    required this.tableName,
    required this.branchName,
    required this.nexturl,
    required this.tableMenuList,
  });
}

class TableMenuList {
  final String menuCategory;
  final String menuCategoryId;
  final String menuCategoryImage;
  final String nexturl;
  final List<CategoryDish> categoryDishes;

  TableMenuList({
    required this.menuCategory,
    required this.menuCategoryId,
    required this.menuCategoryImage,
    required this.nexturl,
    required this.categoryDishes,
  });
}

class AddonCat {
  final String addonCategory;
  final String addonCategoryId;
  final int addonSelection;
  final String nexturl;
  final List<CategoryDish> addons;

  AddonCat({
    required this.addonCategory,
    required this.addonCategoryId,
    required this.addonSelection,
    required this.nexturl,
    required this.addons,
  });
}

class CategoryDish {
  final String dishId;
  final String dishName;
  final double dishPrice;
  final String dishImage;
  final DishCurrency dishCurrency;
  final int dishCalories;
  final String dishDescription;
  final bool dishAvailability;
  final int dishType;
  final String? nexturl;
  final List<AddonCat>? addonCat;

  CategoryDish({
    required this.dishId,
    required this.dishName,
    required this.dishPrice,
    required this.dishImage,
    required this.dishCurrency,
    required this.dishCalories,
    required this.dishDescription,
    required this.dishAvailability,
    required this.dishType,
    this.nexturl,
    this.addonCat,
  });
}

enum DishCurrency {
  SAR,
}
class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedProducts;

  const CheckoutScreen({required this.selectedProducts});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final List<Map<String, dynamic>> dishData = [];

  // Define a list of colors for the leading icons
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
