import 'dart:convert';
import 'dart:io';

import 'package:NajranGate/screens/loginmail.dart';
import 'package:fimber/fimber_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:NajranGate/classes/FavClass.dart';
import 'package:NajranGate/screens/MoreSouqNajran.dart';
import 'package:NajranGate/screens/alladvertsments.dart';
import 'package:NajranGate/screens/bottomsheet_widget.dart';
import 'package:NajranGate/screens/myalarms.dart';
import 'package:NajranGate/screens/myfavourits.dart';
import 'package:NajranGate/screens/personal_page.dart';
import 'package:NajranGate/screens/loginphone.dart';

class FragmentSouq1 extends StatefulWidget {
  List<String> regionlist = [];

  FragmentSouq1(this.regionlist);

  @override ///////
  _Fragment1SouqState createState() => _Fragment1SouqState();
}

FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();

class _Fragment1SouqState extends State<FragmentSouq1> {
  // Properties & Variables needed

  int currentTab = 3; // to keep track of active tab index
//  List<Widget> _children() => [

  List<Widget> screens() => [
        AllAdvertesmenta(widget.regionlist),
        MyFav(widget.regionlist),
        MyAlarms(widget.regionlist),
        MoreSouqNajran(widget.regionlist),
      ]; // to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  Widget currentScreen; // Our first view in viewport
  @override
  void initState() {
    super.initState();
    // Toast.show("kkkkkkkkkkk"+widget.regionlist.toString(),context,duration: Toast.LENGTH_SHORT,gravity:  Toast.BOTTOM);
//print("kkkkkklllllkkkkk"+FragmentSouq1.regionlist.toString());
    // registerNotification();
    configLocalNotification();
    setState(() {
      currentScreen = AllAdvertesmenta(widget.regionlist);
    });

//    _currentIndex = widget.selectPage != null ? widget.selectPage : 4;
  }

  @override
  Widget build(BuildContext context) {
    // final List<Widget> children = screens( );

    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      key: navigatorKey,
      floatingActionButton: MyFloatingButton(widget.regionlist),
//      _show
//          ? FloatingActionButton(
//              backgroundColor: const Color(0xff171732),
//              child: Icon(Icons.add),
//              onPressed: () {
//                var sheetController = showBottomSheet(
//                    context: context,
//                    builder: (context) => BottomSheetWidget());
//
//                _showButton(false);
//
//                sheetController.closed.then((value) {
//                  _showButton(true);
//                });
//              },
//            )
//          : Container(), //171732
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      print("kkkkkkkkk");
                      setState(() {
                        currentScreen = MoreSouqNajran(widget
                            .regionlist); // if user taps on this dashboard tab will be active
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.settings,
                          color: currentTab == 0
                              ? const Color(0xff171732)
                              : Colors.grey,
                        ),
                        Text(
                          'المزيد',
                          style: TextStyle(
                            color: currentTab == 0
                                ? const Color(0xff171732)
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = MyAlarms(widget
                            .regionlist); // if user taps on this dashboard tab will be active
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.notifications_active,
                          color: currentTab == 2
                              ? const Color(0xff171732)
                              : Colors.grey,
                        ),
                        Text(
                          'التنبيهات',
                          style: TextStyle(
                            color: currentTab == 2
                                ? const Color(0xff171732)
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Right Tab bar icons

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = MyFav(widget
                            .regionlist); // if user taps on this dashboard tab will be active
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.favorite,
                          color: currentTab == 1
                              ? const Color(0xff171732)
                              : Colors.grey,
                        ),
                        Text(
                          'المفضلة',
                          style: TextStyle(
                            color: currentTab == 1
                                ? const Color(0xff171732)
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = AllAdvertesmenta(widget
                            .regionlist); // if user taps on this dashboard tab will be active
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.home,
                          color: currentTab == 3
                              ? const Color(0xff171732)
                              : Colors.grey,
                        ),
                        Text(
                          'بوابة نجران',
                          style: TextStyle(
                            color: currentTab == 3
                                ? const Color(0xff171732)
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      showNotification(message['notification']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      _serialiseAndNavigate(message);
      return;
    },
        //onBackgroundMessage: myBackgroundMessageHandler,
        onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      _serialiseAndNavigate(message);
      return;
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@drawable/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'ccom.topstylesa.topstyle'
          : 'com.topstylesa.topstyle',
      'topstyle',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }

  // ignore: missing_return
  Future _serialiseAndNavigate(Map<String, dynamic> message) {
    var notificationData = message['data'];
    var view = notificationData['view'];

    if (view != null) {
      // Navigate to the create post view
      if (view == 'cart_screen') {
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => AllAdvertesmenta(widget.regionlist)),
        );
      } else if (view == 'categories_screen') {
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => AllAdvertesmenta(widget.regionlist)),
        );
      }
    }
  }

  Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    print("_backgroundMessageHandler");
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      print("_backgroundMessageHandler data: $data");
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      print("_backgroundMessageHandler notification: $notification");
      Fimber.d("=====>myBackgroundMessageHandler $message");
    }
    return Future<void>.value();
  }

  Future selectNotification(String payload) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AllAdvertesmenta(widget.regionlist)),
    );

//    if (payload == 'cart') {
//      debugPrint('notification payload: ' + payload);
//
//    }
  }
}

class MyFloatingButton extends StatefulWidget {
  List<String> regionlist = [];

  MyFloatingButton(this.regionlist);

  @override
  _MyFloatingButtonState createState() => _MyFloatingButtonState();
}

class _MyFloatingButtonState extends State<MyFloatingButton> {
  bool _show = true;

  @override
  Widget build(BuildContext context) {
    return _show
        ? FloatingActionButton(
            backgroundColor: const Color(0xff171732),
            child: Text(
              "إعلان",
              style: TextStyle(
                fontFamily: 'Estedad-Black',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff),
                height: 0.7471466064453125,
              ),
            ),
            heroTag: "unique3",
            onPressed: () {
              FirebaseAuth.instance.currentUser().then((user) => user == null
                  ? Navigator.of(context, rootNavigator: false).push(
                      MaterialPageRoute(
                          builder: (context) => LoginScreen2(widget.regionlist),
                          maintainState: false))
                  : setState(() {
                      var sheetController = showBottomSheet(
                          context: context,
                          builder: (context) =>
                              BottomSheetWidget(widget.regionlist));

                      _showButton(false);

                      sheetController.closed.then((value) {
                        _showButton(true);
                      });
                    }));
            },
          )
        : Container();
  }

  void _showButton(bool value) {
    setState(() {
      _show = value;
    });
  }
}
