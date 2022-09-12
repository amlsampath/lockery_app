import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylockery/locker_app/bloc/locker_bloc.dart';
import 'package:mylockery/locker_app/repository/locker_repository.dart';
import 'package:mylockery/ui/Authentication/login.dart';

void main() async {
  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
