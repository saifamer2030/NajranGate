import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:NajranGate/FragmentSouqNajran.dart';

import 'RatingClass.dart';

class UserRatingPageForUser extends StatefulWidget {
  List<String> regionlist = [];
  final RatingForUser rating;

  UserRatingPageForUser(this.regionlist, this.rating);

  @override
  _UserRatingPageForUserState createState() => new _UserRatingPageForUserState();
}

final mDatabase = FirebaseDatabase.instance.reference();

final ratingReference = FirebaseDatabase.instance.reference().child('Rating');
final ratingAvrageReference =
    FirebaseDatabase.instance.reference().child('userdata');

class _UserRatingPageForUserState extends State<UserRatingPageForUser> {
  List<RatingForUser> itemsRate;
  var Rate = 0.0;
  var _averageRating, _totalRate;
  int _totalCust;
  FirebaseAuth _firebaseAuth;
  Query _query;

  // تعريف الايتم المراد ادخال قيم فيها
  TextEditingController _rateController;
  TextEditingController _commentController;

/////////////// لتهئة الداتا بيز وعرض البيانات فور فتح التطبيق ///////////
  @override
  void initState() {
    super.initState();
    _query = mDatabase.child('Rating');
    _firebaseAuth = FirebaseAuth.instance;
    getRatingAvrage();
    // ربط الايتم بالقيم
    _rateController = new TextEditingController(text: widget.rating.rate);
    _commentController = new TextEditingController(text: widget.rating.comment);
  }

  void getRatingAvrage() async {
    // FirebaseUser usr = await _firebaseAuth.currentUser();

    mDatabase
        .child("userdata")
        .child(widget.rating.id)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;

      ///var result = values['Rate'] / values.length;
      //print(result);
      setState(() {
        _totalRate = values['rating'];
        _totalCust = values['custRate'];
      });
//        if (values != null) {
//          /*HelperFunc.showToast("hii ${values['cName']}", Colors.red);
//          */
//          setState(() {
//            _cName = values['cName'].toString();
//          });
//        }
    });
  }

  /// هذا الفانكشن لغلق الداتا بيز ///
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff171732),
      ),
      backgroundColor: const Color(0xffffffff),
      body: Container(
        child: Stack(
          children: <Widget>[

            Form(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[

                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Center(
                              child: Text(
                            "تقييمك يدعم تحسين الخدمة",
                            style: TextStyle(fontSize: 20.0),
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: RatingBar(
                              initialRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);

                                setState(() {
                                  Rate = rating;
                                });
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: Text("${Rate}"),
                          ),
                        ),
                         Container(
                      height: 170,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, right: 10.0, left: 10.0, bottom: 10.0),
                            child: Card(
                              elevation: 0.0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextFormField(
                                  controller: _commentController,
                                  onChanged: (value) {},
                                  //  controller: controller,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                      contentPadding:
                                      new EdgeInsets.symmetric(
                                          vertical: 20.0),

                                      labelText: "اكتب تعليق هنا",
                                      hintText: "اكتب تعليق هنا",
                                      prefixIcon: Icon(Icons.comment),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(10.0)))),
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        width: width,
                        child: RaisedButton(
                          child: new Text("إرسال التقييم",
                              style: TextStyle(fontSize: 15.0)),
                          textColor: Colors.white,
                          color: const Color(0xff171732),
                          onPressed: () {
                            getUser(com: _commentController.text);
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(15.0)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getUser({String com}) async {
    if (_totalRate == null && _totalCust == null) {
      setState(() {
        _totalRate = "0.0";
        _totalCust = 0;
      });
    }

    FirebaseUser usr = await _firebaseAuth.currentUser();
    if (usr != null && com != "" && Rate != 0.0) {
      ratingReference.child(widget.rating.id).child(usr.uid).set({
        'Comment': _commentController.text,
        'Rate': Rate,
      });
      print('total rate $_totalRate');
      ratingAvrageReference
          .child(widget.rating.id)
          .update({
        'rating': (double.parse(_totalRate) + Rate.round()).toString(),
        'custRate': _totalCust + 1
      }).then((_) {
        Fluttertoast.showToast(
            msg: "تم إرسال تقييمك بنجاح",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            fontSize: 15.0,
            textColor: Colors.white,
            backgroundColor: const Color(0xff171732));
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) =>
                  new FragmentSouq1(widget.regionlist)),
        );
      });
    } else {
      Fluttertoast.showToast(
          msg: "الرجاء كتابة تعليق",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          fontSize: 15.0,
          textColor: Colors.white,
          backgroundColor: const Color(0xff171732));
    }
  }

//  Widget _starRating() {
//    double _calculateAverage() {
//      // calculate average, may have latency issues once we scale
//      // try cloud functions
//      if (widget.rating.rate != null) {
//        double _calc = 0;
//        for (int i = 0; i < widget.rating.rate.length; i++) {
//          _calc = _calc + widget.rating.rate[i]['rating'];
//        }
//        return _averageRating = _calc / widget.rating.rate.length;
//      } else {
//        return 0;
//      }
//    }
//  }
}
