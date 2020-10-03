import 'package:NajranGate/screens/ModelsForChating/chat.dart';
import 'package:NajranGate/screens/UserRatingForUser/RatingClass.dart';
import 'package:NajranGate/screens/UserRatingForUser/UserRatingPageForUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class profileUserVeiw extends StatefulWidget {
  String cId;
  String username;
  var cRate;
  var cphone;

  profileUserVeiw(this.cId, this.cRate, this.username, this.cphone);

  @override
  _profileUserVeiwState createState() => new _profileUserVeiwState();
}

class _profileUserVeiwState extends State<profileUserVeiw> {
  FirebaseAuth _firebaseAuth;
  String ImageUrl = "";
  String _userId;
  String ranking = "";

  @override
  void initState() {
    super.initState();
    print("!!!!!!!!!!!!!!!!${widget.cphone}");
    _firebaseAuth = FirebaseAuth.instance;
    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? null
        : setState(() {
            _userId = user.uid;
            final userdatabaseReference =
                FirebaseDatabase.instance.reference().child("userdata");
            userdatabaseReference
                .child(widget.cId)
                .child("ranking")
                .once()
                .then((DataSnapshot snapshot5) {
              setState(() {
                if (snapshot5.value != null) {
                  setState(() {
                    ranking = snapshot5.value;
                    print("############$ranking####################");
                  });
                } else {
                  setState(() {
                    ranking = "عضو عادي";
                  });
                }
              });
            });

            ////////////////////////
          }));

    //ranking
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Container(
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
            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Container(
                width: width,
                height: height,
                child: Center(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      // UserName
                      Text(
                        '${widget.username}',
                        style: TextStyle(
                          fontFamily: 'Estedad-Black',
                          fontSize: 40,
                          color: Colors.black,
                          height: 0.7471466064453125,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      // RatingUser
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserRatingPageForUser(
                                      [""], RatingForUser(widget.cId, "", ""))),
                            );
                          },
                          child: Center(
                            child: SmoothStarRating(
                                isReadOnly: true,
                                starCount: 5,
                                rating: widget.cRate,
                                //setting value
                                size: 30.0,
                                color: Colors.amber,
                                borderColor: Colors.grey,
                                spacing: 0.0),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("["),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: Text(
                                  "$ranking",
                                  style: TextStyle(
                                      color: Colors.green,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                              Text("]"),
                              Text("حالة العضو"),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            top: 100, right: 10, left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 150 /*MediaQuery.of(context).size.width*/,
                              height: 40,
                              child: new RaisedButton(
                                child: Row(
//                              mainAxisAlignment:
//                              MainAxisAlignment.spaceEvenly,
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
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new ChatPage(
                                                name: widget.username,
                                                uid: widget.cId)),
                                  );
                                },

//
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0)),
                              ),
                            ),
                            Container(
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
                                  if (widget.cphone != null) {
                                    _makePhoneCall('tel:${widget.cphone}');
                                  } else {
                                    Toast.show("حاول تاني طال عمرك", context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM);
                                  }
                                },

//
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
