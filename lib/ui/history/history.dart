import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mylockery/utility/qr.dart';

class History extends StatefulWidget {
  final User user;
  const History({required this.user, Key? key}) : super(key: key);

  @override
  State<History> createState() => _HomeState();
}

class _HomeState extends State<History> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('user_payment')
                  .where(
                    'user_id',
                    isEqualTo: widget.user.uid,
                  )
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return const Center(
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
                          /* Image.network(
                            'http://clipart-library.com/image_gallery2/Shopping-Bag-PNG-HD.png',
                            height: size.height * .25,
                          ), */
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Time\n" + document['locked_date'].toString().substring(0, 19)),
                              Text("Amount " + document['amount'].toString()),
                            ],
                          ),
                          SizedBox(
                            height: size.height * .02,
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
