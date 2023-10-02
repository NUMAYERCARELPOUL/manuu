// import 'package:flutter/material.dart';
//
// import '../../model/cartmodel.dart';
//
// class Salad extends StatefulWidget {
//   final CartModel cart;
//
//   Salad({required this.cart});
//   @override
//   _SaladState createState() => _SaladState();
// }
//
// class _SaladState extends State<Salad> {
//   List<Map<String, dynamic>> selectedProducts = [];
//
//   // ... Rest of your code ...
//
//   // Simulated data (replace with your actual data)
//   final List<Map<String, dynamic>> dishData = [
//     {
//       'title': 'Dish Title 1',
//       'price': 'SAR 7.95',
//       'calories': '15 calories',
//       'additionalText': 'Additional Information: Some additional text here',
//       'imageUrls': [
//         'https://www.gimmesomeoven.com/wp-content/uploads/2016/09/Apple-Spinach-Recipe-3.jpg',
//       ],
//       'count': 0,
//     },
//     {
//       'title': 'Dish Title 2',
//       'price': 'SAR 9.95',
//       'calories': '20 calories',
//       'additionalText': 'Additional Information: Some additional text here',
//       'imageUrls': [
//         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRorzJTp6aMNeLR0JX2M_VEBwPcliuzNM7Xzg&usqp=CAU',
//       ],
//       'count': 0,
//     },
//     // Add more dish data as needed
//   ];
//
//   void _addToCart(BuildContext context, Map<String, dynamic> product) {
//     setState(() {
//       product['count']++;
//       if (!selectedProducts.contains(product)) {
//         selectedProducts.add(product);
//       }
//     });
//
//     // You can also show a snackbar to confirm the item was added to the cart
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('${product['title']} added to cart'),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }
//
//   final List<Color> leadingIconColors = [
//     Colors.red,
//     Colors.blue,
//     Colors.green,
//     Colors.orange,
//     Colors.purple,
//   ];
//
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: dishData.length,
//       itemBuilder: (BuildContext context, int index) {
//         final dish = dishData[index];
//         final List<String> imageUrls = List<String>.from(dish['imageUrls']);
//         final leadingIconColor = leadingIconColors[index % leadingIconColors.length];
//
//         return Column(
//           children: [
//             ListTile(
//               onTap: () {
//                 _addToCart(context, dish);
//               },
//               title: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     dish['title'],
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(dish['price']),
//                       Text(dish['calories']),
//                     ],
//                   ),
//                   Text(
//                     dish['additionalText'],
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: 150,
//                     height: 40,
//                     margin: EdgeInsets.only(bottom: 8),
//                     decoration: BoxDecoration(
//                       color: Colors.green,
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.remove),
//                           color: Colors.white,
//                           onPressed: () {
//                             // Handle subtraction
//                             setState(() {
//                               if (dish['count'] > 0) {
//                                 dish['count']--;
//                               }
//                             });
//                           },
//                         ),
//                         Text(
//                           dish['count'].toString(),
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.add),
//                           color: Colors.white,
//                           onPressed: () {
//                             // Handle addition
//                             setState(() {
//                               dish['count']++;
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               trailing: SizedBox(
//                 width: 100,
//                 height: 100,
//                 // Adjust the width as needed
//                 child: ListView.builder(
//                   itemCount: imageUrls.length,
//                   scrollDirection: Axis.horizontal,
//                   itemBuilder: (BuildContext context, int imageIndex) {
//                     return Padding(
//                       padding: EdgeInsets.all(4.0),
//                       child: Image.network(
//                         imageUrls[imageIndex],
//                         width: 70,
//                         height: 80,
//                         fit: BoxFit.cover,
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               leading: CircleAvatar(
//                 radius: 7,
//                 backgroundColor: leadingIconColor,
//                 child: Icon(
//                   Icons.adjust_rounded,
//                   size: 10,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             Divider(), // Add a Divider between ListTiles
//           ],
//         );
//       },
//     );
//   }
// }
