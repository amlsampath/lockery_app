import 'dart:convert';

import 'package:http/http.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

Future sendOnsignalNotification({required String title, required String content}) async {
  var imgUrlString = "http://cdn1-www.dogtime.com/assets/uploads/gallery/30-impossibly-cute-puppies/impossibly-cute-puppy-2.jpg";

/*   var notification = OSCreateNotification(
      playerIds: [
        "dezAijZ8HQzeln5jRRHVpoV:APA91bEdWiOqd2PKdmeZndPt6m0Dl76022NK6JokxRnQAUBDWO13E0PU0UoeV-hCrAn7WX8m7K-txJ127MTIAfEjZvEv0fOm45hpxWHwpkF3xXlDDyoexhg4zcH1_y1ayfwlNSQWqpem",
      ],
      content: "this is a test from OneSignal's Flutter SDK",
      heading: "Test Notification",
      iosAttachments: {"id1": imgUrlString},
      bigPicture: imgUrlString,
      buttons: [OSActionButton(text: "test1", id: "id1"), OSActionButton(text: "test2", id: "id2")]);

  var response = await OneSignal.shared.postNotification(notification);

  print(response); */
  final status = await OneSignal.shared.getDeviceState();
  final String? osUserID = status?.userId;
  post(
    Uri.parse('https://onesignal.com/api/v1/notifications'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Basic ZGIwNDlmZWQtZmM3Yy00MzAzLWE4ZTctMDA4YTYxYjdkNmVh',
    },
    body: jsonEncode(<String, dynamic>{
      "app_id": "ef74c728-ae7e-429c-9321-cad3206cf9c7", //kAppId is the App Id that one get from the OneSignal When the application is registered.

      "include_player_ids": [
        osUserID,
      ], //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

      "android_accent_color": "FF9976D2",

      "small_icon": "ic_stat_onesignal_default",

      "large_icon": "https://ceylonwriters.com/wp-content/uploads/2021/09/Hnet.com-image10-e1631554230582.png",

      "headings": {"en": title},

      "contents": {"en": content},
    }),
  ).then((value) {
    print('Response*************');
    print(value.body);
  });
}
