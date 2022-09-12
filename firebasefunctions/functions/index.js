const functions = require('firebase-functions');

const admin = require('firebase-admin');


admin.initializeApp(functions.config().firebase);
var msgData;


exports.offerTrigger = functions.firestore.document(
    'user_lockery/{lockerId}'
).onCreate((snapshot, context) => {

    msgData = snapshot.data();

    admin.firestore().collection('users').get().then((snapshots) => {
        var tokens = [];
        if (snapshots.empty) {
            console.log('No Devices Found');
        }
        else {
            for (var pushTokens of snapshots.docs) {
                tokens.push(pushTokens.data().token);
            }

            var payload = {
                'notification': {
                    'title': 'From ' + msgData.locked_date,
                    'body': 'Offer is : ' + msgData.rack_number,
                    'sound': 'default',
                },
                'data': {
                    'sendername': msgData.locked_date,
                    'message': msgData.rack_number,
                }
            };

            return admin.messaging().sendToDevice(tokens, payload).then((response) => {
                console.log('pushed them all')
            }).catch((err) => {
                console.log(err);
            });
        }
    });
});
