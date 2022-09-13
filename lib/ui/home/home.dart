import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mylockery/ui/Authentication/login.dart';
import 'package:mylockery/ui/payment/payment.dart';
import 'package:mylockery/ui/reusable_widget/custom_button.dart';
import 'package:mylockery/utility/qr.dart';

class Home extends StatefulWidget {
  final User user;
  const Home({required this.user, Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _logout() {
    return showDialog(
      context: context,
      builder: (context) => new Theme(
        data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.grey[100], backgroundColor: Colors.white),
        child: AlertDialog(
          backgroundColor: Colors.white,
          elevation: 5.0,
          title: new Text(
            'Are you sure?',
            style: const TextStyle(color: Colors.black),
          ),
          content: new Text(
            'Do you want to logout from this App?',
            style: const TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            new FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => SignInScreen(),
                  ),
                );
              },
              child: new Text('Yes', style: TextStyle(color: Colors.amber[800])),
            ),
            new FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No', style: TextStyle(color: Colors.amber[800])),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          GestureDetector(
              onTap: () async {
                _logout();
              },
              child: const Icon(Icons.logout)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('user_lockery')
                  .where(
                    'user_id',
                    isEqualTo: widget.user.uid,
                  )
                  .where(
                    'is_locked',
                    isEqualTo: true,
                  )
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                if (snapshot.data!.size == 0) {
                  return Center(
                    child: Text('No Information Available.'),
                  );
                }
                return new ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
/*                     return new ListTile(
                      title: new Text(document['is_paid'].toString()),
                      subtitle: new Text(document['user_lockery_id']),
                    ); */

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(topLeft: const Radius.circular(10), topRight: Radius.circular(10), bottomLeft: const Radius.circular(10), bottomRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(
                        size.width * .05,
                      ),
                      margin: EdgeInsets.all(
                        size.width * .05,
                      ),
                      width: size.width,
                      child: Column(
                        children: [
                          Image.network(
                            'http://clipart-library.com/image_gallery2/Shopping-Bag-PNG-HD.png',
                            height: size.height * .25,
                          ),
                          SizedBox(
                            height: size.height * .02,
                          ),
                          Text(
                            "Rack No" + document['rack_number'].toString(),
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: size.height * .02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Time\n" + document['locked_date'].toString().substring(0, 19)),
                              Text("Location " + document['location']),
                            ],
                          ),
                          SizedBox(
                            height: size.height * .02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                color: document['is_paid'] ? Colors.green.shade200 : Colors.green,
                                onClick: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => Payment(
                                        userLockerId: document['user_lockery_id'],
                                        time: document['locked_date'],
                                        lockerId: document['lockery_id'],
                                        fee: document['fee'],
                                      ),
                                    ),
                                  );
                                },
                                title: 'Unlock Now',
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => QR(
                  // user: user,
                  ),
            ),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
