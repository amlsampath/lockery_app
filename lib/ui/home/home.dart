import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mylockery/utility/qr.dart';

class Home extends StatefulWidget {
  User user;
  Home({required this.user, Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('user_lockery').where('user_id', isEqualTo: widget.user.uid).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                return new ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
/*                     return new ListTile(
                      title: new Text(document['is_paid'].toString()),
                      subtitle: new Text(document['user_lockery_id']),
                    ); */

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Time " + document['locked_date'].toString().substring(0, 19)),
                              Text("Location "),
                            ],
                          ),
                          SizedBox(
                            height: size.height * .02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  final lockedTime = DateTime.parse(document['locked_date']);
                                  final currentTime = DateTime.now();
                                  final difference = currentTime.difference(lockedTime).inMinutes;
                                },
                                child: Container(
                                  width: size.width * .3,
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      color: document['is_paid'] ? Colors.green.shade200 : Colors.green,
                                      borderRadius: BorderRadius.circular(
                                        10.0,
                                      )),
                                  child: Text(
                                    document['is_paid'] ? 'Paid' : 'Pay Now',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Container(
                                width: size.width * .3,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(
                                      10.0,
                                    )),
                                child: Text(
                                  'Unlock Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
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
          Navigator.of(context).pushReplacement(
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
