
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:souqnagran/classes/AdvClass.dart';
import 'package:souqnagran/classes/AdvNameClass.dart';
import 'package:souqnagran/classes/DepartmentClass.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:souqnagran/classes/UserDataClass.dart';
import 'package:souqnagran/screens/signin.dart';

import 'package:toast/toast.dart';

import 'EditAdsForCars.dart';
import 'advprofile.dart';

class MyAdvertisement extends StatefulWidget {
  List<String> regionlist = [];
  MyAdvertisement(this.regionlist);
  @override
  _MyAdvertisementState createState() => _MyAdvertisementState();
}

class _MyAdvertisementState extends State<MyAdvertisement> {
  List<AdvNameClass> advlist = [];
  bool _load = false;
  String _userId;
  FirebaseDatabase userdatabaseReference;
  FirebaseDatabase advdatabaseReference;
  //=
  //FirebaseDatabase.instance.reference().child("advdata");


  List<DepartmentClass> departlist = [];
  List<String> departlist1 = [];
  List<String> _imageUrls;

  @override
  void initState() {
    super.initState();
//    FirebaseDatabase database;
//    database = FirebaseDatabase.instance;
//    database.setPersistenceEnabled(true);
//    database.setPersistenceCacheSizeBytes(10000000);

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
        DepartmentClass departmentclass =
        new DepartmentClass(
          DATA[individualkey]['id'],
          DATA[individualkey]['title'],
          DATA[individualkey]['subtitle'],
          DATA[individualkey]['uri'],
            Colors.white,
            false,100

        );

        setState(() {
          departlist.add(departmentclass);
          departlist1.add(DATA[individualkey]['title']);
        });
        // }
      }
    });
    setState(() {
      _load = true;
    });

    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(
        builder: (context) => SignIn(widget.regionlist), maintainState: false))

        :
    setState(() {
            _userId = user.uid;
            //    FirebaseDatabase database;
            advdatabaseReference = FirebaseDatabase.instance;
            advdatabaseReference.setPersistenceEnabled(true);
            advdatabaseReference.setPersistenceCacheSizeBytes(10000000);

      // advdatabaseReference =FirebaseDatabase.instance.reference().child("advdata");

            advdatabaseReference.reference().child("advdata")
                    .child(_userId)
                    .once()
                    .then((DataSnapshot data1) {
                  var DATA = data1.value;
                  var keys = data1.value.keys;
                  advlist.clear();
                  for (var individualkey in keys) {
                    AdvClass advnameclass = new AdvClass(
                      DATA[individualkey]['cId'],
                      DATA[individualkey]['cdate'],
                      DATA[individualkey]['chead'],
                      DATA[individualkey]['ctitle'],
                      DATA[individualkey]['cdepart'],
                      DATA[individualkey]['cregion'],
                      DATA[individualkey]['cphone'],
                      DATA[individualkey]['cprice'],
                      DATA[individualkey]['cdetail'],
                      DATA[individualkey]['cpublished'],
                      DATA[individualkey]['curi'],
                      DATA[individualkey]['curilist'],
                      DATA[individualkey]['cagekm'],
                      DATA[individualkey]['csale'],
                      DATA[individualkey]['cauto'],
                      DATA[individualkey]['coil'],
                      DATA[individualkey]['cNew'],
                      DATA[individualkey]['cno'],
                      DATA[individualkey]['cdep11'],
                      DATA[individualkey]['cdep22'],
                      DATA[individualkey]['carrange'],
                      DATA[individualkey]['consoome'],
                    );
                    ///
                    userdatabaseReference = FirebaseDatabase.instance;
                    userdatabaseReference.setPersistenceEnabled(true);
                    userdatabaseReference.setPersistenceCacheSizeBytes(10000000);

//                    final userdatabaseReference =
//                    FirebaseDatabase.instance.reference().child("userdata");
                    userdatabaseReference.reference().child("userdata")
                        .child(DATA[individualkey]['cId'])
                        .once()
                        .then((DataSnapshot data1) {
                      var DATA5 = data1.value;
                      setState(() {
                        UserDataClass userdata = new UserDataClass(
                          DATA5['cName'],
                          DATA5['cType'],
                        );

                        setState(() {
                          AdvNameClass advnameclass = new AdvNameClass(
                            DATA[individualkey]['cId'],
                            DATA[individualkey]['cdate'],
                            DATA[individualkey]['chead'],
                            DATA[individualkey]['ctitle'],
                            DATA[individualkey]['cdepart'],
                            DATA[individualkey]['cregion'],
                            DATA[individualkey]['cphone'],
                            DATA[individualkey]['cprice'],
                            DATA[individualkey]['cdetail'],
                            DATA[individualkey]['cpublished'],
                            DATA[individualkey]['curi'],
                            DATA[individualkey]['curilist'],
                            DATA[individualkey]['cagekm'],
                            DATA[individualkey]['csale'],
                            DATA[individualkey]['cauto'],
                            DATA[individualkey]['coil'],
                            DATA[individualkey]['cNew'],
                            DATA[individualkey]['cno'],
                            DATA[individualkey]['cdep11'],
                            DATA[individualkey]['cdep22'],
                            DATA5['cName'],
                            DATA5['cType'],
                            DATA[individualkey]['carrange'],
                            DATA[individualkey]['consoome'],
                          );
                          setState(() {
                            advlist.add(advnameclass);
                            setState(() {
                              advlist.sort((adv1, adv2) =>
                                  adv2.carrange.compareTo(adv1.carrange));

                            });
                          });
                        });


                      });
                    });
                    //////////////////////////////////////////

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
      child: SpinKitCircle(color: Colors.black),
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
            heroTag: "unique9",
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
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
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


              Expanded(
                  child: advlist.length == 0
                      ? Center(
                    child: loadingIndicator,
                  )
                      : new ListView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: _controller,
                      itemCount: advlist.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return  Slidable(
                        actionPane: SlidableDrawerDismissal(),
                        child:   firebasedata(
                          index,
                          advlist.length,
                          advlist[index].cId,
                          advlist[index].cdate,
                          advlist[index].chead,
                          advlist[index].ctitle,
                          advlist[index].cdepart,
                          advlist[index].cregion,
                          advlist[index].cphone,
                          advlist[index].cprice,
                          advlist[index].cdetail,
                          advlist[index].cpublished,
                          advlist[index].curi,
                          advlist[index].curilist,
                          advlist[index].cagekm,
                          advlist[index].csale,
                          advlist[index].cauto,
                          advlist[index].coil,
                          advlist[index].cNew,
                          advlist[index].cno,
                          advlist[index].cname,
                          advlist[index].cdep11,
                          advlist[index].cdep22,

                        ),
                        actions: <Widget>[
                        Container(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: IconSlideAction(
                        caption: 'Edit',
                        color: Colors.green,
                        icon: Icons.edit,
                        onTap: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                new EditAdsForCars(
                                  index,
                                  advlist.length,
                                  advlist[index].cId,
                                  advlist[index].cdate,
                                  advlist[index].chead,
                                  advlist[index].ctitle,
                                  advlist[index].cdepart,
                                  advlist[index].cregion,
                                  advlist[index].cphone,
                                  advlist[index].cprice,
                                  advlist[index].cdetail,
                                  advlist[index].cpublished,
                                  advlist[index].curi,
                                  advlist[index].curilist,
                                  advlist[index].cagekm,
                                  advlist[index].csale,
                                  advlist[index].cauto,
                                  advlist[index].coil,
                                  advlist[index].cNew,
                                  advlist[index].cno,
                                  advlist[index].cname,
                                  departlist1,
                                  widget.regionlist,
                                  advlist[index].cdep11,
                                  advlist[index].cdep22,

                                )),
                          );
                          },
                        ),
                        )
                        ],
                        secondaryActions: <Widget>[
                        Container(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                            new CupertinoAlertDialog(
                              title: new Text("تنبية"),
                              content: new Text("تبغي تحذف اعلانك؟"),
                              actions: [
                                CupertinoDialogAction(
                                    isDefaultAction: false,
                                    child: new FlatButton(
                                      onPressed: () {

                                        setState(() {
                                          FirebaseDatabase.instance.reference()
                                              .child("advdata").child(_userId).child(advlist[index].chead)
                                              .remove().whenComplete(() =>
                                              Toast.show("تم الحذف فى المفضلة", context,
                                                  duration: Toast.LENGTH_SHORT,
                                                  gravity: Toast.BOTTOM));
                                          setState(() async {
                                            advlist.removeAt(index);
                                            Navigator.pop(context);

                                            _imageUrls = advlist[index].curilist
                                                .replaceAll(" ", "")
                                                .replaceAll("[", "")
                                                .replaceAll("]", "")
                                                .split(",");

//                                            final StorageReference storageRef =
//                                            FirebaseStorage.instance.ref().child('myimage');
                                            for(String imge in _imageUrls){

                                              final StorageReference storageRef =
                                              await FirebaseStorage.instance.getReferenceFromUrl(imge);
                                           //   print("hhhhhhhhhhhhhhh${storageRef.path}");
                                              await storageRef.delete().whenComplete(() {
                                               // print("hhhhhhhhhhhhhhh$imge");
                                              });
                                            }

                                          });
                                        });
                                      }
                                      ,
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
                          },
                        )),
                        ],
                        );

                      }))
            ],
          ),
        ],
      ),
    );
  }

  Widget firebasedata(
      int position,
      int length,
      String cId,
      String cdate,
      String chead,
      String ctitle,
      String cdepart,
      String cregion,
      String cphone,
      String cprice,
      String cdetail,
      bool cpublished,
      String curi,
      String curilist,
      String cagekm,
      String csale,
      String cauto,
      String coil,
      String cNew,
      String cno,
      String cname,
      String cdep1,
      String cdep2,
      ) {

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0)),
        //borderOnForeground: true,
        elevation: 10.0,
        margin: EdgeInsets.only(right: 1, left: 1, bottom: 2),
        child: InkWell(
          onTap: () {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AdvProlile(cId, chead, cname)));



          },
          child: Container(
              padding: EdgeInsets.all(0),
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        child: Stack(
                          children: <Widget>[
                            Center(
                              child: curi == "a"
                                  ? new Image.asset("assets/images/ic_bluecar.png",
                              )
                                  : new Image.network(
                                curi,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.0),
                                color:const Color(0xff444460),
                              ),

                              child: Positioned(
                                bottom: 80,
                                right: 0,

                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child:  Text(
                                      cdepart,
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
//                                          fontFamily: 'Estedad-Black',
                                          fontStyle: FontStyle.normal),
                                    )
                                ),
                              ),
                            ),





                          ],
                        ),
                        width: 100,
                        height: 130,
                      ),
                      Container(
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.0),
                            color:Colors.black12,
                          ),
                          child:  Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Text(
                              "منذ: $cdate",
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
//                                  fontFamily: 'Estedad-Black',
                                  fontStyle: FontStyle.normal),
                            ),
                          )

                      ),
                    ],
                  ),
                  Container(
                    height: 130,
                    child: Stack(
                      //alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              "$ctitle",
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: Colors.green,
//                                  fontFamily: 'Estedad-Black',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  fontStyle: FontStyle.normal),
                            ),
                          ),
                        ),
//                        Positioned(
//                          top: 50,
//                          right: 0,
//                          child: Padding(
//                            padding: const EdgeInsets.all(5.0),
//                            child: cRate > 0.0
//                                ? SmoothStarRating(
//                                allowHalfRating: true,
//                                onRated: (v) {},
//                                starCount: 5,
//                                rating: cRate,
//                                isReadOnly: true,
//                                //not changed
//                                //setting value
//                                size: 20.0,
//                                color: Colors.amber,
//                                borderColor: Colors.amber,
//                                spacing: 0.0)
//                                : new Text(
//                              'منضم حديثا',
//                              style: TextStyle(
//                                  color: Colors.lightBlue,
//                                  fontFamily: 'Gamja Flower',
//                                  fontWeight: FontWeight.bold,
//                                  fontSize: 15.0,
//                                  fontStyle: FontStyle.normal),
//                            ),
//                          ),
//                        ),
//                        Positioned(
//                          top: 50,
//                          right: 0,
//                          child: Padding(
//                              padding: const EdgeInsets.all(5.0),
//                              child:  Text(
//                                "منذ: $cdate",
//                                textDirection: TextDirection.rtl,
//                                textAlign: TextAlign.right,
//                                style: TextStyle(
//                                    fontFamily: 'Estedad-Black',
//                                    fontStyle: FontStyle.normal),
//                              )
//                          ),
//                        ),

                        Positioned(
                          top: 100,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "$cregion",
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
//                                      fontFamily: 'Estedad-Black',
                                      fontSize: 10.0,
                                      fontStyle: FontStyle.normal),
                                ),
                                new Icon(
                                  Icons.location_on,
                                  color: Colors.black,
                                  size: 15,
                                ),
                                SizedBox(
                                  height: _minimumPadding,
                                  width: _minimumPadding*4,
                                ),

                                SizedBox(
                                  height: _minimumPadding,
                                  width: _minimumPadding,
                                ),
                                cname == null
                               ? Text("اسم غير معلوم")
                               : Text(
                                  "$cname",
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
//                                      fontFamily: 'Estedad-Black',
                                      fontSize: 10.0,
                                      fontStyle: FontStyle.normal),
                                ),
                                new Icon(
                                  Icons.person,
                                  color: Colors.black,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 5, top: 5, bottom: 5),
                              child: Text(
                                "                                                                    ",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
