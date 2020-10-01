import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:NajranGate/classes/CityClass.dart';
import 'package:NajranGate/screens/loginphone.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';
import '../FragmentSouqNajran.dart';
import 'network_connection.dart';

class Splash extends StatefulWidget {
  static String routeName = 'splash-screen';
  bool isLoggedIn = false;
  String userId, usertype;

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  List<String> regionlist = [];
  FirebaseDatabase regiondatabaseReference;

  init(regionlist) {
    // Navigator.of(context).pushNamed('/login');
    FirebaseAuth.instance.currentUser().then((user) => user != null
            ? Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => FragmentSouq1(regionlist)))
            : Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => FragmentSouq1(regionlist)))

//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) =>
//                   SignIn(regionlist))),
        );
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();

//    _initFirebaseMessaging();

    Future.delayed(Duration(seconds: 0), () async {
//      try {
//        final result = await InternetAddress.lookup('google.com');
//        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          regiondatabaseReference = FirebaseDatabase.instance;
//          regiondatabaseReference.setPersistenceEnabled(true);
//          regiondatabaseReference.setPersistenceCacheSizeBytes(10000000);

//          final regiondatabaseReference =
//          FirebaseDatabase.instance.reference().child("citydatabase");
          regiondatabaseReference
              .reference()
              .child("citydatabase")
              .once()
              .then((DataSnapshot snapshot) {
            var KEYS = snapshot.value.keys;
            var DATA = snapshot.value;
            //Toast.show("${snapshot.value.keys}",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
            regionlist.clear();
            regionlist.add('الحى');

            for (var individualkey in KEYS) {
              CityClass regionclass = new CityClass(
                DATA[individualkey]['ccity'],
              );
              setState(() {
                regionlist.add(DATA[individualkey]['ccity']);
              });
            }
            init(regionlist);
            //   print("llllllll"+regionlist.toString());
          });
//        }else{
//          Navigator.pushReplacement(
//              context,
//              MaterialPageRoute(
//                  builder: (context) => FragmentSouq1(["لا يوجد بيانات"])));
//        }
//      } on SocketException catch (_) {
        regiondatabaseReference = FirebaseDatabase.instance;
//        regiondatabaseReference.setPersistenceEnabled(true);
//        regiondatabaseReference.setPersistenceCacheSizeBytes(10000000);

//          final regiondatabaseReference =
//          FirebaseDatabase.instance.reference().child("citydatabase");
        regiondatabaseReference
            .reference()
            .child("citydatabase")
            .once()
            .then((DataSnapshot snapshot) {
          var KEYS = snapshot.value.keys;
          var DATA = snapshot.value;
          //Toast.show("${snapshot.value.keys}",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
          regionlist.clear();
          regionlist.add('الحى');

          for (var individualkey in KEYS) {
            CityClass regionclass = new CityClass(
              DATA[individualkey]['ccity'],
            );
            setState(() {
              regionlist.add(DATA[individualkey]['ccity']);
            });
          }

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => FragmentSouq1(regionlist)));
          print("llllllll" + regionlist.toString());
        }).timeout(Duration(seconds: 3), onTimeout: () {
          setState(() {
            regionlist.length == 0
                ?    Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => FragmentSouq1(["لا يوجد بيانات"])))
                : Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FragmentSouq1(regionlist)));
          });
        });
//      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff171732),
      body: Center(
        child: Text(
          'بوابة نجران',
          style: TextStyle(
            fontFamily: 'Estedad-Black',
            fontSize: 90,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  _initFirebaseMessaging() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('AppPushs onMessage : $message');
        return;
      },
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
      onResume: (Map<String, dynamic> message) {
        print('AppPushs onResume : $message');
        return;
      },
      onLaunch: (Map<String, dynamic> message) {
        print('AppPushs onLaunch : $message');
        return;
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  // TOP-LEVEL or STATIC function to handle background messages
  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) {
    print('AppPushs myBackgroundMessageHandler : $message');
    return Future<void>.value();
  }
}
