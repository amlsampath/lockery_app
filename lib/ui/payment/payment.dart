import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mylockery/repository/repository.dart';
import 'package:mylockery/ui/page_controller.dart';
import 'package:mylockery/ui/reusable_widget/custom_button.dart';
import 'package:mylockery/utility/notification.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:uuid/uuid.dart';

class Payment extends StatefulWidget {
  final String lockerId;
  final String userLockerId;
  final String time;
  final String fee;

  const Payment({
    required this.time,
    required this.lockerId,
    required this.userLockerId,
    required this.fee,
    Key? key,
  }) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  double charge = 0.0;
  int totalLockedTime = 0;
  @override
  void initState() {
    final lockedTime = DateTime.parse(widget.time);
    final currentTime = DateTime.now();
    final difference = currentTime.difference(lockedTime).inMinutes;
    setState(() {
      totalLockedTime = difference.toInt();
      charge = difference * double.parse(widget.fee);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Container(
        margin: EdgeInsets.all(
          20.0,
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network('https://img.freepik.com/free-vector/e-wallet-concept-illustration_114360-7561.jpg?w=740&t=st=1662959833~exp=1662960433~hmac=9ae863a2dd2f387a4b11ecf1a5275ef01586601ec12c30294da13189d370f7d3'),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Time',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    totalLockedTime.toString() + " Min",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Amount',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    charge.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              CustomButton(
                color: Colors.orange,
                onClick: () {
                  Alert(
                    context: context,
                    type: AlertType.error,
                    title: "You are going to make payment",
                    desc: "After making payment you cant undo it.",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "Proceed",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () async {
                          var uuid = Uuid();

                          final currentTime = DateTime.now();

                          User? user = FirebaseAuth.instance.currentUser;
                          try {
                            // Insert payment details.
                            await Repository.insert(values: {
                              'user_id': user?.uid,
                              'locked_date': currentTime.toString(),
                              'lockery_id': widget.lockerId,
                              'amount': charge.toString(),
                              'user_payment_id': uuid.v1(),
                            }, table: 'user_payment');

                            // Update lockery list as available.
                            await Repository.update(
                              conditionParameter: 'id',
                              values: {'is_available': true},
                              table: 'locker_list',
                              conditionValue: widget.lockerId,
                            );

                            // Update user lockery data.
                            await Repository.update(
                              conditionParameter: 'user_lockery_id',
                              values: {
                                'is_locked': false,
                                'is_paid': true,
                              },
                              table: 'user_lockery',
                              conditionValue: widget.userLockerId,
                            );
                          } catch (e) {
                            print(e);
                          }

                          await sendOnsignalNotification(
                            title: 'Your Locker Payment',
                            content: 'Amount ' + charge.toString() + "  " + "Locked Time " + totalLockedTime.toString() + " " + "Min",
                          );

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => MyNavigationBar(
                                user: user!,
                              ),
                            ),
                          );
                        },
                        width: 120,
                      ),
                      DialogButton(
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => Navigator.pop(context),
                        width: 120,
                      )
                    ],
                  ).show();
                },
                title: 'Pay Now',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
