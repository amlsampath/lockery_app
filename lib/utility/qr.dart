import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mylockery/locker_app/model/locker_model.dart';
import 'package:mylockery/locker_app/model/user_model.dart';
import 'package:mylockery/repository/repository.dart';
import 'package:mylockery/ui/home/home.dart';
import 'package:mylockery/utility/notification.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:uuid/uuid.dart';

class QR extends StatefulWidget {
  QR({Key? key}) : super(key: key);

  @override
  State<QR> createState() => _QRState();
}

class _QRState extends State<QR> {
  bool _isLoading = false;
  bool _isScanned = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Scanner')),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: EdgeInsets.only(
                left: size.width * .1,
                right: size.width * .1,
                top: size.height * .1,
                bottom: size.height * .1,
              ),
              // width: size.width * .8,
              // height: size.height * .6,
              child: Center(
                child: MobileScanner(
                    allowDuplicates: false,
                    onDetect: (barcode, args) async {
                      Future.delayed(const Duration(milliseconds: 4000), () {
                        if (barcode.rawValue == null) {
                          debugPrint('Failed to scan Barcode');
                        } else {
                          setState(() {
                            _isLoading = true;
                          });
                          final String code = barcode.rawValue!;

                          Alert(
                            context: context,
                            type: AlertType.warning,
                            title: "Now you are going to lock this locker",
                            desc: "After locking you cant unlock until you pay the minimum payment.",
                            content: Column(
                              children: [],
                            ),
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Lock",
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () async {
                                  List<LockerModel> mylockerList = [];
                                  List<UserModel> userDataList = [];
                                  DateTime now = DateTime.now();
                                  String datetime = DateTime.now().toString();
                                  var firebaseUser = await FirebaseAuth.instance.currentUser;
                                  var uuid = Uuid();

                                  try {
                                    // Get Locker Details.

                                    final lockerList = await FirebaseFirestore.instance
                                        .collection('locker_list')
                                        .where(
                                          'id',
                                          isEqualTo: code,
                                        )
                                        .get();
                                    lockerList.docs.forEach((element) {
                                      mylockerList.add(LockerModel.fromJson(element.data()));
                                    });

                                    // Insert payment details.
                                    await Repository.insert(values: {
                                      'is_paid': false,
                                      'locked_date': datetime.toString(),
                                      'lockery_id': code,
                                      'rack_number': mylockerList[0].rack_number,
                                      'location': mylockerList[0].location,
                                      'user_id': firebaseUser!.uid,
                                      'fee': mylockerList[0].fees,
                                      'is_locked': true,
                                      'user_lockery_id': uuid.v1(),
                                    }, table: 'user_lockery');

                                    // Update lockery list as not available
                                    try {
                                      // Update lockery list as not available.
                                      await Repository.update(
                                        conditionParameter: 'id',
                                        values: {'is_available': false},
                                        table: 'locker_list',
                                        conditionValue: code,
                                      );
/* 
                                    User? user = FirebaseAuth.instance.currentUser;
                                    // Get User Details
                                    final list = await FirebaseFirestore.instance
                                        .collection('users')
                                        .where(
                                          'user_id',
                                          isEqualTo: user!.uid,
                                        )
                                        .get();

                                    list.docs.forEach((element) {
                                      userDataList.add(UserModel.fromJson(element.data()));
                                    }); */
                                    } catch (e) {
                                      print(e);
                                    }
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    await sendOnsignalNotification(title: 'Your Locker Booking Info', content: 'Locker Number ' + mylockerList[0].rack_number + "  " + "Locked Time " + datetime.toString());
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => Home(
                                          user: firebaseUser,
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                width: 120,
                              ),
                              DialogButton(
                                color: Colors.orange,
                                child: Text(
                                  "Close",
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  Navigator.pop(context);
                                },
                                width: 120,
                              )
                            ],
                          ).show();
                        }
                      });
                    }),
              ),
            ),
    );
  }
}
