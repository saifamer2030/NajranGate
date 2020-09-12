import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:NajranGate/classes/DepartmentClass.dart';
import 'package:NajranGate/screens/splash.dart';

import 'addAdsForCars1.dart';

class Pledge extends StatefulWidget {
  String department;
  int index;
  List<String> departlist1 = [];
  List<String> regionlist = [];

  Pledge(this.department, this.departlist1, this.index, this.regionlist);

  @override
  __pledgeState createState() => __pledgeState();
}

@override
class __pledgeState extends State<Pledge> {
  final double _minimumPadding = 5.0;
  bool isSwitched = false;
  bool isSwitched2 = false;
  bool isSwitched3 = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    print("####################${widget.department}###################");
  }

  @override
  Widget build(BuildContext context) {
    String data = "غير موافق";
    return Scaffold(
      key: _scaffoldKey,
//      backgroundColor: const Color(0xffffffff),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/images/ic_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(children: <Widget>[
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
          Form(
              child: Center(
            child: Padding(
              padding: EdgeInsets.only(
                  top: _minimumPadding * 20,
                  left: _minimumPadding,
                  right: _minimumPadding),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Center(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              " بِسْمِ اللَّـهِ الرَّحْمَـٰنِ الرَّحِيمِ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 20.0,
                              ),
                              child: Text(
                                  "وَأَوْفُواْ بِعَهْدِ ٱللَّهِ إِذَا عَٰهَدتُّمْ وَلَا تَنقُضُواْ"
                                  " ٱلْأَيْمَٰنَ بَعْدَ تَوْكِيدِهَا وَقَدْ جَعَلْتُمُ ٱللَّهَ عَلَيْكُمْ كَفِيلًا ۚإِنَّ ٱللَّهَ يَعْلَمُ مَا تَفْعَلُون\nَ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            Text(" صِّدٍَّقٍَّ آلِّلِّهِّ آلِّعََّظِِّيِّمِِّ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: .5,
                              color: Colors.grey,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10.0,
                              ),
                              child: Text(
                                  "اتعهد واقسم بالله انا المعلن ان ادفع عمولة التطبيق وهي ١٪ من قيمة الخدمة في حالة إتمامها عن طريق التطبيق او بسبب التطبيق وان هذة العمولة هي امانة في ذمتي. ملاحظة عمولة التطبيق هي علي المعلن ولا تبرأ ذمة المعلن من العمولة إلا في حالة دفعها",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            Center(
                              child: Switch(
                                value: isSwitched,
                                onChanged: (value) {
                                  setState(() {
                                    isSwitched = value;
                                    print(isSwitched);
                                  });
                                },
                                activeTrackColor: const Color(0xff171732),
                                activeColor: const Color(0xff1D1D55),
                              ),
                            ),
                            Container(
                              width: 100.0,
                              height: 30.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: const Color(0xffeaeaea),
                              ),
                              child: Center(
                                  child: Text(
                                isSwitched ? "موافق" : data,
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: .5,
                              color: Colors.grey,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10.0,
                              ),
                              child: Text(
                                  "اتعهد انا المعلن ان جميع المعلومات التي اذكرها بالاعلان صحيحة وفي القسم الصحيح واتعهد بان الصور التي سوف يتم عرضها هي صور حديثة لنفس الخدمة وليست لخدمة اخري مشابهة.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            Center(
                              child: Switch(
                                value: isSwitched2,
                                onChanged: (value) {
                                  setState(() {
                                    isSwitched2 = value;
                                    print(isSwitched2);
                                  });
                                },
                                activeTrackColor: const Color(0xff171732),
                                activeColor: const Color(0xff1D1D55),
                              ),
                            ),
                            Container(
                              width: 100.0,
                              height: 30.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: const Color(0xffeaeaea),
                              ),
                              child: Center(
                                  child: Text(
                                isSwitched2 ? "موافق" : data,
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: .5,
                              color: Colors.grey,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10.0,
                              ),
                              child: Text(
                                  "اتعهد انا المعلن بان اقوم بدفع العمولة خلال اقل من ١٠ ايام من تاريخ استلام كامل سعر الخدمة.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            Center(
                              child: Switch(
                                value: isSwitched3,
                                onChanged: (value) {
                                  setState(() {
                                    isSwitched3 = value;
                                    print(isSwitched3);
                                  });
                                },
                                activeTrackColor: const Color(0xff171732),
                                activeColor: const Color(0xff1D1D55),
                              ),
                            ),
                            Container(
                              width: 100.0,
                              height: 30.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: const Color(0xffeaeaea),
                              ),
                              child: Center(
                                  child: Text(
                                isSwitched3 ? "موافق" : data,
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: .5,
                              color: Colors.grey,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: new RaisedButton(
                                child: new Text("التالي"),
                                textColor: Colors.white,
                                color: const Color(0xff171732),
                                onPressed: () {
                                  if (isSwitched && isSwitched2 && isSwitched3) {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) => AddAdsForCars1(
                                                widget.department,
                                                widget.departlist1,
                                                widget.index,
                                                widget.regionlist)));

//                                  print("go_______");
//                                  print("${widget.car}");
                                  } else {
                                    return showInSnackBar(
                                        "وافق علي التعهد طال عمرك");
                                  }
                                },
                                // _counterButtonPress,

                                //#48B2E1
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ))
        ]),
      ),
    );
  }

  /**Future<void> _counterButtonPress() async {
      if (isSwitched && isSwitched2 && isSwitched3) {
      Navigator.push(
      context, new MaterialPageRoute(builder: (context) => AddAdsForCars()));

      print("go_______");
      print("${widget.department}");
      //      setState(() {
      //        Navigator.of(context).pushNamed('/addnewads');
      //      });
      } else {
      return showInSnackBar(
      "وافق علي التعهد طال عمرك");
      }
      }**/

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        style: TextStyle(color: const Color(0xffffffff)),
      ),
    ));
  }
}
