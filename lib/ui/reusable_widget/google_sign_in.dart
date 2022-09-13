import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mylockery/repository/repository.dart';
import 'package:mylockery/ui/page_controller.dart';
import 'package:mylockery/utility/authentication.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn().then((value) async {
        print('Email*******************');
        print(value!.email);
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });
                String? user_token = '';
                FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance; // Change here
                _firebaseMessaging.getToken().then((token) {
                  user_token = token;
                });
                await OneSignal.shared.setAppId('ef74c728-ae7e-429c-9321-cad3206cf9c7');

                /// Get the Onesignal userId and update that into the firebase.
                /// So, that it can be used to send Notifications to users later.̥
                final status = await OneSignal.shared.getDeviceState();
                final String? osUserID = status?.userId;
                // We will update this once he logged in and goes to dashboard.
                ////updateUserProfile(osUserID);
                // Store it into shared prefs, So that later we can use it.

                User? user = await Authentication.signInWithGoogle(context: context);

                setState(() {
                  _isSigningIn = false;
                });

                if (user != null) {
                  int count = await FirebaseFirestore.instance
                      .collection('users')
                      .where(
                        'user_id',
                        isEqualTo: user.uid,
                      )
                      .get()
                      .then((value) => value.size);

                  if (count == 0) {
                    try {
                      await Repository.insert(values: {
                        'email': user.email,
                        'name': user.displayName,
                        'token': osUserID,
                        'user_id': user.uid,
                        'status': 1,
                      }, table: 'users');
                    } catch (e) {
                      print(e);
                    }
                  }

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => MyNavigationBar(
                        user: user,
                      ),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Image(
                      image: AssetImage("assets/google_logo.png"),
                      height: 35.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
