import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.green, Colors.lightGreen], // Replace with your desired gradient colors
              ),
            ),
            child: ClipPath(
              clipper: CurvedDrawerHeaderClipper(),
              child: DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.green, Colors.lightGreen], // Replace with your desired gradient colors
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage("https://images.pexels.com/photos/51953/mother-daughter-love-sunset-51953.jpeg?cs=srgb&dl=pexels-pixabay-51953.jpg&fm=jpg"),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'User Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'ID Number',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('LogOut',style: TextStyle(
                color: Colors.grey[700],
                fontSize: 18
            )),
            onTap: () {
              // Handle home button tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          // Add more ListTile items for additional options
        ],
      ),
    );
  }
}

class CurvedDrawerHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
