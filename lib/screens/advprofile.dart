import 'dart:io';
import 'dart:typed_data';
import 'package:NajranGate/screens/UserRatingForADV/RatingClass.dart';
import 'package:NajranGate/screens/UserRatingForUser/RatingClass.dart';
import 'package:NajranGate/screens/UserRatingForUser/UserRatingPageForUser.dart';
import 'package:NajranGate/screens/profileUserVeiw.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:NajranGate/classes/AdvNameClass.dart';
import 'package:NajranGate/classes/CommentClass.dart';
import 'package:NajranGate/screens/splash.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';

//import 'package:simple_slider/simple_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'ModelsForChating/chat.dart';
import 'ProfilePhoto.dart';
import 'UserRatingForADV/UserRatingPageForADV.dart';

class AdvProlile extends StatefulWidget {
  String cId;
  String cDateID;
  String cName;
  var cRate;

  AdvProlile(this.cId, this.cDateID, this.cName, this.cRate);

  @override
  _AdvProlileState createState() => _AdvProlileState();
}

class _AdvProlileState extends State<AdvProlile> {
  String _userId;
  String _username;
  var _formKey1 = GlobalKey<FormState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  Future<void> _launched;
  var _controller = ScrollController();
  bool favcheck = false;
  Map map = Map<String, Uint8List>();
  bool presscheck = false;
  FirebaseAuth _firebaseAuth;
  FirebaseDatabase userdatabaseReference;

  //List<OrderDetailClass> orderlist = [];
  List<CommentClass> commentlist = [];

  //var _controller = ScrollController();

  AdvNameClass advnNameclass;
  final double _minimumPadding = 5.0;
  bool _load = false;
  String cPhone;
  TextEditingController _commentController = TextEditingController();
  List<String> _imageUrls;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' +
          payload.split(",")[0] +
          payload.split(",")[1] +
          payload.split(",")[2]);
      await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new AdvProlile(payload.split(",")[0],
                payload.split(",")[1], payload.split(",")[2], 0.0)),
      );
      return;
    }
//
//    await Navigator.push(
//        context,
//        new MaterialPageRoute(
//            builder: (context) =>
//            new Splash()),
//      );
  }

  showNotification(date1, title, _userId, head, name) async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@drawable/ic_lancher');
    var ios = IOSInitializationSettings();
    var initSettings = InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onSelectNotification: onSelectNotification,
    );
    ///////////////////
    DateTime scheduledNotificationDateTime =
        DateTime.parse('$date1').add(new Duration(days: -15));
    //  DateTime.now()/*parse('$date1')*/.add(new Duration(seconds: 5));
//print("scheduledNotificationDateTime:$scheduledNotificationDateTime");
    //   DateTime scheduledNotificationDateTime = DateTime.now();

//    DateTime scheduledNotificationDateTime = new DateTime(
//        notificationbooking.year,
//        notificationbooking.month,
//        notificationbooking.day,
//        notificationbooking.hour - 1,
//        notificationbooking.minute,
//        notificationbooking.second,
//        notificationbooking.millisecond,
//        notificationbooking.microsecond);
//   Toast.show("${scheduledNotificationDateTime1}",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
    /////////////************************
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channelId', 'channelName', 'channelDescription',
        importance: Importance.Max,
        priority: Priority.High /*, ticker: 'ticker'*/);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//    Toast.show(
//        ' ح طال عمرك',
//        context,
//        duration: Toast.LENGTH_SHORT,
//        gravity: Toast.BOTTOM);
// print("ddd${advnNameclass.carrange-}");
    await flutterLocalNotificationsPlugin.schedule(
        advnNameclass.carrange - 202000000000,
        'تذكير بحذف الاعلان',
        'عزيزى العميل سيتم حذف اعلان $title بعد اسبوعين يرجى عمل تمديد له',
        scheduledNotificationDateTime,
        platformChannelSpecifics,
        payload: "$_userId,$head,$name");
    // payload: "");
  }

  @override
  void dispose() {
    // flutterLocalNotificationsPlugin.cancelAll();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _firebaseAuth = FirebaseAuth.instance;
    getUserName();

    final userdatabaseReference =
        FirebaseDatabase.instance.reference().child("userdata");
    final commentdatabaseReference = FirebaseDatabase.instance
        .reference()
        .child("commentsdata")
        .child(widget.cId)
        .child(widget.cDateID);
    commentdatabaseReference.once().then((DataSnapshot snapshot) {
      var KEYS = snapshot.value.keys;
      var DATA = snapshot.value;
      //Toast.show("${snapshot.value.keys}",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);

      commentlist.clear();
      CommentClass commentclass;
      for (var individualkey in KEYS) {
        // if (!blockList.contains(individualkey) &&user.uid != individualkey) {
        CommentClass commentclass = new CommentClass(
          DATA[individualkey]['cId'],
          DATA[individualkey]['cuserid'],
          DATA[individualkey]['cdate'],
          DATA[individualkey]['cheaddate'],
          DATA[individualkey]['ccoment'],
          DATA[individualkey]['cname'],
          DATA[individualkey]['cadvID'],
          DATA[individualkey]['arrange'],
        );
        if (DATA[individualkey]['arrange'] == null) {
          commentclass = new CommentClass(
            DATA[individualkey]['cId'],
            DATA[individualkey]['cuserid'],
            DATA[individualkey]['cdate'],
            DATA[individualkey]['cheaddate'],
            DATA[individualkey]['ccoment'],
            DATA[individualkey]['cname'],
            DATA[individualkey]['cadvID'],
            0,
          );
        }
        setState(() {
          commentlist.add(commentclass);
          setState(() {
            //     print("size of list : 5");
            commentlist.sort((comment1, comment2) =>
                comment2.arrange.compareTo(comment1.arrange));
          });
        });
        // }
      }
    });
    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? setState(() {
            setState(() {
              favcheck = false;
            });
            //_userId = user.uid;

            /////////////////////////////////////
            final advdatabaseReference =
                FirebaseDatabase.instance.reference().child("advdata");
            // print("kkkkkkkkkkkk${widget.cId}////${widget.cDateID}");

            advdatabaseReference
                .child(widget.cId)
                .child(widget.cDateID)
                .once()
                .then((DataSnapshot data1) {
              var DATA = data1.value;
              setState(() {
                advnNameclass = new AdvNameClass(
                  DATA['cId'],
                  DATA['cdate'],
                  DATA['chead'],
                  DATA['ctitle'],
                  DATA['cdepart'],
                  DATA['cregion'],
                  DATA['cphone'],
                  DATA['cprice'],
                  DATA['cdetail'],
                  DATA['cpublished'],
                  DATA['curi'],
                  DATA['curilist'],
                  DATA['cagekm'],
                  DATA['csale'],
                  ////
                  DATA['cauto'],
                  DATA['coil'],
                  DATA['cNew'],
                  DATA['cno'],
                  DATA['cdep11'],
                  DATA['cdep22'],
                  DATA['cname'],
                  DATA['cType'],

                  DATA['carrange'],
                  DATA['consoome'],
                  DATA['cmodel'],
                  DATA['rating'],
                  DATA['custRate'],
                );
                _imageUrls = DATA['curilist']
                    .replaceAll(" ", "")
                    .replaceAll("[", "")
                    .replaceAll("]", "")
                    .split(",");
                Future.delayed(Duration(seconds: 0), () async {
                  for (var i = 0; i < 1; i++) {
                    var request =
                        await HttpClient().getUrl(Uri.parse(_imageUrls[i]));
                    var response = await request.close();
                    Uint8List bytes =
                        await consolidateHttpClientResponseBytes(response);
                    map["${advnNameclass.ctitle}$i.jpg"] = bytes;
                  }
                });
              });
            });
          })
        : setState(() {
            _userId = user.uid;
            userdatabaseReference
                .child(
                  _userId,
                )
                .child("cName")
                .once()
                .then((DataSnapshot snapshot) {
              setState(() {
                if (snapshot.value != null) {
                  setState(() {
                    _username = snapshot.value;
                  });
                }
              });
            });

            //  Toast.show(_userId,context,duration: Toast.LENGTH_SHORT,gravity:  Toast.BOTTOM);

            final databaseFav =
                FirebaseDatabase.instance.reference().child("userFavourits");
            databaseFav
                .child(_userId)
                .child(widget.cId + widget.cDateID)
                .child("FavChecked")
                .once()
                .then((DataSnapshot snapshot5) {
              setState(() {
                if (snapshot5.value != null) {
                  setState(() {
                    favcheck = snapshot5.value;
                  });
                } else {
                  setState(() {
                    favcheck = false;
                  });
                }
              });
            });
            /////////////////////////////////////
            final advdatabaseReference =
                FirebaseDatabase.instance.reference().child("advdata");
            print("kkkkkkkkkkkk${widget.cId}////${widget.cDateID}");

            advdatabaseReference
                .child(widget.cId)
                .child(widget.cDateID)
                .once()
                .then((DataSnapshot data1) {
              var DATA = data1.value;
              setState(() {
                advnNameclass = new AdvNameClass(
                  DATA['cId'],
                  DATA['cdate'],
                  DATA['chead'],
                  DATA['ctitle'],
                  DATA['cdepart'],
                  DATA['cregion'],
                  DATA['cphone'],
                  DATA['cprice'],
                  DATA['cdetail'],
                  DATA['cpublished'],
                  DATA['curi'],
                  DATA['curilist'],
                  DATA['cagekm'],
                  DATA['csale'],
                  ////
                  DATA['cauto'],
                  DATA['coil'],
                  DATA['cNew'],
                  DATA['cno'],
                  DATA['cdep11'],
                  DATA['cdep22'],
                  DATA['cname'],
                  DATA['cType'],

                  DATA['carrange'],
                  DATA['consoome'],
                  DATA['cmodel'],
                  DATA['rating'],
                  DATA['custRate'],
                );
                _imageUrls = DATA['curilist']
                    .replaceAll(" ", "")
                    .replaceAll("[", "")
                    .replaceAll("]", "")
                    .split(",");
                Future.delayed(Duration(seconds: 0), () async {
                  for (var i = 0; i < _imageUrls.length; i++) {
                    var request =
                        await HttpClient().getUrl(Uri.parse(_imageUrls[i]));
                    var response = await request.close();
                    Uint8List bytes =
                        await consolidateHttpClientResponseBytes(response);
                    map["${advnNameclass.ctitle}$i.jpg"] = bytes;
                  }
                });
              });
            });
          }));
  }

  final ReferenceNotice =
      FirebaseDatabase.instance.reference().child('Reports');

  @override
  Widget build(BuildContext context) {
//    Widget loadingIndicator = _load
//        ? new Container(
//      child: SpinKitCircle(color: Colors.blue),
//    )
//        : new Container();
    TextStyle textStyle = Theme.of(context).textTheme.subtitle;

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Container(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 65.0,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 20,
                      height: 20,
                      alignment: Alignment.bottomLeft,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff171732),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0.0, -43.0),
                  child:
                      // Adobe XD layer: 'logoBox' (shape)
                      Center(
                    child: Container(
                      width: 166.0,
                      height: 60.0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          'بوابة نجران',
                          style: TextStyle(
                            fontFamily: 'Estedad-Black',
                            fontSize: 40,
                            color: const Color(0xffffffff),
                            height: 0.7471466064453125,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        color: const Color(0xff171732),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Form(
              key: _formKey1,
              child: Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding * 20,
                      bottom: _minimumPadding * 0,
                      right: _minimumPadding * 0,
                      left: _minimumPadding * 0),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      //getImageAsset(),

                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                      ProfilePhoto(_imageUrls)));
                        },
                        child: Container(
                            //color: Colors.grey[200],
                            width: 300,
                            height: 200,
                            child: _imageUrls == null
                                ? SpinKitThreeBounce(
                                    size: 35,
                                    color: const Color(0xff171732),
                                  )
                                : Stack(
                                    children: <Widget>[
                                      Swiper(
                                        loop: false,
                                        duration: 1000,
                                        autoplay: false,
                                        autoplayDelay: 15000,
                                        itemCount: _imageUrls.length,
                                        pagination: new SwiperPagination(
                                          margin: new EdgeInsets.fromLTRB(
                                              0.0, 0.0, 0.0, 0.0),
                                          builder:
                                              new DotSwiperPaginationBuilder(
                                                  color: Colors.grey,
                                                  activeColor:
                                                      const Color(0xff171732),
                                                  size: 8.0,
                                                  activeSize: 8.0),
                                        ),
                                        control: new SwiperControl(),
                                        viewportFraction: 1,
                                        scale: 0.1,
                                        outer: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Image.network(
                                              _imageUrls[index],
                                              fit: BoxFit.fill, loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent
                                                          loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return SpinKitThreeBounce(
                                              color: const Color(0xff171732),
                                              size: 35,
                                            );
                                          });
                                        },
                                      ),
                                    ],
                                  )),
                      ),
                      Card(
                        shape: new RoundedRectangleBorder(
                            side: new BorderSide(
                                color: Colors.grey[400], width: 3.0),
                            borderRadius: BorderRadius.circular(10.0)),
                        //borderOnForeground: true,
                        elevation: 10.0,
                        margin: EdgeInsets.only(right: 1, left: 1, bottom: 2),
                        child: Container(
                            height: 120,
                            color: Colors.grey[300],
                            padding: EdgeInsets.all(0),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                new Positioned(
                                    top: 30,
                                    left: 15,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          setState(() {
                                            favcheck =
                                                !favcheck; //boolean value
                                          });
                                          if (_userId == null) {
                                            //if(favchecklist[position] ){
                                            Toast.show(
                                                "ابشر .. سجل دخول الاول طال عمرك",
                                                context,
                                                duration: Toast.LENGTH_LONG,
                                                gravity: Toast.BOTTOM);
                                            setState(() {
                                              favcheck = false; //boolean value
                                            });
                                          } else {
                                            DateTime now = DateTime.now();
                                            String b = now.month.toString();
                                            if (b.length < 2) {
                                              b = "0" + b;
                                            }
                                            String c = now.day.toString();
                                            if (c.length < 2) {
                                              c = "0" + c;
                                            }
                                            String d = now.hour.toString();
                                            if (d.length < 2) {
                                              d = "0" + d;
                                            }
                                            String e = now.minute.toString();
                                            if (e.length < 2) {
                                              e = "0" + e;
                                            }
                                            String f = now.second.toString();
                                            if (f.length < 2) {
                                              f = "0" + f;
                                            }

//////////*******************************************
                                            final databasealarm =
                                                FirebaseDatabase.instance
                                                    .reference()
                                                    .child("Alarm")
                                                    .child(widget.cId);
                                            final databaseFav = FirebaseDatabase
                                                .instance
                                                .reference()
                                                .child("userFavourits")
                                                .child(_userId)
                                                .child(widget.cId +
                                                    widget.cDateID);
                                            if (favcheck) {
                                              if (_userId != widget.cId) {
                                                databaseFav.set({
                                                  'cId': widget.cId,
                                                  'FavChecked': favcheck,
                                                  'cDateID': widget.cDateID,
                                                });
                                                databasealarm.push().set({
                                                  'alarmid':
                                                      databasealarm.push().key,
                                                  'wid': widget.cId,
                                                  'Name': _username == null
                                                      ? "لا يوجد اسم"
                                                      : _username,
                                                  'cType': "love",
                                                  'chead': widget.cDateID,
                                                  'cDate':
                                                      "${now.year.toString()}-${b}-${c} ${d}:${e}:${f}",
                                                  'arrange': int.parse(
                                                      "${now.year.toString()}${b}${c}${d}${e}${f}")
                                                });
                                                if (widget.cName == null) {
                                                  widget.cName =
                                                      " اسم غير معلوم ";
                                                  Toast.show(
                                                      "${widget.cName} تم اضافتة فى المفضلة  ",
                                                      context,
                                                      duration:
                                                          Toast.LENGTH_LONG,
                                                      gravity: Toast.BOTTOM);
                                                }
                                              }
                                            } else {
                                              if (_userId != widget.cId) {
                                                databaseFav.set(null);
                                                Toast.show(
                                                    "تم الحذف فى المفضلة",
                                                    context,
                                                    duration:
                                                        Toast.LENGTH_SHORT,
                                                    gravity: Toast.BOTTOM);
                                              }
                                            }

                                            ////////////////*************************
                                          }
                                        });
                                      },
                                      child: Container(
                                        //decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0, bottom: 10.0),
                                          child:
                                              favcheck && _userId != widget.cId
                                                  ? Icon(
                                                      Icons.favorite,
                                                      size: 40.0,
                                                      color: Colors.red,
                                                    )
////
                                                  : Column(
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.favorite_border,
                                                          size: 40.0,
                                                          color: Colors.red,
                                                        ),
                                                      ],
                                                    ),
                                        ),
                                      ),
                                    )),
                                Positioned(
                                  top: 0,
                                  right: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: advnNameclass == null
                                        ? Text("")
                                        : Text(
                                            "${advnNameclass.ctitle}",
                                            textDirection: TextDirection.rtl,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                color: const Color(0xff171732),
//                                                fontFamily: 'Gamja Flower',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.0,
                                                fontStyle: FontStyle.normal),
                                          ),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  left: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: <Widget>[
                                        advnNameclass == null
                                            ? Text("")
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: advnNameclass.cprice ==
                                                        null
                                                    ? Container
                                                    : Text(
                                                        "السعر: ${advnNameclass.cprice}",
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            color: const Color(
                                                                0xff171732),
                                                            fontSize: 15.0,
//                                                      fontFamily: 'Gamja Flower',
                                                            fontStyle: FontStyle
                                                                .normal),
                                                      ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 85,
                                  right: 130,
                                  child: InkWell(
                                    onTap: () {
                                      if (_userId != null) {
                                        if (_userId != widget.cId) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UserRatingPage(
                                                        [""],
                                                        widget.cDateID,
                                                        Rating(widget.cId, "",
                                                            ""))),
                                          );
                                        } else {
                                          null;
                                        }
                                      } else {
                                        Toast.show(
                                            "ابشر ولكن سجل في بوابة نجران اولاً",
                                            context,
                                            duration: Toast.LENGTH_LONG,
                                            gravity: Toast.BOTTOM);
                                      }
                                    },
                                    child: _userId != widget.cId
                                        ? Container(
                                            width: 80,
                                            height: 30,
                                            child: SmoothStarRating(
                                                isReadOnly: true,
//                                      allowHalfRating: false,
//                                      onRated: (v) {
////                                        rating = v;
//                                        setState(() {});
//                                      },
                                                starCount: 5,
                                                rating: widget.cRate,
                                                //setting value
                                                size: 15.0,
                                                color: Colors.amber,
                                                borderColor: Colors.grey,
                                                spacing: 0.0),
                                          )
                                        : Container(),
                                  ),
                                ),
                                Positioned(
                                  top: 20,
                                  right: 5,
                                  child: _userId != widget.cId
                                      ? Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: InkWell(
                                            onTap: () {
                                              if (_userId != null) {
                                                _userId != widget.cId
                                                    ? Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                profileUserVeiw(
                                                                    widget.cId,
                                                                    widget
                                                                        .cRate,
                                                                    widget
                                                                        .cName,
                                                                    cPhone)),
                                                      )
                                                    : null;
                                              } else {
                                                Toast.show(
                                                    "ابشر ولكن سجل في بوابة نجران اولاً",
                                                    context,
                                                    duration: Toast.LENGTH_LONG,
                                                    gravity: Toast.BOTTOM);
                                              }

                                              print(
                                                  "@@@@@@@@@@@@@@@@@@@@@@@${widget.cId}+${widget.cRate}+${widget.cName}+${cPhone}");
                                            },
                                            child: Row(
                                              children: <Widget>[
                                                advnNameclass == null
                                                    ? Text("")
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: widget.cName ==
                                                                null
                                                            ? Text(
                                                                "اسم غير معلوم")
                                                            : Text(
                                                                "المالك: ${widget.cName}",
                                                                textDirection:
                                                                    TextDirection
                                                                        .rtl,
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style:
                                                                    TextStyle(
                                                                        fontSize:
                                                                            17.0,
                                                                        color: Colors
                                                                            .blue,
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        /*const Color(
                                                      0xff171732)*/
//                                                      fontFamily:
//                                                          'Gamja Flower',
                                                                        fontStyle:
                                                                            FontStyle.normal),
                                                              )),
                                                Icon(
                                                  Icons.person,
                                                  color:
                                                      const Color(0xff171732),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ),
                                Positioned(
                                  top: 45,
                                  right: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: <Widget>[
                                        advnNameclass == null
                                            ? Text("")
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Text(
                                                  "الحي: ${advnNameclass.cregion}",
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: const Color(
                                                          0xff171732),
//                                                      fontFamily:
//                                                          'Gamja Flower',
                                                      fontStyle:
                                                          FontStyle.normal),
                                                ),
                                              ),
                                        Icon(
                                          Icons.location_on,
                                          color: const Color(0xff171732),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 70,
                                  left: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: IconButton(
                                      icon: Icon(Icons.share, size: 35),
                                      tooltip: 'مشاركة الاعلان',
                                      onPressed: () async {
                                        // Toast.show(
                                        //     "ابشر .. برجاء الانتظار",
                                        //     context,
                                        //     duration: Toast.LENGTH_LONG,
                                        //     gravity: Toast.BOTTOM);
                                        try {
                                          // Map map = Map<String, Uint8List>();
                                          // // List<int> aaa;
                                          // for (var i = 0; i <  _imageUrls.length; i++) {
                                          //   var request = await HttpClient().getUrl(Uri.parse(_imageUrls[i]));
                                          //   var response = await request.close();
                                          //   Uint8List bytes = await consolidateHttpClientResponseBytes(response);
                                          //   map["${advnNameclass.ctitle}$i.jpg"] = bytes;
                                          //   //  aaa.add(bytes);
                                          // }
                                          await Share.files(
                                              advnNameclass.ctitle,
                                              map,
                                              'image/jpg',
                                              text: "آعجبني هذا الاعلان في بوابة نجران:" +
                                                  "\n\n" +
                                                  advnNameclass.ctitle +
                                                  "\n\n" +
                                                  advnNameclass.cdetail +
                                                  "\n\n" +
                                                  "للتواصل " +
                                                  cPhone +
                                                  "\n\n" +
                                                  "حمل التطبيق الان:" +
                                                  "\n\n" +
                                                  "الاندرويد:" +
                                                  "\n\n" +
                                                  "https://play.google.com/store/apps/details?id=com.arabdevelopers.souqnagran" +
                                                  "\n\n" +
                                                  "الايفون:" +
                                                  "\n\n" +
                                                  "https://apps.apple.com/sa/app/id1528216979?l=ar");
                                        } catch (e) {
                                          print('error: $e');
                                        }

                                        //   _imageUrls.length;
                                        //    var result = { for (var v in _imageUrls) v[0]: v[ _imageUrls.length-1] };
                                        // _imageUrls.asMap().forEach((index, value) async {
                                        //   var request = await HttpClient().getUrl(Uri.parse(advnNameclass.curi));
                                        //   var response = await request.close();
                                        //   Uint8List bytes = await consolidateHttpClientResponseBytes(response);
                                        // });

                                        // await Share.file(advnNameclass.ctitle, '${advnNameclass.ctitle}.jpg', aaa, 'image/jpg', text: '${advnNameclass.cdetail}');
                                      },
                                    ),
                                  ),
                                ),
                                /**    Positioned(
                                    top: 50,
                                    left: 5,
                                    child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                    children: <Widget>[
                                    advnNameclass==null?Text(""):
                                    Padding(
                                    padding: const EdgeInsets.only(top:8.0),
                                    child: Text(advnNameclass.cregion,
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: 'Gamja Flower',
                                    fontStyle: FontStyle.normal),
                                    ),
                                    ),
                                    Icon(
                                    Icons.location_on,
                                    color: Colors.grey,
                                    ),
                                    ],
                                    ),
                                    ),
                                    ),**/
                                Positioned(
                                  top: 70,
                                  right: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: const Color(0xff171732),
                                      ),
                                      width: 100,
                                      child: InkWell(
                                          onTap: () {
                                            _showMyDialog();
                                          },
                                          child: Center(
                                              child: Text(
                                            "إظهار التفاصيل",
                                            style: TextStyle(color: Colors.red),
                                          ))),
//                                      child: advnNameclass == null
//                                          ? Text("")
//                                          : Padding(
//                                              padding: const EdgeInsets.only(
//                                                  top: 8.0),
//                                              child: AutoSizeText(
//                                                "${advnNameclass.cdetail}",
//                                                textDirection:
//                                                    TextDirection.rtl,
//                                                minFontSize: 12,
//                                                maxLines: 3,
//                                                maxFontSize: 20,
//                                                textAlign: TextAlign.right,
//                                                style: TextStyle(
//                                                    fontSize: 15.0,
////                                                          fontFamily:
////                                                              'Gamja Flower',
//                                                    fontStyle:
//                                                        FontStyle.normal),
//                                              ),
//                                            ),
                                    ),
                                  ),
                                  /** Icon(
                                      Icons.calendar_today,
                                      color: Colors.grey,
                                      ),**/
                                ),
                              ],
                            )),
                      ),
                      _userId == widget.cId
                          ? Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                width:
                                    300 /*MediaQuery.of(context).size.width*/,
                                height: 40,
                                child: new RaisedButton(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text("تمديد الاعلان"),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textColor: Colors.white,
                                  color: const Color(0xff171732),
                                  onPressed: () {
                                    if (presscheck) {
                                      Toast.show(
                                          "لا يمكن التمديد الان. حاول مرة اخرى...",
                                          context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.BOTTOM);
                                    } else {
                                      presscheck = true;
                                      DateTime startdate =
                                          DateTime.parse(advnNameclass.cdate);
                                      var newdate =
                                          startdate.add(new Duration(days: 60));
                                      // var permissiondate =
                                      // startdate.add(new Duration(days: -20));
                                      DateTime now = DateTime.now();
                                      String b = newdate.month.toString();
                                      if (b.length < 2) {
                                        b = "0" + b;
                                      }
                                      String c = newdate.day.toString();
                                      if (c.length < 2) {
                                        c = "0" + c;
                                      }
                                      String d = newdate.hour.toString();
                                      if (d.length < 2) {
                                        d = "0" + d;
                                      }
                                      String e = newdate.minute.toString();
                                      if (e.length < 2) {
                                        e = "0" + e;
                                      }
                                      String date1 =
                                          '${newdate.year}-${b}-${c} ${d}:${e}:00';
                                      if (_userId == null) {
                                        Toast.show(
                                            "ابشر .. سجل دخول الاول طال عمرك",
                                            context,
                                            duration: Toast.LENGTH_LONG,
                                            gravity: Toast.BOTTOM);
                                      } else {
                                        // if (now.isAfter(permissiondate)) {
                                        final advdatabaseReference =
                                            FirebaseDatabase.instance
                                                .reference()
                                                .child("advdata");
                                        advdatabaseReference
                                            .child(widget.cId)
                                            .child(widget.cDateID)
                                            .update({
                                          "cdate": date1,
                                        }).then((_) {
                                          setState(() {
                                            advnNameclass.cdate = date1;
                                            showNotification(
                                                date1,
                                                advnNameclass.ctitle,
                                                advnNameclass.cId,
                                                advnNameclass.chead,
                                                _username);
                                            Toast.show("$date1تم التمديد الى ",
                                                context,
                                                duration: Toast.LENGTH_LONG,
                                                gravity: Toast.BOTTOM);
                                          });
                                        });
                                        // } else {
                                        //   Toast.show(
                                        //       "يمكنك التجديد بعد مرور 10 ايام من موعد التجديد الاول او انتظار الاشعار",
                                        //       context,
                                        //       duration: Toast.LENGTH_LONG,
                                        //       gravity: Toast.BOTTOM);
                                        // }
                                      }
                                    }
                                  },
//
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0)),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                width:
                                    300 /*MediaQuery.of(context).size.width*/,
                                height: 40,
                                child: new RaisedButton(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text("الطلب"),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textColor: Colors.white,
                                  color: const Color(0xff171732),
                                  onPressed: () {
                                    if (_userId == null) {
                                      Toast.show(
                                          "ابشر .. سجل دخول الاول طال عمرك",
                                          context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.BOTTOM);
                                    } else {
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                new ChatPage(
                                                    name: widget.cName,
                                                    uid: widget.cId)),
                                      );
                                    }
                                  },
//
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0)),
                                ),
                              ),
                            ),
                      SizedBox(
                        height: 2 * _minimumPadding,
                        width: _minimumPadding,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Container(
                              width: 150 /*MediaQuery.of(context).size.width*/,
                              height: 40,
                              child: new RaisedButton(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    new Text(
                                      "تواصل عبر الدردشة",
                                      style: TextStyle(
                                        color: const Color(0xff171732),
                                        fontSize: 10,
                                      ),
                                    ),
                                    Icon(
                                      Icons.mail_outline,
                                      color: const Color(0xff171732),
                                    ),
                                  ],
                                ),
                                textColor: const Color(0xff171732),
                                color: Colors.grey[400],
                                onPressed: () {
                                  if (_userId == null) {
                                    Toast.show(
                                        "ابشر .. سجل دخول الاول طال عمرك",
                                        context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM);
                                  } else {
                                    if (_userId != widget.cId) {
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                new ChatPage(
                                                    name: widget.cName,
                                                    uid: widget.cId)),
                                      );
                                    }
                                  }
                                },
//
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Container(
                              width: 150 /*MediaQuery.of(context).size.width*/,
                              height: 40,
                              child: new RaisedButton(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    new Text(
                                      "تواصل برقم الجوال",
                                      style: TextStyle(
                                        color: const Color(0xff171732),
                                        fontSize: 10,
                                      ),
                                    ),
                                    Icon(
                                      Icons.phone,
                                      color: const Color(0xff171732),
                                    ),
                                  ],
                                ),
                                textColor: const Color(0xff171732),
                                color: Colors.grey[400],
                                onPressed: () {
                                  if (_userId == null) {
                                    Toast.show(
                                        "ابشر .. سجل دخول الاول طال عمرك",
                                        context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM);
                                  } else {
                                    if (advnNameclass.cphone != null) {
                                      cPhone == advnNameclass.cphone;
                                      _makePhoneCall(
                                          'tel:${advnNameclass.cphone}');
                                    } else {
                                      Toast.show("حاول تاني طال عمرك", context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.BOTTOM);
                                    }
                                  }
                                },
//
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0)),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              DateTime now = DateTime.now();
                              // String date1 ='${now.year}-${now.month}-${now.day}';// ${now.hour}:${now.minute}:00.000';
                              String date =
                                  '${now.year}-${now.month}-${now.day}-${now.hour}-${now.minute}-00';
                              if (_userId != null) {
                                if (_userId != widget.cId) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        new CupertinoAlertDialog(
                                      title: new Text("تنبية"),
                                      content: new Text(
                                          "تبغي ترسل بلاغ إساءة لهذا الاعلان"),
                                      actions: [
                                        CupertinoDialogAction(
                                            isDefaultAction: false,
                                            child: new FlatButton(
                                              onPressed: () {
                                                ReferenceNotice.child(
                                                        widget.cDateID)
                                                    .push()
                                                    .child(widget.cId)
                                                    .set({
                                                  'NameUserForAdv':
                                                      widget.cName,
                                                  'NameUserForReport':
                                                      _username == null
                                                          ? "لا يوجد اسم"
                                                          : _username,
                                                  'DateAdv': widget.cDateID,
                                                  'DateReport': date,
                                                  'UserIdForAdv': widget.cId,
                                                  'UserIdForReport': _userId,
                                                }).then((_) {
                                                  print(
                                                      "##############$_username");
                                                  Toast.show(
                                                      "ابشر ... سيتم مراجعة بلاغك",
                                                      context,
                                                      duration:
                                                          Toast.LENGTH_LONG,
                                                      gravity: Toast.BOTTOM);
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                              child: Text("موافق"),
                                            )),
                                        CupertinoDialogAction(
                                            isDefaultAction: false,
                                            child: new FlatButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text("إلغاء"),
                                            )),
                                      ],
                                    ),
                                  );
                                }
                              } else {
                                Toast.show(
                                    "ابشر .. سجل دخول الاول طال عمرك", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 2 * _minimumPadding,
                        width: _minimumPadding,
                      ),
                      Card(
                        shape: new RoundedRectangleBorder(
                            side: new BorderSide(
                                color: Colors.grey[400], width: 3.0),
                            borderRadius: BorderRadius.circular(10.0)),
                        //borderOnForeground: true,
                        elevation: 10.0,
                        margin: EdgeInsets.only(right: 1, left: 1, bottom: 2),
                        child: Container(
                            height: 330,
                            color: Colors.grey[300],
                            padding: EdgeInsets.all(0),
                            child: Column(
                              //alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                Flexible(
                                    child: Center(
                                  child: commentlist.length == 0
                                      ? new Text(
                                          "لا يوجد تعليق",
                                        )
                                      : new ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          controller: _controller,
                                          // reverse: true,
                                          itemCount: commentlist.length,
                                          itemBuilder:
                                              (BuildContext ctxt, int index) {
                                            return InkWell(
                                              child: _firebasedata(
                                                index,
                                                commentlist.length,
                                                commentlist[index].cId,
                                                commentlist[index].cuserid,
                                                commentlist[index].cdate,
                                                commentlist[index].cheaddate,
                                                commentlist[index].ccoment,
                                                commentlist[index].cname,
                                                commentlist[index].cadvID,
                                              ),
//                                                    onTap: () {
//                                                      if(_userId==commentlist[index].cuserid){
//                                                        FirebaseDatabase.instance
//                                                            .reference()
//                                                            .child("commentsdata")
//                                                            .child(widget.cId)
//                                                            .child(commentlist[index].cheaddate)
//                                                            .remove()
//                                                            .whenComplete(() {
//
//                                                          setState(() {
//                                                            commentlist.removeAt(index);
//                                                          });
//                                                          Toast.show("تم حذف التعليق", context,
//                                                              duration: Toast.LENGTH_SHORT,
//                                                              gravity: Toast.BOTTOM);
//                                                        });
//                                                      }
//                                                      else{
//                                                        Toast.show("ليس تعليقك", context,
//                                                            duration: Toast.LENGTH_SHORT,
//                                                            gravity: Toast.BOTTOM);
//                                                      }
//                                                    }
                                            );
                                          }),
                                )),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 250,
                                        height: 60,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Card(
                                            elevation: 0.0,
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: TextFormField(
                                                textAlign: TextAlign.right,
                                                keyboardType:
                                                    TextInputType.text,
                                                textDirection:
                                                    TextDirection.rtl,
                                                controller: _commentController,
                                                validator: (String value) {
                                                  if ((value.isEmpty)) {
                                                    return 'ابشر .. لكن اكتب تعليق الاول طال عمرك';
                                                  }
                                                },
                                                onChanged: (value) {},
                                                //  controller: controller,
                                                decoration: InputDecoration(
                                                    errorStyle: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 15.0),
                                                    labelText: "التعليق",
                                                    // hintText: "التعليق",
//                                prefixIcon: Icon(
//                                  Icons.phone_iphone,
//                                  color: Colors.pinkAccent,
//                                ),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.0)))),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          if (_userId != null) {
                                            if (_formKey1.currentState
                                                .validate()) {
                                              try {
                                                final result =
                                                    await InternetAddress
                                                        .lookup('google.com');
                                                if (result.isNotEmpty &&
                                                    result[0]
                                                        .rawAddress
                                                        .isNotEmpty) {
                                                  createRecord(_username);
                                                }
                                              } on SocketException catch (_) {
                                                //  print('not connected');
                                                Toast.show(
                                                    "انت غير متصل بشبكة إنترنت طال عمرك",
                                                    context,
                                                    duration: Toast.LENGTH_LONG,
                                                    gravity: Toast.BOTTOM);
                                              }
//                                                setState(() {
//                                                  _load2 = true;
//                                                });
                                            }
                                          } else {
                                            Toast.show(
                                                "سجل دخول الاول طال عمرك",
                                                context,
                                                duration: Toast.LENGTH_LONG,
                                                gravity: Toast.BOTTOM);
                                          }
                                        },
                                        child: Icon(
                                          Icons.send,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ],
                  )),
            ),
//            new Align(
//              child: loadingIndicator,
//              alignment: FractionalOffset.center,
//            ),
          ],
        ),
      ),
    );
  }

  void createRecord(_username) {
    DateTime now = DateTime.now();
    String b = now.month.toString();
    if (b.length < 2) {
      b = "0" + b;
    }
    String c = now.day.toString();
    if (c.length < 2) {
      c = "0" + c;
    }
    String d = now.hour.toString();
    if (d.length < 2) {
      d = "0" + d;
    }
    String e = now.minute.toString();
    if (e.length < 2) {
      e = "0" + e;
    }
    String f = now.second.toString();
    if (f.length < 2) {
      f = "0" + f;
    }
    final databasealarm =
        FirebaseDatabase.instance.reference().child("Alarm").child(widget.cId);
    setState(() {
      DateTime now = DateTime.now();
      // String date1 ='${now.year}-${now.month}-${now.day}';// ${now.hour}:${now.minute}:00.000';
      String date =
          '${now.year}-${now.month}-${now.day}-${now.hour}-${now.minute}-00';
      final commentbaseReference =
          FirebaseDatabase.instance.reference().child("commentsdata");
      commentbaseReference
          .child(widget.cId)
          .child(widget.cDateID)
          .child(_userId + date)
          .set({
        'cId': widget.cId,
        'cuserid': _userId,
        'cdate': now.toString(),
        'cheaddate': _userId + date,
        'ccoment': _commentController.text,
        'cname': _username == null ? "لا يوجد اسم" : _username,
        'cadvID': widget.cDateID,
        'arrange': ServerValue.timestamp,
      }).whenComplete(() {
        Toast.show("ارسالنا تعليقك طال عمرك", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        CommentClass commentclass = new CommentClass(
            widget.cId,
            _userId,
            now.toString(),
            _userId + date,
            _commentController.text,
            _username == null ? "لا يوجد اسم" : _username,
            widget.cDateID,
            0);
        setState(() {
          commentlist.insert(0, commentclass);
          _commentController.text = "";
          //      var cursor = (5/commentlist.length)* _controller.position.maxScrollExtent;//specific item
          // _controller.animateTo(
          //   // NEW
          //   _controller.position.maxScrollExtent * 2, // NEW
          //   duration: const Duration(milliseconds: 500), // NEW
          //   curve: Curves.ease, // NEW
          // );
        });
        databasealarm.push().set({
          'alarmid': databasealarm.push().key,
          'wid': widget.cId,
          'Name': _username == null ? "لا يوجد اسم" : _username,
          'cType': "comment",
          'chead': widget.cDateID,
          'cDate': "${now.year.toString()}-${b}-${c} ${d}:${e}:${f}",
          'arrange': int.parse("${now.year.toString()}${b}${c}${d}${e}${f}")
        }).whenComplete(() {
          Toast.show("تم التعليق بنجاح", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
//          CommentClass commentclass =
//          new CommentClass(
//            widget.cId,
//            _userId,
//            now.toString(),
//            _userId+date,
//            _commentController.text,
//            _username==null?"لا يوجد اسم":_username,
//            widget.cDateID,
//
//          );
//          setState(() {
//            commentlist.add(commentclass);
//            _commentController.text="";
//            //      var cursor = (5/commentlist.length)* _controller.position.maxScrollExtent;//specific item
//
//            _controller.animateTo(                                      // NEW
//              _controller.position.maxScrollExtent*1.1,                     // NEW
//              duration: const Duration(milliseconds: 500),                    // NEW
//              curve: Curves.ease,                                             // NEW
//            );
//          });
        });
        //  _controller.animateTo(0.0,curve: Curves.easeInOut, duration: Duration(seconds: 1));
      }).catchError((e) {
        Toast.show(e, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        setState(() {
          //  _load2 = false;
        });
      });
    });
//    final userdatabaseReference =
//      FirebaseDatabase.instance.reference().child("userdata");
//      userdatabaseReference
//          .child(_userId)
//          .child("cName")
//          .once()
//          .then((DataSnapshot snapshot5) {
//        setState(() {
//          if (snapshot5.value != null) {
//
//          }
//        });
//      });
    // })
    // );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'تفاصيل الاعلان',
            textAlign: TextAlign.right,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '${advnNameclass.cdetail}',
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                  textAlign: TextAlign.right,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: .2,
                  color: Colors.grey,
                ),
                advnNameclass.coil != ""
                    ? Text('${advnNameclass.coil}',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 20, color: Colors.blue))
                    : Text(""),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: .2,
                  color: Colors.grey,
                ),
                advnNameclass.cNew != ""
                    ? Text('${advnNameclass.cNew}',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 20, color: Colors.blue))
                    : Text(""),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: .2,
                    color: advnNameclass.cmodel != ""
                        ? Colors.grey
                        : Colors.white),
                advnNameclass.cmodel != null
                    ? Text('${advnNameclass.cmodel}',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 20, color: Colors.blue))
                    : Text(""),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: .2,
                    color: advnNameclass.cmodel != null
                        ? Colors.grey
                        : Colors.white),
                advnNameclass.cauto != ""
                    ? Text('${advnNameclass.cauto}',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 20, color: Colors.blue))
                    : Text(""),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: .2,
                    color: advnNameclass.cauto != null
                        ? Colors.grey
                        : Colors.white),
                advnNameclass.csale != ""
                    ? Text('${advnNameclass.csale}',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 20, color: Colors.blue))
                    : Text(""),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: .2,
                    color:
                        advnNameclass.csale != "" ? Colors.grey : Colors.white),
                advnNameclass.cagekm != "0"
                    ? Text('كم${advnNameclass.cagekm}',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 20, color: Colors.blue))
                    : Text(""),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: .2,
                    color: advnNameclass.cagekm != "0"
                        ? Colors.grey
                        : Colors.white),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'تم',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _firebasedata(
    index,
    length,
    cId,
    cuserid,
    cdate,
    cheaddate,
    ccoment,
    cname,
    cadvID,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
      child: Card(
        shape: new RoundedRectangleBorder(
            side: new BorderSide(color: Colors.grey, width: 3.0),
            borderRadius: BorderRadius.circular(10.0)),
        //borderOnForeground: true,
        elevation: 10.0,
        margin: EdgeInsets.all(1),
        child: InkWell(
          onTap: () {
            _userId != commentlist[index].cuserid
                ? Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new ChatPage(
                            name: commentlist[index].cname,
                            uid: commentlist[index].cuserid)),
                  )
                : null;
          },
          child: Container(
              padding: EdgeInsets.all(8),
              child: Container(
                  width: 350,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _userId == commentlist[index].cuserid
                          ? FlatButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      new CupertinoAlertDialog(
                                    title: new Text("تنبية"),
                                    content: new Text("تبغي تحذف تعليقك؟"),
                                    actions: [
                                      CupertinoDialogAction(
                                          isDefaultAction: false,
                                          child: new FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                print("kkkkkkkkkkkk");
                                                if (_userId ==
                                                    commentlist[index]
                                                        .cuserid) {
                                                  FirebaseDatabase.instance
                                                      .reference()
                                                      .child("commentsdata")
                                                      .child(widget.cId)
                                                      .child(cadvID)
                                                      .child(commentlist[index]
                                                          .cheaddate)
                                                      .remove()
                                                      .whenComplete(() {
                                                    setState(() {
                                                      commentlist
                                                          .removeAt(index);
                                                    });
                                                    Toast.show(
                                                        "حذفنا تعليقك طال عمرك",
                                                        context,
                                                        duration:
                                                            Toast.LENGTH_SHORT,
                                                        gravity: Toast.BOTTOM);
                                                  }).then((value) =>
                                                          Navigator.pop(
                                                              context));
                                                } else {
                                                  Toast.show(
                                                      "هذا مو تعليقك طال عمرك",
                                                      context,
                                                      duration:
                                                          Toast.LENGTH_SHORT,
                                                      gravity: Toast.BOTTOM);
                                                }
                                              });
                                            },
                                            child: Text("موافق"),
                                          )),
                                      CupertinoDialogAction(
                                          isDefaultAction: false,
                                          child: new FlatButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text("إلغاء"),
                                          )),
                                    ],
                                  ),
                                );
                                //ResetPasswordDialog();
                                //FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
                              },
                              child: Icon(
                                Icons.more_vert,
                                color: Colors.black,
                              ),
                            )
                          : Container(),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 200,
                                  child: Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        cname,
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 15,
                                        ),
                                        textDirection: TextDirection.rtl,
                                      )),
                                ),
                                Icon(
                                  Icons.person,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 2.0, right: 0.0, bottom: 2, left: 2.0),
                            child: Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  ccoment,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ))),
        ),
      ),
    );
  }

  void getUserName() async {
    FirebaseUser usr = await _firebaseAuth.currentUser();
    if (usr != null) {
      userdatabaseReference = FirebaseDatabase.instance;
      userdatabaseReference
          .reference()
          .child("userdata")
          .child(usr.uid)
          .once()
          .then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
//        var result = values['rating'].reduce((a, b) => a + b) / values.length;

        if (values != null) {
          /*HelperFunc.showToast("hii ${values['cName']}", Colors.red);
          */
          setState(() {
            cPhone = values['cPhone'].toString();
            print("###########///////$cPhone");
//            _userId = usr.uid;
          });
        }
      });
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
