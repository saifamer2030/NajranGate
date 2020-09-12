import 'dart:ui';

import 'package:flutter/material.dart';

class PrivcyPolicy extends StatefulWidget {
  @override
  __PrivcyPolicyState createState() => __PrivcyPolicyState();
}

@override
class __PrivcyPolicyState extends State<PrivcyPolicy> {
  final double _minimumPadding = 5.0;
  bool isSwitched = false;
  bool isSwitched2 = false;
  bool isSwitched3 = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
//      backgroundColor: const Color(0xffffffff),
      body:// Adobe XD layer: '30' (shape)
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/images/ic_background.png"),
            fit: BoxFit.cover,
          ),
        ),
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
                      alignment: Alignment.bottomLeft,
                      width: 20,
                      height: 20,
                      child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                    ),
                  ),
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
            Padding(
              padding: EdgeInsets.only(
                  top: _minimumPadding * 23,
                  bottom: _minimumPadding * 2,
                  right: _minimumPadding * 2,
                  left: _minimumPadding * 2),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'سياسة الخصوصية',
                        style: TextStyle(
                          fontFamily: 'DroidArabicKufi-Bold',
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
                          Icons.lock,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width:  MediaQuery.of(context).size.width,
                    height:  MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/images/image_privcy_policy.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

    ); }
}