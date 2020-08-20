import 'package:flutter/material.dart';
import 'package:NajranGate/FragmentSouqNajran.dart';
import 'package:NajranGate/screens/network_connection.dart';
import 'package:NajranGate/screens/loginphone.dart';
import 'package:NajranGate/screens/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
   MaterialColor black = const MaterialColor(
     0xFF000000,
    const <int, Color>{
      50: const Color(0xFF000000),
      100: const Color(0xFF000000),
      200: const Color(0xFF000000),
      300: const Color(0xFF000000),
      400: const Color(0xFF000000),
      500: const Color(0xFF000000),
      600: const Color(0xFF000000),
      700: const Color(0xFF000000),
      800: const Color(0xFF000000),
      900: const Color(0xFF000000),
    },

  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gate Najran',
      theme: ThemeData(

        primarySwatch: black,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Splash(),/*MyHomePage(title: 'Flutter Demo Home Page'),*/
      routes: <String,WidgetBuilder>{

//      '/fragmentsouq':(BuildContext context)=>new FragmentSouq1(),
//        '/signup':(BuildContext context)=>new SignIn(),
//      '/conection':(BuildContext context)=>new ConnectionScreen(),

    },
    );
  }
}


