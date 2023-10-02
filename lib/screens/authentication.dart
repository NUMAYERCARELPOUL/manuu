import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_screen.dart';

class Authentication extends StatefulWidget {
  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = authResult.user;

        return user;
      } else {
        // Handle the case where the user canceled the sign-in or didn't select an account.
        return null;
      }
    } catch (error) {
      // Handle any errors that occur during the sign-in process.
      print(error);
      return null;
    }
  }
  Future<void> _handleSignIn(String s) async {
    final User? user = await signInWithGoogle();

    if (user != null) {
      // Handle successful Google Sign-In here.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(), // Replace with your home screen
        ),
      );
    } else {
      // Handle the case where the user canceled the sign-in or there was an error.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign-in was canceled or there was an error.'),
        ),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 140,
            ),
            Center(
              child: SizedBox(
                height: 140,
                child: Image.network(
                    "https://www.gstatic.com/devrel-devsite/prod/v47c000584df8fd5ed12554bcabcc16cd4fd28aee940bdc8ae9e35cab77cbb7da/firebase/images/touchicon-180.png"),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            InkWell(
              onTap: signInWithGoogle, // Handle Google Sign-In when the button is tapped
              child: Padding(
                padding: const EdgeInsets.only(right: 40, left: 40),
                child: ElevatedButton(
                  onPressed: signInWithGoogle,

                  style: ElevatedButton.styleFrom(primary: Colors.blue),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 20,
                        child: Image.network(
                            "https://www.transparentpng.com/thumb/google-logo/google-logo-png-icon-free-download-SUF63j.png"),
                      ),
                      SizedBox(
                        width: 70,
                      ),
                      Text(
                        "Google",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40, left: 40),
              child: ElevatedButton(
                onPressed: () async {
                  await  _handleSignIn("+1234567890");
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                },
                style: ElevatedButton.styleFrom(primary: Colors.green),
                child: Row(
                  children: [
                    SizedBox(
                      height: 20,
                      child: Image.network(
                          "https://i.pinimg.com/originals/84/4e/8c/844e8cd4ab26c82286238471f0e5a901.png"),
                    ),
                    SizedBox(
                      width: 70,
                    ),
                    Text(
                      "Phone",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
