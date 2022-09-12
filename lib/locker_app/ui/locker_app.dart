import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class LockerApp extends StatefulWidget {
  const LockerApp({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LockerApp> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LockerApp> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //  mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('locker_list').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return new Text('Loading...');
                  return new ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      print(snapshot.data);
                      // return new ListTile(
                      //   title: new Text(document['is_paid'].toString()),
                      //   subtitle: new Text(document['user_lockery_id']),
                      // );
                      return Container(
                        padding: EdgeInsets.all(
                          10.0,
                        ),
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
                        margin: EdgeInsets.only(
                          left: size.width * .08,
                          right: size.width * .08,
                          top: size.height * .02,
                          bottom: size.height * .02,
                        ),
                        child: Column(
                          children: [
                            !document['is_available']
                                ? Container(
                                    width: size.width * .8,
                                    height: size.height * .4,
                                    child: Center(child: Text('Not Avaiable')),
                                  )
                                : PrettyQr(
                                    // image: AssetImage('images/twitter.png'),
                                    typeNumber: 3,
                                    size: size.width * .8,
                                    data: document['id'],
                                    errorCorrectLevel: QrErrorCorrectLevel.M,
                                    roundEdges: true,
                                  ),
                            SizedBox(
                              height: size.height * .02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Location : ${document['location']}",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Text(
                                //   document['fee'].toString(),
                                //   style: TextStyle(
                                //     fontSize: 20.0,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
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
/*             BlocBuilder<LockerBloc, LockerState>(builder: (context, state) {
              if (state is LockerLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is LokerLoaded) {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.lockers.length,
                  itemBuilder: (context, i) {
                    return Container(
                      padding: EdgeInsets.all(
                        10.0,
                      ),
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
                      margin: EdgeInsets.only(
                        left: size.width * .08,
                        right: size.width * .08,
                        top: size.height * .02,
                        bottom: size.height * .02,
                      ),
                      child: Column(
                        children: [
                          !state.lockers[i].isAvailable
                              ? Container(
                                  width: size.width * .8,
                                  height: size.height * .4,
                                  child: Center(child: Text('Not Avaiable')),
                                )
                              : PrettyQr(
                                  // image: AssetImage('images/twitter.png'),
                                  typeNumber: 3,
                                  size: size.width * .8,
                                  data: state.lockers[i].id,
                                  errorCorrectLevel: QrErrorCorrectLevel.M,
                                  roundEdges: true,
                                ),
                          SizedBox(
                            height: size.height * .02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Location : ${state.lockers[i].location}",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Per Hour ${state.lockers[i].fees}',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return const Text("Something went to wrong");
              }
            }) */
          ],
        ),
      ),
    );
  }
}
