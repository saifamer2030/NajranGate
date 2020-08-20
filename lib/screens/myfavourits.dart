
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:NajranGate/classes/AdvClass.dart';
import 'package:NajranGate/classes/AdvNameClass.dart';
import 'package:NajranGate/classes/FavClass.dart';
import 'package:NajranGate/classes/UserDataClass.dart';
import 'package:NajranGate/screens/loginphone.dart';

import 'package:toast/toast.dart';

import 'advprofile.dart';
import 'loginmail.dart';


class MyFav extends StatefulWidget {
  List<String> regionlist = [];
  MyFav(this.regionlist);
  @override
  _MyFavState createState() => _MyFavState();
}

class _MyFavState extends State<MyFav> {
  List<AdvNameClass> advlist = [];
  List<String> namelist = [];
  bool _load = false;

  var _typecurrentItemSelected = '';
  String _userId;

  final databaseFav =
  FirebaseDatabase.instance.reference().child("userFavourits");
  bool isSearch = false;
  String filtter = '';
  TextEditingController searchcontroller = TextEditingController();

  List<AdvNameClass> SearchList = [];
  List<AdvNameClass> costantList = [];

  void filterSearchResults(String filtter) {
    SearchList.clear();
    SearchList.addAll(advlist);
    if (filtter == '') {
      setState(() {
        advlist.clear();
        advlist.addAll(costantList);
      });
      return;
    } else {
      setState(() {
        List<AdvNameClass> ListData = [];
        SearchList.forEach((item) {
          if ((item.cdepart.toString().contains(filtter)) ||
              (item.cname.toString().contains(filtter)) ||
              (item.cregion.toString().contains(filtter)) ||
              (item.ctitle.toString().contains(filtter)) ||
              (item.cdate.toString().contains(filtter))) {
            ListData.add(item);
          }
        });
        setState(() {
          advlist.clear();
          advlist.addAll(ListData);
        });
        return;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _load = true;
    });
    searchcontroller.addListener(() {
      if (searchcontroller.text == '') {
        setState(() {

          filtter = '';
        });
      } else {
        setState(() {
          filtter = searchcontroller.text;
        });
      }
    });
    FirebaseAuth.instance.currentUser().then((user) => user == null
        ?
    Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(
                                builder: (context) => LoginScreen2(widget.regionlist), maintainState: false))
        : setState(() {
            _userId = user.uid;

      databaseFav
                    .child(_userId)
                    .once()
                    .then((DataSnapshot data1) {
                  var DATA1 = data1.value;
                  var keys1 = data1.value.keys;
                  advlist.clear();
                  namelist.clear();
                  for (var individualkey1 in keys1) {
                    FavClass favclass = new FavClass(
                      DATA1[individualkey1]['cId'],
                      DATA1[individualkey1]['cChecked'],
                      DATA1[individualkey1]['cDateID'],
                    );
                    ///////////////////////////////////
                    final advdatabaseReference =FirebaseDatabase.instance.reference().child("advdata");

                    advdatabaseReference
                        .child(DATA1[individualkey1]['cId']).child(DATA1[individualkey1]['cDateID'])
                        .once()
                        .then((DataSnapshot data1) {
                      var DATA = data1.value;
                      setState(() {
                        AdvClass advnameclass = new AdvClass(
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
                          DATA['cauto'],
                          DATA['coil'],
                          DATA['cNew'],
                          DATA['cno'],
                          DATA['cdep11'],
                          DATA['cdep22'],

                          DATA['carrange'],
                          DATA['consoome'],
                          DATA['cmodel'],
                        );
                        /////////////////////////////////////
                        DateTime now = DateTime.now();
                        DateTime startdate = DateTime.parse("${DATA['cdate']}");
                        var deltime = startdate.add(new Duration(days: 7));


                        if (deltime.isAfter(now) ) {
                          final userdatabaseReference =
                          FirebaseDatabase.instance.reference().child("userdata");
                          userdatabaseReference
                              .child( DATA['cId'])
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
                                  DATA['cauto'],
                                  DATA['coil'],
                                  DATA['cNew'],
                                  DATA['cno'],
                                  DATA['cdep11'],
                                  DATA['cdep22'],

                                  DATA5['cName'],
                                  DATA5['cType'],

                                  DATA['carrange'],
                                  DATA['consoome'],
                                  DATA['cmodel'],
                                );
                                setState(() {
                                  advlist.add(advnameclass);
                                  costantList.add(advnameclass);
                                  setState(() {
                                    advlist.sort((adv1, adv2) =>
                                        adv2.carrange.compareTo(adv1.carrange));

                                  });
                                });
                              });


                            });
                          });

                        }else{
                          final databaseFav =
                          FirebaseDatabase.instance.reference().child("userFavourits").child(_userId);

                          databaseFav
                              .child(DATA1[individualkey1]['cDateID']).remove();

                        }
                        //////////////////////////////


                        ////////////////////////////////////
                      });

                    });

                  }
                });
           //   }
          //  });
          }));
  }

  final double _minimumPadding = 5.0;
  var _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load
        ? new Container(
            child:Text("لا يوجد مفضلة")


            //SpinKitCircle(color: const Color(0xff171732),),
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
            heroTag: "unique4",
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
          Expanded(
              child: advlist.length == 0
                  ? Center(
                      child:  loadingIndicator,)
                  : new ListView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: _controller,
                      itemCount: advlist.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return InkWell(
                            child: firebasedata(
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
                            ),
                            onTap: () {});
                      })

          )
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
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child:  Text(
                                      cdepart,
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
//                                          fontFamily: 'Estedad-Black',
                                          fontStyle: FontStyle.normal),
                                    )
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

                        Positioned(
                          top: 50,
                          right: 0,
                          child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child:  Text(
                                "منذ: $cdate",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
//                                    fontFamily: 'Estedad-Black',
                                    fontStyle: FontStyle.normal),
                              )
                          ),
                        ),

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
                                Text(
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
  void _onDropDownItemSelectedtype(String newValueSelected) {
    setState(() {
      this._typecurrentItemSelected = newValueSelected;
    });
    if (newValueSelected == 'طلبات') {
      filterSearchResults("طلب");
    } else if (newValueSelected == 'عروض') {
      filterSearchResults("عرض");
    } else if (newValueSelected == 'الكل') {
      filterSearchResults('');
    }
  }
}
