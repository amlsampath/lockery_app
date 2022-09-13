const functions = require('firebase-functions');

const admin = require('firebase-admin');


admin.initializeApp(functions.config().firebase);
var msgData;


exports.offerTrigger = functions.firestore.document(
    'user_lockery/{user_lockery_id}'
).onCreate((snapshot, context) => {
    msgData = snapshot.data();
    admin.firestore().collection('users').get().then((snapshots) => {
        var tokens = [];
        if (snapshots.empty) {
            console.log('No Devices Found');
        }
        else {
            for (var pushTokens of snapshots.docs) {

                // tokens.push(pushTokens.data().token);
                if (pushTokens.data().user_id == msgData.user_id) {
                    tokens.push(pushTokens.data().token);
                    console.log('found  device' + pushTokens.data().user_id + "-" + msgData.user_id);
                }
            }

            var payload = {
                'notification': {

                    'title': 'From ',// + msgData.locked_date,
                    'body': 'Offer is : ', //+ msgData.rack_number,

                },
                'data': {
                    "click_action": 'FLUTTER_NOTIFICATION_CLICK',
                    'sendername': 'hi',//msgData.locked_date,
                    'message': 'hi', //msgData.rack_number,
                    'sound': 'default',
                }
            };

            return admin.messaging().sendToDevice(tokens, payload).then((response) => {
                console.log('pushed them all')
            }).catch((err) => {
                console.log(err);
                console.log('****************************************');
                return null;
            });
        }
    });
});
