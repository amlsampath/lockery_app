import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mylockery/constants/color_constatant.dart';
import 'package:mylockery/ui/reusable_widget/google_sign_in.dart';
import 'package:mylockery/utility/authentication.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final _firestore = FirebaseFirestore.instance;
  final key = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    FirebaseMessaging.onMessageOpenedApp.listen((
      RemoteMessage message,
    ) {
      print('A new onMessageOpenedApp event was published!');
    });
    // firebaseMessaging.configure(
    //   //called when app is in foreground
    //   onMessage: (Map<String, dynamic> message) async {
    //     print('init called onMessage');
    //     final snackBar = SnackBar(
    //       content: Text(message['notification']['body']),
    //       action: SnackBarAction(label: 'GO', onPressed: () {}),
    //     );
    //     key.currentState!.showSnackBar(snackBar);
    //   },
    //   //called when app is completely closed and open from push notification
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print('init called onLaunch');
    //   },
    //   //called when app is in background  and open from push notification

    //   onResume: (Map<String, dynamic> message) async {
    //     print('init called onResume');
    //   },
    // );
    // firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Image.asset(
                        'assets/logo.png',
                        height: size.height * .5,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Welcome To',
                      style: TextStyle(
                        color: CustomColors.firebaseYellow,
                        fontSize: 40,
                      ),
                    ),
                    Text(
                      'Lockery',
                      style: TextStyle(
                        color: CustomColors.firebaseOrange,
                        fontSize: 40,
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: Authentication.initializeFirebase(context: context),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error initializing Firebase');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return GoogleSignInButton();
                  }
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      CustomColors.firebaseOrange,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
