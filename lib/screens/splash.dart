import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:NajranGate/screens/ModelsForChating/chat.dart';
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
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  init(regionlist) {
    // Navigator.of(context).pushNamed('/login');
    FirebaseAuth.instance.currentUser().then((user) =>
    user != null
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

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
//    _firebaseMessaging.configure(
//      onMessage: (Map<String, dynamic> message) async {
//        print("onMessage: $message");
//        showNotification(message);
//      },
////      onBackgroundMessage: myBackgroundMessageHandler,
//      onLaunch: (Map<String, dynamic> message) async {
//        print("onLaunch: $message");
//        _navigateToItemDetail(message);
//      },
//      onResume: (Map<String, dynamic> message) async {
//        print("onResume: $message");
//        _navigateToItemDetail(message);
//      },
//    );
//    _firebaseMessaging.requestNotificationPermissions(
//        const IosNotificationSettings(
//            sound: true, badge: true, alert: true));
//    _firebaseMessaging.onIosSettingsRegistered
//        .listen((IosNotificationSettings settings) {
//      print("Settings registered: $settings");
//    });
//    _firebaseMessaging.getToken().then((String token) {
//      assert(token != null);
//      print("Push Messaging token: $token");
//    });
//    _firebaseMessaging.subscribeToTopic("matchteam");

    Future.delayed(Duration(seconds: 0), () async {
//      try {



      regiondatabaseReference = FirebaseDatabase.instance;
      regiondatabaseReference.setPersistenceEnabled(true);
//      regiondatabaseReference.setPersistenceCacheSizeBytes(1000000);

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
      regiondatabaseReference.setPersistenceEnabled(true);
//      regiondatabaseReference.setPersistenceCacheSizeBytes(1000000);

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
      }).timeout(Duration(seconds: 4), onTimeout: () {
        setState(() {
          regionlist.length == 0
              ? Navigator.pushReplacement(
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

  void _navigateToItemDetail(Map<String, dynamic> message) {
    final Item item = _itemForMessage(message);
    // Clear away dialogs
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    if (!item.route.isCurrent) {
      Navigator.push(context, item.route);
    }
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.arabdevelopers.souqnagran'
          : 'com.arabdevelopers.souqnagran',
      'NajranGate',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails(
      presentSound: true,
      presentAlert: true,
    );
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}

final Map<String, Item> _items = <String, Item>{};

Item _itemForMessage(Map<String, dynamic> message) {
  final dynamic data = message['data'] ?? message;
  final String itemId = data['id'];
  print("###############$itemId???????????");
  final Item item = _items.putIfAbsent(itemId, () => Item(itemId: itemId))
//    .._matchteam = data['matchteam']
//    .._score = data['score']
      ;
  return item;
}

class Item {
  Item({this.itemId});

  final String itemId;

  StreamController<Item> _controller = StreamController<Item>.broadcast();

  Stream<Item> get onChanged => _controller.stream;

  String _matchteam;

  String get matchteam => _matchteam;

  set matchteam(String value) {
    _matchteam = value;
    _controller.add(this);
  }

  String _score;

  String get score => _score;

  set score(String value) {
    _score = value;
    _controller.add(this);
  }

  static final Map<String, Route<void>> routes = <String, Route<void>>{};

  Route<void> get route {
    final String routeName = '/detail/$itemId';
    return routes.putIfAbsent(
      routeName,
          () =>
          MaterialPageRoute<void>(
            settings: RouteSettings(name: routeName),
            builder: (BuildContext context) => ChatPage(uid: itemId),
          ),
    );
  }
}