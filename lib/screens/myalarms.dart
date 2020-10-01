
import 'package:NajranGate/screens/ModelsForChating/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:NajranGate/classes/AlarmaClass.dart';
import 'package:NajranGate/screens/advprofile.dart';
import 'package:NajranGate/screens/loginphone.dart';
import 'package:toast/toast.dart';

import 'loginmail.dart';

class MyAlarms extends StatefulWidget {
  List<String> regionlist = [];
  MyAlarms(this.regionlist);
  @override
  _MyAlarmsState createState() => _MyAlarmsState();
}

class _MyAlarmsState extends State<MyAlarms> {
  List<AlarmaClass> alarmlist = [];

  //List<String> namelist = [];
  bool _load = false;
  String _userId;
  final databasealarm = FirebaseDatabase.instance.reference().child("Alarm");

  @override
  void initState() {
    super.initState();
    setState(() {
      _load = true;
    });

    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(
        builder: (context) => SignIn(widget.regionlist), maintainState: false))

        : setState(() {
            _userId = user.uid;
            final databasealarm =
                FirebaseDatabase.instance.reference().child("Alarm");
//            orderdatabaseReference.once().then((DataSnapshot data) {
//              var uuId = data.value.keys;

            //   for (var id in uuId) {
            databasealarm.child(_userId).once().then((DataSnapshot data1) {
              var DATA = data1.value;
              var keys = data1.value.keys;
              alarmlist.clear();
              //  namelist.clear();
              for (var individualkey in keys) {
                AlarmaClass alarmaalass = new AlarmaClass(
                  DATA[individualkey]['alarmid'],
                  DATA[individualkey]['wid'],
                  DATA[individualkey]['Name'],
                  DATA[individualkey]['cType'],
                  DATA[individualkey]['cDate'],
                  DATA[individualkey]['chead'],
                  DATA[individualkey]['arrange'],
                );
                setState(() {
                  alarmlist.add(alarmaalass);
                  setState(() {
                    print("size of list : 5");
                    alarmlist.sort((alarm1, alarm2) =>
                        alarm2.arrange.compareTo(alarm1.arrange));
                  });
                });
                print("kkkkkkk${DATA[individualkey]['arrange']}");
              }
            });
            // }
            //  });
          }));
  }

  final double _minimumPadding = 5.0;
  var _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load
        ? new Container(
            child: SpinKitCircle(color: const Color(0xff171732),),
          )
        : new Container();
    TextStyle textStyle = Theme.of(context).textTheme.subtitle;
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      floatingActionButton: Container(
        height: 30.0,
        width: 30.0,
        child: FittedBox(
          child: FloatingActionButton(
            heroTag: "unique5",

            onPressed: () {
              _controller.animateTo(0.0,
                  curve: Curves.easeInOut, duration: Duration(seconds: 1));
            },
            backgroundColor: Colors.white,
            elevation: 20.0,
            child: Icon(
              Icons.arrow_drop_up,
              size: 50,
              color: const Color(0xff171732),
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width:  MediaQuery.of(context).size.width,
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
                    child:
                    Padding(
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
//          Padding(
//            padding: const EdgeInsets.only(top: 100),
//            child:
            Expanded(
                child: Center(
              child: alarmlist.length == 0
                  ? new Center(
                     child:Text("لا يوجد إشعارات")

                    // loadingIndicator,
                    )
                  : new ListView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: _controller,
                      // reverse: true,
                      itemCount: alarmlist.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return InkWell(
                          child: _firebasedata(
                            index,
                            alarmlist.length,
                            alarmlist[index].alarmid,
                            alarmlist[index].wid,
                            alarmlist[index].Name,
                            alarmlist[index].cType,
                            alarmlist[index].cDate,
                            alarmlist[index].chead,
                            alarmlist[index].arrange,
                          ),
                        );
                      }),
            )),
         // ),
        ],
      ),
    );
  }

  Widget _firebasedata(
    int position,
    int length,
    String alarmid,
    String wid,
    String Name,
    String cType,
    String cDate,
        String chead,
    int arrange,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.grey[300],
        shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0)),
        //borderOnForeground: true,
        elevation: 10.0,
        margin: EdgeInsets.only(right: 1, left: 1, bottom: 2),
        child: InkWell(
          onTap: () {
            setState(() {
              if (cType == "chat") {
                final userdatabaseReference =
                    FirebaseDatabase.instance.reference().child("userdata");
                userdatabaseReference
                    .child(wid)
                    .child("cName")
                    .once()
                    .then((DataSnapshot snapshot5) {
                  setState(() {
                    if (snapshot5.value != null) {
                      setState(() {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) => new ChatPage(
                                  name: snapshot5.value, uid: wid)),
                        );
                      });
                    }
                  });
                });
              }else if(cType == "love" || cType == "Comment"){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AdvProlile(wid, chead,Name,0.0)));

              }
            });
          },
          child: Container(
            height: 70,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: cType == "love"
                          ? new Icon(
                              Icons.favorite,
                              color: Colors.black,
                            )
                          : new Icon(
                              Icons.mail_outline,
                              color: Colors.black,
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: cType == "love"
                                    ? Text(
                                        " $Name منحك اعجاب ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          //    fontWeight: FontWeight.bold
                                        ),
                                      )
                                    : Text(
                                        " رسالة جديدة من $Name",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          //    fontWeight: FontWeight.bold
                                        ),
                                      ),
                              ),

                            ],
                          ),
                          new Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
