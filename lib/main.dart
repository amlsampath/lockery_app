import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylockery/locker_app/bloc/locker_bloc.dart';
import 'package:mylockery/locker_app/repository/locker_repository.dart';
import 'package:mylockery/ui/Authentication/login.dart';
import 'package:mylockery/utility/messaging_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

MessagingService _msgService = MessagingService();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await _msgService.init();

  runApp(MyApp());
}

/// Top level function to handle incoming messages when the app is in the background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(" --- background message received ---");
  print(message.notification!.title);
  print(message.notification!.body);
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> initPlatformState() async {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      debugPrint('NOTIFICATION OPENED HANDLER CALLED WITH: $result');
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      setState(() {});
    });

    await OneSignal.shared.setAppId("ef74c728-ae7e-429c-9321-cad3206cf9c7");
  }

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LockerBloc(lockerRepository: LockerRepository())..add(LoadLocker()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SignInScreen(),
      ),
    );
  }
}
