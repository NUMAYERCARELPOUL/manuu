import 'package:flutter/material.dart';

import 'home_screen.dart';
class authentication extends StatefulWidget{

  @override
  State<authentication> createState() => _authenticationState();
}

class _authenticationState extends State<authentication> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 140,
            ),
            Center(
              child: SizedBox(
                  height: 100,
                  child: Image.network("https://www.gstatic.com/devrel-devsite/prod/v47c000584df8fd5ed12554bcabcc16cd4fd28aee940bdc8ae9e35cab77cbb7da/firebase/images/touchicon-180.png")),
            ),
            SizedBox(height: 100,),
            InkWell(
              onTap: (){
                // Inside your authentication flow, after successful authentication
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 40,left: 40),
                child: ElevatedButton(onPressed: (){
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HomePage(), // Pass your data to the HomeScreen
                    ),
                  );
                },
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 20,
                          child: Image.network("https://pbs.twimg.com/profile_images/1605297940242669568/q8-vPggS_400x400.jpg"),
                        ),
                        SizedBox(width: 70,),
                        Text("Google",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)

                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40,left: 40),
              child: ElevatedButton(onPressed: (){},
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 20,
                        child: Image.network("https://hogatoga.com/wp-content/uploads/2020/10/IndyCall-free-app-hogatoga.jpg"),
                      ),
                      SizedBox(width: 70,),
                      Text("Phone",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)

                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}