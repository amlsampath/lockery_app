import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mylockery/ui/home/home.dart';
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
                                DateTime now = DateTime.now();
                                String datetime = DateTime.now().toString();
                                var firebaseUser = await FirebaseAuth.instance.currentUser;
                                var uuid = Uuid();
                                try {
                                  await FirebaseFirestore.instance.collection('user_lockery').add({
                                    'is_paid': false,
                                    'locked_date': datetime.toString(),
                                    'lockery_id': code,
                                    'rack_number': 1.toString(),
                                    'user_id': firebaseUser!.uid,
                                    'user_lockery_id': uuid.v1(),
                                  }).then((value) {
                                    print('UI************');
                                    print(value.id);
                                  });

                                  //  await FirebaseFirestore.instance.collection('user_lockery').doc().update());
                                  try {
                                    final post = await FirebaseFirestore.instance
                                        .collection('locker_list')
                                        .where(
                                          'id',
                                          isEqualTo: code,
                                        )
                                        .limit(1)
                                        .get()
                                        .then((
                                      QuerySnapshot snapshot,
                                    ) {
                                      //Here we get the document reference and return to the post variable.
                                      return snapshot.docs[0].reference;
                                    });

                                    var batch = FirebaseFirestore.instance.batch();

                                    batch.update(post, {'is_available': false});
                                    batch.commit();
                                  } catch (e) {
                                    print(e);
                                  }
                                  setState(() {
                                    _isLoading = false;
                                  });

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
                    }),
              ),
            ),
    );
  }
}
