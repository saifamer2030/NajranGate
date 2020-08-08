import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:souqnagran/screens/CommissionNajran.dart';
import 'package:souqnagran/screens/ModelsForChating/home.dart';
import 'package:souqnagran/screens/SmsForUser/SmsForUserClass.dart';
import 'package:souqnagran/screens/SmsForUser/SmsForUserPage.dart';
import 'package:souqnagran/screens/personal_page.dart';
import 'package:souqnagran/screens/privcy_policy.dart';
import 'package:souqnagran/screens/signin.dart';

import 'advprofile.dart';
import 'myadvertisement.dart';

class MoreSouqNajran extends StatefulWidget {
  List<String> regionlist = [];

  MoreSouqNajran(this.regionlist);

  @override
  _MoreSouqNajranState createState() => _MoreSouqNajranState();
}

class _MoreSouqNajranState extends State<MoreSouqNajran> {
  final double _minimumPadding = 5.0;
  String _userId;
  FirebaseAuth _firebaseAuth;
  String _cName = "";
  String _cMobile = "";
  String _cType = "";

  @override
  void initState() {
    super.initState();

    _firebaseAuth = FirebaseAuth.instance;
    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? null
        : setState(() {
            _userId = user.uid;
            final userdatabaseReference =
                FirebaseDatabase.instance.reference().child("userdata");
            userdatabaseReference
                .child(_userId)
                .child("cPhone")
                .once()
                .then((DataSnapshot snapshot5) {
              setState(() {
                _cMobile = snapshot5.value;
              });
            });
            //////////////////////////
            userdatabaseReference
                .child(_userId)
                .child("cName")
                .once()
                .then((DataSnapshot snapshot5) {
              setState(() {
                _cName = snapshot5.value;
              });
            });

            ////////////////////////
            userdatabaseReference
                .child(_userId)
                .child("cType")
                .once()
                .then((DataSnapshot snapshot5) {
              setState(() {
                setState(() {
                  _cType = snapshot5.value;
                });
              });
            });
          }));

//    FirebaseAuth.instance.currentUser().then((user) => user == null
//        ? null
//        : setState(() {
//            _userId = user.uid;
//          }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 65.0,
                decoration: BoxDecoration(
                  color: const Color(0xff171732),
                ),
              ),
              Transform.translate(
                offset: Offset(0.0, -42.0),
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
            child: Padding(
              padding: EdgeInsets.only(
                  top: _minimumPadding * 23,
                  bottom: _minimumPadding * 2,
                  right: _minimumPadding * 2,
                  left: _minimumPadding * 2),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'إعدادات عامة',
                              style: TextStyle(
//                                fontFamily: 'Estedad-Black',
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff171732),
                                height: 1.0800000190734864,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            Container(
                              width: 40.0,
                              height: 40.0,
                              child: new Icon(
                                Icons.settings,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                          if(_userId == null){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SignIn(widget.regionlist)));
                          }else{
                            if (_userId != null &&
                                _cType != null ) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MyAdvertisement(widget.regionlist)));
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                new CupertinoAlertDialog(
                                  title: new Text(
                                    "تنبية",
                                    style: TextStyle(
//                                      fontFamily: 'Estedad-Black',
                                    ),
                                  ),
                                  content: new Text(
                                    "نبغاك تخبرنا عن نوع حسابك",
                                    style: TextStyle(
//                                      fontFamily: 'Estedad-Black',
                                    ),
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                        isDefaultAction: false,
                                        child: new FlatButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        PersonalPage(widget.regionlist)));
                                          },
                                          child: Text(
                                            "موافق",
                                            style: TextStyle(
//                                              fontFamily: 'Estedad-Black',
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              );
                            }
                          }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                Icons.keyboard_arrow_left,
                                color: const Color(0xff171732),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    'إعلاناتي',
                                    style: TextStyle(
//                                      fontFamily: 'Estedad-Black',
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xff171732),
                                      height: 1.2307692307692308,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),

                                  // Adobe XD layer: 'world-wide-web-icon…' (shape)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          alignment: Alignment.center,
                                          image: AssetImage(
                                              "assets/images/ic_ads.png"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: .2,
                          color: Colors.grey,
                        ),
                        InkWell(
                          onTap: () {
                            if (_userId == null) {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          SignIn(widget.regionlist)));
                            } else {
                              if (_cType != null) {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => HomePage()));
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      new CupertinoAlertDialog(
                                    title: new Text(
                                      "تنبية",
                                      style: TextStyle(
//                                      fontFamily: 'Estedad-Black',
                                          ),
                                    ),
                                    content:
                                    new Text(
                                      "نبغاك تخبرنا عن نوع حسابك",
                                      style: TextStyle(
//                                      fontFamily: 'Estedad-Black',
                                          ),
                                    ),
                                    actions: [
                                      CupertinoDialogAction(
                                          isDefaultAction: false,
                                          child: new FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context, false);
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (context) =>
                                                          PersonalPage(widget.regionlist)));
                                            },
                                            child: Text(
                                              "موافق",
                                              style: TextStyle(
//                                              fontFamily: 'Estedad-Black',
                                                  ),
                                            ),
                                          )),
                                    ],
                                  ),
                                );
                              }
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                Icons.keyboard_arrow_left,
                                color: const Color(0xff171732),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    'محادثاتي',
                                    style: TextStyle(
//                                      fontFamily: 'Estedad-Black',
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xff171732),
                                      height: 1.2307692307692308,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),

                                  // Adobe XD layer: 'world-wide-web-icon…' (shape)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),

                                    child: new Icon(
                                      Icons.email,
                                      color: Colors.grey,
                                    ),

//                                    child:  new Icon(
//                                      Icons.chat,
//                                      color: Colors.grey,
//
//                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: .2,
                          color: Colors.grey,
                        ),
                        InkWell(
                          onTap: () {
                            if (_userId != null) {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => PersonalPage(widget.regionlist)));
                            } else {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          SignIn(widget.regionlist)));
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                Icons.keyboard_arrow_left,
                                color: const Color(0xff171732),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    'الصفحه الشخصية',
                                    style: TextStyle(
//                                      fontFamily: 'Estedad-Black',
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xff171732),
                                      height: 1.2307692307692308,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),

                                  // Adobe XD layer: 'world-wide-web-icon…' (shape)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: new Icon(
                                      Icons.account_circle,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: .2,
                          color: Colors.grey,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => CommissionNajran()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                Icons.keyboard_arrow_left,
                                color: const Color(0xff171732),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    'عمولة بوابة نجران',
                                    style: TextStyle(
//                                      fontFamily: 'Estedad-Black',
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xff171732),
                                      height: 1.2307692307692308,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),

                                  // Adobe XD layer: 'world-wide-web-icon…' (shape)
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Icon(
                                        Icons.monetization_on,
                                        color: Colors.grey,
                                      ) // Adobe XD layer: 'terms' (shape)

                                      ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: .2,
                          color: Colors.grey,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => PrivcyPolicy()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                Icons.keyboard_arrow_left,
                                color: const Color(0xff171732),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    'سياسه الخصوصيه',
                                    style: TextStyle(
//                                      fontFamily: 'Estedad-Black',
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xff171732),
                                      height: 1.2307692307692308,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),

                                  // Adobe XD layer: 'world-wide-web-icon…' (shape)
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Icon(
                                        Icons.lock,
                                        color: Colors.grey,
                                      ) // Adobe XD layer: 'terms' (shape)
                                      ),
                                ],
                              ),
                            ],
                          ),
                        ),
//                        Container(
//                          width: MediaQuery.of(context).size.width,
//                          height: .2,
//                          color: Colors.grey,
//                        ),
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.end,
//                          children: <Widget>[
//                            Text(
//                              'تقييم التطبيق',
//                              style: TextStyle(
////                                fontFamily: 'Estedad-Black',
//                                fontSize: 13,
//                                fontWeight: FontWeight.bold,
//                                color: const Color(0xff171732),
//                                height: 1.2307692307692308,
//                              ),
//                              textAlign: TextAlign.right,
//                            ),
//
//                            // Adobe XD layer: 'world-wide-web-icon…' (shape)
//                            Padding(
//                                padding: const EdgeInsets.all(8.0),
//                                child: new Icon(
//                                  Icons.star,
//                                  color: Colors.grey,
//                                ) // Adobe XD layer: 'terms' (shape)
//                                ),
//                          ],
//                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: .2,
                          color: Colors.grey,
                        ),
                        InkWell(
                          onTap: () {
                            if(_userId == null){
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => SignIn(widget.regionlist)));
                            }else{
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => SmsForUserPage(
                                          SmsForUser(_userId, _cName, "", "",
                                              _cMobile, ""))));

                            }


                                                     },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                'الشكاوي',
                                style: TextStyle(
//                                  fontFamily: 'Estedad-Black',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff171732),
                                  height: 1.2307692307692308,
                                ),
                                textAlign: TextAlign.right,
                              ),

                              // Adobe XD layer: 'world-wide-web-icon…' (shape)
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Icon(
                                    Icons.report,
                                    color: Colors.grey,
                                  ) // Adobe XD layer: 'terms' (shape)
                                  ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: .2,
                          color: Colors.grey,
                        ),
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.end,
//                          children: <Widget>[
//                            Text(
//                              'نبذة عن التطبيق',
//                              style: TextStyle(
////                                fontFamily: 'Estedad-Black',
//                                fontSize: 13,
//                                fontWeight: FontWeight.bold,
//                                color: const Color(0xff171732),
//                                height: 1.2307692307692308,
//                              ),
//                              textAlign: TextAlign.right,
//                            ),
//
//                            // Adobe XD layer: 'world-wide-web-icon…' (shape)
//                            Padding(
//                                padding: const EdgeInsets.all(8.0),
//                                child: new Icon(
//                                  Icons.smartphone,
//                                  color: Colors.grey,
//                                ) // Adobe XD layer: 'terms' (shape)
//                                ),
//                          ],
//                        ),
//                        Container(
//                          width: MediaQuery.of(context).size.width,
//                          height: .2,
//                          color: Colors.grey,
//                        ),
                        InkWell(
                          onTap: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SignIn(widget.regionlist)));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
////                            InkWell(
////                              onTap: () {
////                                print("kkkkkkkkkkkclick");
//                                FirebaseAuth.instance.signOut();
//                                Navigator.of(context).pushNamed('/login');
////
////                              },
////
////                            ),
                              _userId == null
                                  ? Text(
                                      'تسجيل الدخول',
                                      style: TextStyle(
//                                        fontFamily: 'Estedad-Black',
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xff171732),
                                        height: 1.2307692307692308,
                                      ),
                                      textAlign: TextAlign.right,
                                    )
                                  : Text(
                                      'تسجيل خروج',
                                      style: TextStyle(
//                                        fontFamily: 'Estedad-Black',
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xff171732),
                                        height: 1.2307692307692308,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),

                              // Adobe XD layer: 'world-wide-web-icon…' (shape)
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Icon(
                                    Icons.power_settings_new,
                                    color: Colors.grey,
                                  ) // Adobe XD layer: 'terms' (shape)
                                  ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: .2,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
