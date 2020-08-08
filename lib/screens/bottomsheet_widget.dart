import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:souqnagran/classes/DepartmentClass.dart';
import 'package:souqnagran/screens/personal_page.dart';
import 'package:souqnagran/screens/pledge.dart';
import 'package:firebase_database/firebase_database.dart';

class BottomSheetWidget extends StatefulWidget {
  List<String> regionlist = [];
  BottomSheetWidget(this.regionlist);

  //const BottomSheetWidget({Key key}) : super(key: key);

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

String _car = "قسم السيارات",
    _building = "قسم العقارات",
    _elect = "قسم والاجهزة والالكترونيات",
    _anim = "قسم المواشي والطيور والحيوانات",
    _shapiat = "قسم الشعبيات",
    _family = "قسم الاسر المنتجة",
    _service = "قسم خدمات نجران";

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  List<DepartmentClass> departlist = [];
  List<String> departlist1 = [];
  var _controller = ScrollController();
  FirebaseAuth _firebaseAuth;
  String _cName = "";
  String _cMobile = "";
  String _cType = "";

  String _userId;

  @override
  void initState() {
    super.initState();

    _firebaseAuth = FirebaseAuth.instance;
    FirebaseAuth.instance.currentUser().then((user) =>
    user == null
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

    final departmentsdatabaseReference =
    FirebaseDatabase.instance.reference().child("Departments");
    departmentsdatabaseReference.once().then((DataSnapshot snapshot) {
      var KEYS = snapshot.value.keys;
      var DATA = snapshot.value;
      //Toast.show("${snapshot.value.keys}",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);

      departlist.clear();
      departlist1.clear();

      for (var individualkey in KEYS) {
        // if (!blockList.contains(individualkey) &&user.uid != individualkey) {
        DepartmentClass departmentclass = new DepartmentClass(
          DATA[individualkey]['id'],
          DATA[individualkey]['title'],
          DATA[individualkey]['subtitle'],
          DATA[individualkey]['uri'],
            Colors.white,
            false,
          DATA[individualkey]['arrange'],

        );

        setState(() {
          if(DATA[individualkey]['arrange']==null) departmentclass = new DepartmentClass(
            DATA[individualkey]['id'],
            DATA[individualkey]['title'],
            DATA[individualkey]['subtitle'],
            DATA[individualkey]['uri'],
            const Color(0xff8C8C96),
            false,
            100,
          );
          departlist.add(departmentclass);
          departlist1.add(DATA[individualkey]['title']);
          setState(() {
         //   print("size of list : 5");
            departlist.sort((depart1, depart2) =>
                depart1.arrange.compareTo(depart2.arrange));
          });
        });
        // }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
      height: 450,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 450,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10, color: Colors.grey[300], spreadRadius: 5)
                ]),
            child: Expanded(
                child: Center(
                  child: departlist.length == 0
                      ? new Text("برجاء الإنتظار")
                      : new ListView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: _controller,
                      // reverse: true,
                      itemCount: departlist.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return InkWell(
                          child: _firebasedata(
                            index,
                            departlist.length,
                            departlist[index].id,
                            departlist[index].title,
                            departlist[index].subtitle,
                            departlist[index].uri,
                          ),
                        );
                      }),
                )),


          )
        ],
      ),
    );
  }

  Widget _firebasedata(index,
      length,
      cId,
      ctitle,
      csubtitle,
      curi,) {
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
            if (_cType != null && _cMobile != null && _cName != null) {

              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) =>
                          Pledge(ctitle, departlist1, index,widget.regionlist)));
            }else{
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                new CupertinoAlertDialog(
                  title: new Text("تنبية"),
                  content:
                  new Text("نبغاك تكمل بيانات ملفك الشخصي"),
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
                          child: Text("موافق"),
                        )),
                  ],
                ),
              );

            }
          },


          child: Card(
        child: ListTile(
        leading: Container(
          width: 50,
          child: new Image.network(
            curi,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          ctitle,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: const Color(0xff171732),
          ),
        ),
        subtitle: Text(
          csubtitle,
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 10),
        ),
//                    trailing: Icon(Icons.more_vert),
      ),
    ),)
    ,
    )
    ,
    );
  }
}
class DecoratedTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        decoration:
            InputDecoration.collapsed(hintText: 'Enter your reference number'),
      ),
    );
  }
}

//class SheetButton extends StatefulWidget {
//  SheetButton({Key key}) : super(key: key);
//
//  _SheetButtonState createState() => _SheetButtonState();
//}
//
//class _SheetButtonState extends State<SheetButton> {
//  bool checkingFlight = false;
//  bool success = false;
//
//  @override
//  Widget build(BuildContext context) {
//    return !checkingFlight
//        ? MaterialButton(
//            color: const Color(0xff171732),
//            onPressed: () async {
//              setState(() {
//                checkingFlight = true;
//              });
//
//              await Future.delayed(Duration(seconds: 1));
//
//              setState(() {
//                success = true;
//              });
//
//              await Future.delayed(Duration(milliseconds: 500));
//
//              Navigator.pop(context);
//            },
//            child: Text(
//              'إنهاء التعديل',
//              style: TextStyle(
//                color: Colors.white,
//              ),
//            ),
//          )
//        : !success
//            ? CircularProgressIndicator()
//            : Icon(
//                Icons.check,size: 100,
//                color: Colors.green,
//              );
//  }
//}
