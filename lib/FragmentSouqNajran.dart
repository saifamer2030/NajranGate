import 'dart:convert';
import 'dart:io';

import 'package:NajranGate/screens/ModelsForChating/chat.dart';
import 'package:NajranGate/screens/ModelsForChating/home.dart';
import 'package:NajranGate/screens/advprofile.dart';
import 'package:NajranGate/screens/loginmail.dart';
import 'package:NajranGate/screens/myadvertisement.dart';
import 'package:NajranGate/screens/splash.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fimber/fimber_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

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
  DateTime backbuttonpressedTime;
  // Properties & Variables needed
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
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
  FirebaseAuth _firebaseAuth;
  String ImageUrl = "";
  String TextBody = "";
  String TitleHead = "";
  String ShowADV = "";
  String TextButton = "";
  String Button = "";

  String _userId;

  @override
  void initState() {
    super.initState();
    _firebaseAuth = FirebaseAuth.instance;
    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? null
        : setState(() {
            _userId = user.uid;
            final userdatabaseReference =
                FirebaseDatabase.instance.reference().child("PopUpMessage");
            userdatabaseReference
                .child("wwwwwwwwwwwwwwwwwwwwwwwwwwwwww")
                .child("ShowADV")
                .once()
                .then((DataSnapshot snapshot5) {
              setState(() {
                if (snapshot5.value != null) {
                  setState(() {
                    ShowADV = snapshot5.value;
                    print("############$ShowADV####################");
                  });
                } else {
                  setState(() {
                    ShowADV = "false";
                  });
                }
              });
            });
            //////////////////////////
            userdatabaseReference
                .child("wwwwwwwwwwwwwwwwwwwwwwwwwwwwww")
                .child("ImageUrl")
                .once()
                .then((DataSnapshot snapshot5) {
              setState(() {
                if (snapshot5.value != null) {
                  setState(() {
                    ImageUrl = snapshot5.value;
                  });
                } else {
                  setState(() {
                    ImageUrl =
                        "https://firebasestorage.googleapis.com/v0/b/souqnagran-49abe.appspot.com/o/FIAMImages%2FIMG-20200906-WA0029.jpg?alt=media&token=e636b542-3167-4f03-bb9c-bf9d0ce318d4";
                  });
                }
              });
            });

            ////////////////////////
            userdatabaseReference
                .child("wwwwwwwwwwwwwwwwwwwwwwwwwwwwww")
                .child("TextBody")
                .once()
                .then((DataSnapshot snapshot5) {
              setState(() {
                if (snapshot5.value != null) {
                  setState(() {
                    TextBody = snapshot5.value;
                  });
                } else {
                  setState(() {
                    TextBody = "لا يوجد نص إعلاني";
                  });
                }
              });
            });
            userdatabaseReference
                .child("wwwwwwwwwwwwwwwwwwwwwwwwwwwwww")
                .child("TitleHead")
                .once()
                .then((DataSnapshot snapshot5) {
              setState(() {
                if (snapshot5.value != null) {
                  setState(() {
                    TitleHead = snapshot5.value;
                  });
                } else {
                  setState(() {
                    TitleHead = "لا يوجد نص إعلاني";
                  });
                }
              });
            });
            userdatabaseReference
                .child("wwwwwwwwwwwwwwwwwwwwwwwwwwwwww")
                .child("Button")
                .once()
                .then((DataSnapshot snapshot5) {
              setState(() {
                if (snapshot5.value != null) {
                  setState(() {
                    Button = snapshot5.value;
                  });
                } else {
//                  setState(() {
//                    Button = "لا يوجد نص إعلاني";
//                  });
                }
              });
            });
            userdatabaseReference
                .child("wwwwwwwwwwwwwwwwwwwwwwwwwwwwww")
                .child("TextButton")
                .once()
                .then((DataSnapshot snapshot5) {
              setState(() {
                if (snapshot5.value != null) {
                  setState(() {
                    TextButton = snapshot5.value;
                  });
                } else {
                  setState(() {
                    TextButton = "لا يوجد نص إعلاني";
                  });
                }
              });
            });

            ////////////////////////
          }));

    // Toast.show("kkkkkkkkkkk"+widget.regionlist.toString(),context,duration: Toast.LENGTH_SHORT,gravity:  Toast.BOTTOM);
//print("kkkkkklllllkkkkk"+FragmentSouq1.regionlist.toString());



    setState(() {
      currentScreen = AllAdvertesmenta(widget.regionlist);
    });

//    _currentIndex = widget.selectPage != null ? widget.selectPage : 4;
  }

  @override
  Widget build(BuildContext context) {
    // final List<Widget> children = screens( );

    return Scaffold(
      body: WillPopScope(
        onWillPop: onWillPop,
        child: PageStorage(
          child: currentScreen,
          bucket: bucket,
        ),
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
                    onPressed: () async {
//                      var scheduledNotificationDateTime =
//                      new DateTime.now().add(new Duration(seconds: 20));
//                      var androidPlatformChannelSpecifics =
//                      new AndroidNotificationDetails('your other channel id',
//                          'your other channel name', 'your other channel description');
//                      var iOSPlatformChannelSpecifics =
//                      new IOSNotificationDetails();
//                      NotificationDetails platformChannelSpecifics = new
//                      NotificationDetails(
//                          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//                      await flutterLocalNotificationsPlugin.schedule(
//                          0,
//                          'scheduled title',
//                          'scheduled body',
//                          scheduledNotificationDateTime,
//                          platformChannelSpecifics);

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
                        print("############$ShowADV####################");
                        ShowADV == "true"
                            ? Alert(
                                context: context,
                                title: TitleHead,
                                desc: TextBody,
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      TextButton,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () {
                                      _makePhoneCall('$Button');
                                      print("#################$Button");
                                    } /*Navigator.pop(context)*/,
                                    color: Color.fromRGBO(0, 179, 134, 1.0),
                                    radius: BorderRadius.circular(0.0),
                                  ),
                                ],
                                image: CachedNetworkImage(
                                  imageUrl: ImageUrl,
                                  placeholder: (context, url) => SpinKitCircle(
                                      color: const Color(0xff171732)),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ).show()
                            : Container();
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
  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    //Statement 1 Or statement2
    bool backButton = backbuttonpressedTime == null ||
        currentTime.difference(backbuttonpressedTime) > Duration(seconds: 3);

    if (backButton) {
      backbuttonpressedTime = currentTime;
      Fluttertoast.showToast(
          msg: 'للخروج من بوابة نجران اضغط الرجوع مرتين',
          backgroundColor: Colors.black,
          textColor: Colors.white);
      return false;
    }
    return true;
  }
  void handleRouting(dynamic notification) {
    switch (notification['view']) {
      case 'chat':
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => HomePage()));
        break;
      case 'comment':
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                MyAdvertisement(widget.regionlist)));
        break;
    }
  }



  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
                          builder: (context) => SignIn(widget.regionlist),
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
