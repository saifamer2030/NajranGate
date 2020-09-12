import 'package:flutter/material.dart';
import 'package:NajranGate/FragmentSouqNajran.dart';
import 'package:NajranGate/screens/network_connection.dart';
import 'package:NajranGate/screens/loginphone.dart';
import 'package:NajranGate/screens/splash.dart';
import 'package:flutter/services.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Widget homePage = Splash();

  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(homePage));
//  SystemChrome.setPreferredOrientations([
//    DeviceOrientation.portraitDown,
//    DeviceOrientation.portraitUp,
//  ]);
}

class MyApp extends StatelessWidget {
  final Widget homePage;
  MyApp(this.homePage);
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      builder: (context, child) {
        return MediaQuery(
          child: child,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'Gate Najran',
      theme: ThemeData(

//        primarySwatch: Colors.white ,
//        accentColor:  HexColor('#ffd700'),
//        secondaryHeaderColor: HexColor('#ed0875'),
//        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: homePage,/*MyHomePage(title: 'Flutter Demo Home Page'),*/
      routes:{
        Splash.routeName: (ctx) => Splash(),

//      '/splash':(BuildContext context)=>new Splash(),
//        '/signup':(BuildContext context)=>new SignIn(),
//      '/conection':(BuildContext context)=>new ConnectionScreen(),

    },
    );
  }
}


