import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:NajranGate/classes/AdvClass.dart';
import 'package:NajranGate/classes/AdvNameClass.dart';
import 'package:NajranGate/classes/DepartmentClass.dart';
import 'package:NajranGate/classes/UserDataClass.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'package:toast/toast.dart';

import 'advprofile.dart';

class AllAdvertesmenta extends StatefulWidget {
  List<String> regionlist = [];

  AllAdvertesmenta(this.regionlist);

  @override
  _AllAdvertesmentaState createState() => _AllAdvertesmentaState();
}

//db ref
final fcmReference = FirebaseDatabase.instance.reference().child('Fcm-Token');

class _AllAdvertesmentaState extends State<AllAdvertesmenta> {
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  List<AdvNameClass> advlist = [];
  List<DepartmentClass> departlist = [];
  List<DepartmentClass> departlist1 = [];
  List<DepartmentClass> departlist2 = [];
  bool depart1 = false;
  bool carcheck = false;
  bool depart2 = false;
  bool scolorcheck = false;
  bool _load = false;
  var _typecurrentItemSelected = '';
  var _regioncurrentItemSelected = '';
  var _indyearcurrentItemSelected = "";

  //String mod = "الموديل";

  String dep = "الكل";
  String filt = "";
  List<String> _imageUrls;
  var _typearray = [
    "النوع",
    'محل',
    'مقر',
    'معرض',
    'فرد',
  ];

  String _userId;

//  final advdatabaseReference =
//      FirebaseDatabase.instance.reference().child("advdata");

  FirebaseDatabase userdatabaseReference;
  FirebaseDatabase advdatabaseReference;
  FirebaseDatabase departmentsdatabaseReference;
  FirebaseDatabase departments1databaseReference;
  Query _query;
  FirebaseAuth _firebaseAuth;
  String _cRating = "0";
  int _cCustRate = 0;

  bool isSearch = false;
  String filtter = '';
  TextEditingController searchcontroller = TextEditingController();

  List<AdvNameClass> SearchList = [];
  List<AdvNameClass> costantList = [];
  List<String> indyearlist = [];

  void filterSearchResults(
      String filtter, String reg, String typ, String dep, String model) {
    print("mmmm222$filtter//reg$reg//typ$typ//dep$dep");

//     filtter="kkk";
//     reg="ثار";
//     typ="النوع";
//     dep="الكل";
    SearchList.clear();
    SearchList.addAll(advlist);
    if ((filtter == '') &&
        (reg == 'الحى') &&
        (typ == 'النوع') &&
        (dep == 'الكل') &&
        (model == 'الموديل')) {
      setState(() {
        advlist.clear();
        advlist.addAll(costantList);
      });
      print("nnnnn$filtter//$reg//$typ//$dep");
      return;
    } else {
      if (reg == 'الحى') {
        setState(() {
          reg = '';
        });
      }
      if (typ == 'النوع') {
        setState(() {
          typ = '';
        });
      }
      if (model == 'الموديل') {
        setState(() {
          model = '';
        });
      }
      if (dep == 'الكل') {
        setState(() {
          dep = '';
        });
      }
      //  print("mmmm$filtter//reg$reg//typ$typ//dep$dep");

      setState(() {
        List<AdvNameClass> ListData = [];
        SearchList.forEach((item) {
          if (((item.cname.toString().contains(filtter)) ||
                  (item.ctitle.toString().contains(filtter))) &&
              (item.cmodel.toString().contains(model)) &&
              (item.cregion.toString().contains(reg)) &&
              (item.cType.toString().contains(typ)) &&
              ((item.cdepart.toString().contains(dep)) ||
                  (item.cdep11.toString().contains(dep)) ||
                  (item.cdep22.toString().contains(dep)))) {
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
    _firebaseAuth = FirebaseAuth.instance;
//    getUserName();
//    FirebaseAuth.instance.currentUser().then((user) => user == null
//        ? null
//        : setState(() {
//      _userId = user.uid;
//      userdatabaseReference
//          .reference()
//          .child("userdata")
//          .child(_userId)
//          .child("cType")
//          .once()
//          .then((DataSnapshot snapshot) {
//        setState(() {
//          if (snapshot.value != null) {
//            setState(() {
//              _userType = snapshot.value;
//            });
//          } else {}
//        });
//      });
//    });

    DateTime now = DateTime.now();
    indyearlist = new List<String>.generate(
        50,
        (i) => NumberUtility.changeDigit(
            (now.year + 1 - i).toString(), NumStrLanguage.English));
    indyearlist[0] = ("الموديل");
    _indyearcurrentItemSelected = indyearlist[0];

    // setState(() {    _indyearcurrentItemSelected="الموديل";    });
    filt == null ? filt = "" : filt = searchcontroller.text.toString();
    _regioncurrentItemSelected = widget.regionlist[0];
    _typecurrentItemSelected = _typearray[0];

    departmentsdatabaseReference = FirebaseDatabase.instance;
    departmentsdatabaseReference.setPersistenceEnabled(true);
    departmentsdatabaseReference.setPersistenceCacheSizeBytes(1000000);
//
//    final departmentsdatabaseReference =
//        FirebaseDatabase.instance.reference().child("Departments");
    departmentsdatabaseReference
        .reference()
        .child("Departments")
        .once()
        .then((DataSnapshot snapshot) {
      var KEYS = snapshot.value.keys;
      var DATA = snapshot.value;
      //Toast.show("${snapshot.value.keys}",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);

      departlist.clear();
      departlist.add(new DepartmentClass(
          "0",
          "الكل",
          "0",
          "https://firebasestorage.googleapis.com/v0/b/souqnagran-49abe.appspot.com/o/departments%2Fhiclipart.com%20(10).png?alt=media&token=4f67571b-d419-4f07-8890-11201cc2239a",
          const Color(0xff8C8C96),
          false,
          0));
      for (var individualkey in KEYS) {
        // if (!blockList.contains(individualkey) &&user.uid != individualkey) {
        DepartmentClass departmentclass = new DepartmentClass(
          DATA[individualkey]['id'],
          DATA[individualkey]['title'],
          DATA[individualkey]['subtitle'],
          DATA[individualkey]['uri'],
          const Color(0xff8C8C96),
          false,
          DATA[individualkey]['arrange'],
        );

        setState(() {
          if (DATA[individualkey]['arrange'] == null)
            departmentclass = new DepartmentClass(
              DATA[individualkey]['id'],
              DATA[individualkey]['title'],
              DATA[individualkey]['subtitle'],
              DATA[individualkey]['uri'],
              const Color(0xff8C8C96),
              false,
              100,
            );
          departlist.add(departmentclass);
          setState(() {
            print("size of list : 5");
            departlist.sort((depart1, depart2) =>
                depart1.arrange.compareTo(depart2.arrange));
          });
        });
        // }
      }
    });
    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? null
        : setState(() {
            _userId = user.uid;
          }));

    // get Token :
    firebaseMessaging.getToken().then((token) {
      if (_userId != null) {
        update(token);
      }
    }).then((_) {});

    setState(() {
      _load = true;
    });
    //_typecurrentItemSelected = _typearray[0];
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
//    FirebaseAuth.instance.currentUser().then((user) => user == null
    //    _userId = user.uid;

    setState(() {
      advdatabaseReference = FirebaseDatabase.instance;
      advdatabaseReference.setPersistenceEnabled(true);
      advdatabaseReference.setPersistenceCacheSizeBytes(1000000);

//      final advdatabaseReference =
//          FirebaseDatabase.instance.reference().child("advdata");
      advdatabaseReference
          .reference()
          .child("advdata")
          .once()
          .then((DataSnapshot data) {
        var uuId = data.value.keys;

        advlist.clear();
        // namelist.clear();
        for (var id in uuId) {
          advdatabaseReference
              .reference()
              .child("advdata")
              .child(id)
              .once()
              .then((DataSnapshot data1) {
            var DATA = data1.value;
            var keys = data1.value.keys;

            for (var individualkey in keys) {
              //  print('kkkkkkkkkkk${individualkey}');

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
                DATA['cmodel'],
              );
              DateTime now = DateTime.now();
              DateTime startdate =
                  DateTime.parse("${DATA[individualkey]['cdate']}");
              var deltime = startdate.add(new Duration(days: 60));

              if (deltime.isAfter(now)) {
                /////////////////////////////////////
                userdatabaseReference = FirebaseDatabase.instance;
                userdatabaseReference.setPersistenceEnabled(true);
                userdatabaseReference.setPersistenceCacheSizeBytes(1000000);

//                final userdatabaseReference =
//                    FirebaseDatabase.instance.reference().child("userdata");
                userdatabaseReference
                    .reference()
                    .child("userdata")
                    .child(DATA[individualkey]['cId'])
                    .once()
                    .then((DataSnapshot data1) {
                  var DATA5 = data1.value;
                  setState(() {
                    UserDataClass userdata = new UserDataClass(
                      DATA5['cName'],
                      DATA5['cType'],
                    );
                    AdvNameClass advnameclass;
                    setState(() {
                      advnameclass = new AdvNameClass(
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
                        DATA[individualkey]['cmodel'],
                        DATA[individualkey]['rating'],
                        DATA[individualkey]['custRate'],
                      );
                      if (DATA[individualkey]['cdep11'] == null) {
                        advnameclass = new AdvNameClass(
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
                          "${DATA[individualkey]['cdepart']} اخري",
                          DATA[individualkey]['cdep22'],
                          DATA5['cName'],
                          DATA5['cType'],
                          DATA[individualkey]['carrange'],
                          DATA[individualkey]['consoome'],
                          DATA[individualkey]['cmodel'],
                          DATA[individualkey]['rating'],
                          DATA[individualkey]['custRate'],
                        );
                        print(
                            "kkkk${"${DATA[individualkey]['cdepart']} اخري"}");
                      } else if (DATA[individualkey]['cdep22'] == null) {
                        advnameclass = new AdvNameClass(
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
                          "${DATA[individualkey]['cdepart']} اخري",
                          DATA5['cName'],
                          DATA5['cType'],
                          DATA[individualkey]['carrange'],
                          DATA[individualkey]['consoome'],
                          DATA[individualkey]['cmodel'],
                          DATA[individualkey]['rating'],
                          DATA[individualkey]['custRate'],
                        );
                        print(
                            "kkkk${"${DATA[individualkey]['cdepart']} اخري"}");
                      } else if (DATA[individualkey]['cdep11'] == null ||
                          DATA[individualkey]['cdep22'] == null) {
                        advnameclass = new AdvNameClass(
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
                          "${DATA[individualkey]['cdepart']} اخري",
                          "${DATA[individualkey]['cdepart']} اخري",
                          DATA5['cName'],
                          DATA5['cType'],
                          DATA[individualkey]['carrange'],
                          DATA[individualkey]['consoome'],
                          DATA[individualkey]['cmodel'],
                          DATA[individualkey]['rating'],
                          DATA[individualkey]['custRate'],
                        );
                        print(
                            "kkkk${"${DATA[individualkey]['cdepart']} اخري"}");
                      }
                      setState(() {
                        advlist.add(advnameclass);
                        costantList.add(advnameclass);
                        setState(() {
                          advlist.sort((adv1, adv2) =>
                              adv2.carrange.compareTo(adv1.carrange));

                          costantList.sort((adv1, adv2) =>
                              adv2.carrange.compareTo(adv1.carrange));
                        });
                      });
                    });
                  });
                });
              } else {
                advdatabaseReference = FirebaseDatabase.instance;
                advdatabaseReference.setPersistenceEnabled(true);
                advdatabaseReference.setPersistenceCacheSizeBytes(1000000);

//                final advdatabaseReference =
//                    FirebaseDatabase.instance.reference().child("advdata");

                advdatabaseReference
                    .reference()
                    .child("advdata")
                    .child(DATA[individualkey]['cId'])
                    .child(DATA[individualkey]['chead'])
                    .remove()
                    .whenComplete(() async {
                  _imageUrls = DATA[individualkey]['curilist']
                      .replaceAll(" ", "")
                      .replaceAll("[", "")
                      .replaceAll("]", "")
                      .split(",");

                  for (String imge in _imageUrls) {
                    final StorageReference storageRef = await FirebaseStorage
                        .instance
                        .getReferenceFromUrl(imge);
                    //   print("hhhhhhhhhhhhhhh${storageRef.path}");
                    await storageRef.delete().whenComplete(() {
                      // print("hhhhhhhhhhhhhhh$imge");
                    });
                  }
                });
              }
            }
          });
        }
      });
    });
    //);
    setState(() {});
  }

  final double _minimumPadding = 5.0;
  var _controller = ScrollController();
  var _depcontroller = ScrollController();

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load
        ? new Container(child: Text("لا يوجد إعلانات")
            //SpinKitCircle(color: Colors.black),
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
            heroTag: "unique2",
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
        mainAxisAlignment: MainAxisAlignment.start,
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
          Container(
            height: 50,
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: 35,
                margin: EdgeInsets.only(right: 15, left: 15),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 40,
                      child: IconButton(
                        icon: Icon(Icons.refresh),
                        tooltip: 'إعاده تهيأة البحث',
                        onPressed: () {
                          filterSearchResults(
                              '', 'الحى', 'النوع', 'الكل', 'الموديل');
                          _depcontroller.animateTo(0.0,
                              curve: Curves.easeInOut,
                              duration: Duration(seconds: 1));
                          setState(() {
                            _regioncurrentItemSelected = widget.regionlist[0];
                            _typecurrentItemSelected = _typearray[0];
                            _indyearcurrentItemSelected = indyearlist[0];

                            dep = "الكل";
                            filt = "";
                            depart1 = false;
                            depart2 = false;
                            scolorcheck = false;
                          });
                        },
                      ),
                    ),
                    /**new RaisedButton(
                        child: Icon(Icons.refresh,color: Colors.white,size: 25,),
                        textColor: Colors.white,
                        color: const Color(0xff171732),
                        onPressed: () {

                        },
                        //
                        shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(100.0)),
                        ),
                        ),**/
                    Flexible(
                      child: Container(
                        // width: 210,
                        height: 30,
                        margin: EdgeInsets.only(left: 2),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(97, 248, 248, 248),
                          border: Border.all(
                            width: 1,
                            color: Color.fromARGB(97, 216, 216, 216),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),

                        child: Container(
                            height: 13,
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextField(
                                style: TextStyle(color: Colors.black),
                                onChanged: (value) {
                                  setState(() {
                                    filt = value;
                                    print(
                                        "mmmm111$filt//$_regioncurrentItemSelected//$_typecurrentItemSelected//$dep");
                                    filterSearchResults(
                                        filt,
                                        _regioncurrentItemSelected,
                                        _typecurrentItemSelected,
                                        dep,
                                        _indyearcurrentItemSelected);
                                  });
                                },
                                controller: searchcontroller,
                                // focusNode: focus,
                                decoration: InputDecoration(
                                  labelText: searchcontroller.text.isEmpty
                                      ? "بحث بالاسم"
                                      : '',
                                  labelStyle: TextStyle(
                                      color: Colors.black, fontSize: 18.0),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.black,
                                  ),
                                  suffixIcon: searchcontroller.text.isNotEmpty
                                      ? IconButton(
                                          icon: Icon(Icons.cancel,
                                              color: Colors.black),
                                          onPressed: () {
                                            setState(() {
                                              searchcontroller.clear();

                                              setState(() {
                                                filt = '';
                                                filterSearchResults(
                                                    filt,
                                                    _regioncurrentItemSelected,
                                                    _typecurrentItemSelected,
                                                    dep,
                                                    _indyearcurrentItemSelected);
                                              });
                                            });
                                          },
                                        )
                                      : null,
                                  errorStyle: TextStyle(color: Colors.blue),
                                  enabled: true,
                                  alignLabelWithHint: true,
                                ),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Positioned(
                  left: 10,
                  top: 0,
                  right: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          // width: 258,

                          height: 35,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Container(
                                  // width: 210,
                                  height: 30,
                                  margin: EdgeInsets.only(left: 2),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(97, 248, 248, 248),
                                    border: Border.all(
                                      width: 1,
                                      color: Color.fromARGB(97, 216, 216, 216),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),

                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      carcheck
                                          ? DropdownButtonHideUnderline(
                                              child: ButtonTheme(
                                              alignedDropdown: true,
                                              child: DropdownButton<String>(
                                                items: indyearlist
                                                    .map((String value) {
                                                  return new DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: new Text(value),
                                                  );
                                                }).toList(),
                                                hint: Text(
                                                  "الموديل",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 5),
//                                                      textAlign: TextAlign.end,
                                                ),
                                                value:
                                                    _indyearcurrentItemSelected,
                                                onChanged:
                                                    (String newValueSelected) {
                                                  // Your code to execute, when a menu item is selected from dropdown
                                                  _onDropDownItemSelectedindyear(
                                                      newValueSelected);
                                                },
                                                style: new TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13),
                                              ),
                                            ))
                                          : Container(),
                                      carcheck
                                          ? Container(
                                              width: 1,
                                              height: 20,
                                              color: Colors.grey,
                                            )
                                          : Container(),
                                      SizedBox(
                                        width: 5,
                                      ),

                                      DropdownButtonHideUnderline(
                                          child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
                                          items: _typearray.map((String value) {
                                            return new DropdownMenuItem<String>(
                                              value: value,
                                              child: new Text(value),
                                            );
                                          }).toList(),
                                          value: _typecurrentItemSelected,
                                          onChanged: (String newValueSelected) {
                                            // Your code to execute, when a menu item is selected from dropdown
                                            _onDropDownItemSelectedtype(
                                                newValueSelected);
                                          },
                                          style: new TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      )),
                                      Container(
                                        width: 1,
                                        height: 20,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      DropdownButtonHideUnderline(
                                          child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
                                          items: widget.regionlist
                                              .map((String value) {
                                            return new DropdownMenuItem<String>(
                                              value: value,
                                              child: new Text(value),
                                            );
                                          }).toList(),
                                          value: _regioncurrentItemSelected,
                                          onChanged: (String newValueSelected) {
                                            // Your code to execute, when a menu item is selected from dropdown
                                            _onDropDownItemSelectedreg(
                                                newValueSelected);
                                          },
                                          style: new TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      )),
//                                                Container(
//                                                  width: 1,
//                                                  height: 20,
//                                                  color: Colors.grey,
//                                                )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 70,
            child: departlist.length == 0
                ? new Text("برجاء الإنتظار")
                : new ListView.builder(
                    controller: _depcontroller,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    itemCount: departlist.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return InkWell(
                          child: Padding(
                        padding: const EdgeInsets.only(
                            top: 1.0, right: 5.0, left: 5.0),
                        child: Card(
                          color: const Color(0xff8C8C96),
                          shape: new RoundedRectangleBorder(
                              side: new BorderSide(
                                  color: departlist[index].ccolor, width: 3.0),
                              borderRadius: BorderRadius.circular(10.0)),
                          //borderOnForeground: true,
                          elevation: 10.0,
                          margin: EdgeInsets.all(1),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                departlist[index].ccolorcheck =
                                    !departlist[index].ccolorcheck;
                                if (departlist[index].ccolorcheck) {
                                  departlist[index].ccolor =
                                      const Color(0xff171732);
                                  for (var i = 0; i < departlist.length; i++) {
                                    if (i != index) {
                                      departlist[i].ccolor =
                                          const Color(0xff8C8C96);
                                    }
                                  }
                                } else {
                                  departlist[index].ccolor =
                                      const Color(0xff8C8C96);
                                }
                              });
                              if (departlist[index].title == 'الكل') {
                                setState(() {
                                  dep = 'الكل';
                                  filterSearchResults(
                                      filt,
                                      _regioncurrentItemSelected,
                                      _typecurrentItemSelected,
                                      dep,
                                      _indyearcurrentItemSelected);
                                });
                              } else {
                                advlist.clear();
                                advlist.addAll(costantList);

                                setState(() {
                                  dep = departlist[index].title;
                                  filterSearchResults(
                                      filt,
                                      _regioncurrentItemSelected,
                                      _typecurrentItemSelected,
                                      dep,
                                      _indyearcurrentItemSelected);
                                });
                              }
                              //      print("lllllll${departlist[index].title.toString()}");
                              setState(() {
                                departlist1.clear();
                                depart2 = false;
                              });

                              departments1databaseReference =
                                  FirebaseDatabase.instance;

                              departments1databaseReference
                                  .setPersistenceEnabled(true);
                              departments1databaseReference
                                  .setPersistenceCacheSizeBytes(1000000);
//                                    final departments1databaseReference =
//                                        FirebaseDatabase.instance
//                                            .reference()
//                                            .child("Departments1")
//                                            .child(departlist[index].title);
                              departments1databaseReference
                                  .reference()
                                  .child("Departments1")
                                  .child(departlist[index].title)
                                  .once()
                                  .then((DataSnapshot snapshot) {
                                var KEYS = snapshot.value.keys;
                                var DATA = snapshot.value;
                                //Toast.show("${snapshot.value.keys}",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
                                //   print("kkkk${DATA.toString()}");

                                for (var individualkey in KEYS) {
                                  DepartmentClass departmentclass =
                                      new DepartmentClass(
                                    DATA[individualkey]['id'],
                                    DATA[individualkey]['title'],
                                    DATA[individualkey]['subtitle'],
                                    DATA[individualkey]['uri'],
                                    Colors.white,
                                    false,
                                    DATA[individualkey]['arrange'],
                                  );
                                  setState(() {
                                    if (DATA[individualkey]['arrange'] == null)
                                      departmentclass = new DepartmentClass(
                                        DATA[individualkey]['id'],
                                        DATA[individualkey]['title'],
                                        DATA[individualkey]['subtitle'],
                                        DATA[individualkey]['uri'],
                                        const Color(0xff8C8C96),
                                        false,
                                        100,
                                      );
                                    departlist1.add(departmentclass);
                                    setState(() {
                                      print("size of list : 5");
                                      departlist1.sort((depart1, depart2) =>
                                          depart1.arrange
                                              .compareTo(depart2.arrange));
                                    });
                                  });
                                  // }
                                }
                              }).whenComplete(() {
                                if (departlist[index].title == 'الكل' ||
                                    departlist1.length == 0) {
                                  setState(() {
                                    depart1 = false;
                                    carcheck = false;
                                    _indyearcurrentItemSelected = "الموديل";
                                  });
                                } else {
                                  setState(() {
                                    departlist1.add(new DepartmentClass(
                                      "",
                                      "${departlist[index].title} اخري",
                                      null,
                                      "https://firebasestorage.googleapis.com/v0/b/souqnagran-49abe.appspot.com/o/departments1%2Fhiclipart.com%20(10).png?alt=media&token=7ea64e1a-5170-45ef-bca0-e6adf272dead",
                                      const Color(0xff8C8C96),
                                      false,
                                      100,
                                    ));
                                    depart1 = true;
                                    if (departlist[index].title == 'السيارات') {
                                      setState(() {
                                        carcheck = true;
                                      });
                                    } else {
                                      setState(() {
                                        carcheck = false;
                                        _indyearcurrentItemSelected = "الموديل";
                                      });
                                    }
                                  });
                                }
                              }).catchError(() {
                                if (departlist[index].title == 'الكل' ||
                                    departlist1.length == 0) {
                                  setState(() {
                                    depart1 = false;
                                    carcheck = false;
                                    _indyearcurrentItemSelected = "الموديل";
                                  });
                                } else {
                                  setState(() {
                                    depart1 = true;
                                    if (departlist[index].title == 'السيارات') {
                                      setState(() {
                                        carcheck = true;
                                      });
                                    } else {
                                      setState(() {
                                        carcheck = false;
                                        _indyearcurrentItemSelected = "الموديل";
                                      });
                                    }
                                  });
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),

//                                       color: departlist[index].ccolor,
                              child: Container(
                                width: 65,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 22,
                                      height: 22,
                                      child: new CachedNetworkImage(
                                        imageUrl: departlist[index].uri,
                                        placeholder: (context, url) =>
                                            SpinKitCircle(
                                                color: const Color(0xff171732)),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 3),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          departlist[index].title,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
//                                                  const Color(0xff171732),
                                            fontFamily: "",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                            letterSpacing: 0.5,
                                            height: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                          /**  _firebasedatdepart(
                        index,
                        departlist.length,
                        departlist[index].id,
                        departlist[index].title,
                        departlist[index].subtitle,
                        departlist[index].uri,
                        Colors.white,
                        false

                        ),**/
                          );
                    }),
          ),
          depart1
              ? Container(
                  height: 30,
                  child: departlist1.length == 0
                      ? new Text("برجاء الإنتظار")
                      : new ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          itemCount: departlist1.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return InkWell(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 1.0, right: 5.0, left: 5.0),
                                child: Card(
//                                        color: departlist1[index].ccolor,
                                  color: const Color(0xff8C8C96),
                                  shape: new RoundedRectangleBorder(
                                      side: new BorderSide(
                                          color: departlist1[index].ccolor,
                                          width: 2.0),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  //borderOnForeground: true,
                                  elevation: 10.0,
                                  margin: EdgeInsets.all(1),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        departlist1[index].ccolorcheck =
                                            !departlist1[index].ccolorcheck;
                                        if (departlist1[index].ccolorcheck) {
                                          departlist1[index].ccolor =
                                              const Color(0xff171732);
                                          for (var i = 0;
                                              i < departlist1.length;
                                              i++) {
                                            if (i != index) {
                                              departlist1[i].ccolor =
                                                  const Color(0xff8C8C96);
                                            }
                                          }
                                        } else {
                                          departlist1[index].ccolor =
                                              const Color(0xff8C8C96);
                                        }
                                      });
                                      if (departlist1[index].title == 'الكل') {
                                        setState(() {
                                          dep = 'الكل';
                                          filterSearchResults(
                                              filt,
                                              _regioncurrentItemSelected,
                                              _typecurrentItemSelected,
                                              dep,
                                              _indyearcurrentItemSelected);
                                        });
                                        //  filterSearchResults('');
                                      } else {
                                        advlist.clear();
                                        advlist.addAll(costantList);

                                        setState(() {
                                          dep = departlist1[index].title;
                                          filterSearchResults(
                                              filt,
                                              _regioncurrentItemSelected,
                                              _typecurrentItemSelected,
                                              dep,
                                              _indyearcurrentItemSelected);
                                        });

                                        //  filterSearchResults(departlist1[index].title);
                                      }
                                      setState(() {
                                        List<String> departlistsss = [];
                                        departlistsss.clear();
                                        departlist2.clear();
                                        departlistsss = departlist1[index]
                                            .subtitle
                                            .split(",");
                                        for (var i = 0;
                                            i < departlistsss.length;
                                            i++) {
                                          departlist2.add(new DepartmentClass(
                                              "",
                                              departlistsss[i],
                                              "",
                                              "",
                                              const Color(0xff8C8C96),
                                              false,
                                              100));
                                        }
                                      });
                                      if (departlist1[index].title == 'الكل' ||
                                          departlist2.length == 0) {
                                        setState(() {
                                          depart2 = false;
                                        });
                                      } else {
                                        setState(() {
                                          departlist2.add(new DepartmentClass(
                                            "",
                                            "${departlist[index].title} اخري",
                                            null,
                                            "https://firebasestorage.googleapis.com/v0/b/souqnagran-49abe.appspot.com/o/departments1%2Fhiclipart.com%20(10).png?alt=media&token=7ea64e1a-5170-45ef-bca0-e6adf272dead",
                                            const Color(0xff8C8C96),
                                            false,
                                            100,
                                          ));
                                          depart2 = true;
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              child: new CachedNetworkImage(
                                                imageUrl:
                                                    departlist1[index].uri,
                                                placeholder: (context, url) =>
                                                    SpinKitCircle(
                                                        color: const Color(
                                                            0xff171732)),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(right: 2),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Text(
                                                      departlist1[index].title,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: const Color(
                                                            0xff171732),
//                                                              fontFamily: "Estedad-Black",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        height: 0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              /**  _firebasedatdepart1(
                        index,
                        departlist1.length,
                        departlist1[index].id,
                        departlist1[index].title,
                        departlist1[index].subtitle,
                        departlist1[index].uri,
                        ),**/
                            );
                          }),
                )
              : Container(),
          depart2
              ? Container(
                  height: 30,
                  child: departlist2.length == 0
                      ? new Text("برجاء الإنتظار")
                      : new ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          itemCount: departlist2.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return InkWell(
                                child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 1.0, right: 5.0, left: 5.0),
                              child: Card(
//                                        color: departlist2[index].ccolor,
                                color: const Color(0xff8C8C96),
                                shape: new RoundedRectangleBorder(
                                    side: new BorderSide(
                                        color: departlist2[index].ccolor,
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0)),
                                //borderOnForeground: true,
                                elevation: 10.0,
                                margin: EdgeInsets.all(1),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      departlist2[index].ccolorcheck =
                                          !departlist2[index].ccolorcheck;
                                      if (departlist2[index].ccolorcheck) {
                                        departlist2[index].ccolor =
                                            const Color(0xff171732);
                                        for (var i = 0;
                                            i < departlist2.length;
                                            i++) {
                                          if (i != index) {
                                            departlist2[i].ccolor =
                                                const Color(0xff8C8C96);
                                          }
                                        }
                                      } else {
                                        departlist2[index].ccolor =
                                            const Color(0xff8C8C96);
                                      }
                                    });
                                    if (departlist2 == 'الكل') {
                                      setState(() {
                                        dep = 'الكل';
                                        filterSearchResults(
                                            filt,
                                            _regioncurrentItemSelected,
                                            _typecurrentItemSelected,
                                            dep,
                                            _indyearcurrentItemSelected);
                                      });
                                    } else {
                                      advlist.clear();
                                      advlist.addAll(costantList);

                                      setState(() {
                                        dep = departlist2[index].title;
                                        filterSearchResults(
                                            filt,
                                            _regioncurrentItemSelected,
                                            _typecurrentItemSelected,
                                            dep,
                                            _indyearcurrentItemSelected);
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(right: 2),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                departlist2[index].title,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff171732),
//                                                          fontFamily: "Estedad-Black",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  height: 0.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
//                                    _firebasedatdepart2(
//                                      index,
//                                      departlist2.length,
//                                      departlist2[index],
//
//                                    ),
                                );
                          }),
                )
              : Container(),
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
                            advlist[index].cmodel,
                            advlist[index].rating,
                            advlist[index].custRate,
                          ),
                          onTap: () {});
                    }),
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
    String cmodel,
    String rating,
    int custRate,
  ) {
    var cRate = 0.0;
    if (rating == null && custRate == null) {
      rating = "0";
      custRate = 0;
    }

    if (custRate > 0) {
      cRate = double.parse(rating) / custRate;
    }
    print("##############$custRate#############$cdepart");
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
//            print('111 payload: ' + cId + chead + cname);
            if (cname == null) {
              // ignore: unnecessary_statements
              cname == "اسم غير معلوم";
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AdvProlile(cId, chead, cname, cRate)));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AdvProlile(cId, chead, cname, cRate)));
            }
          },
          child: Container(
//            width: MediaQuery.of(context).size.width,
              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: curi == "a"
                              ? new Image.asset(
                                  "assets/images/ic_bluecar.png",
                                )
                              : new CachedNetworkImage(
                                  imageUrl: curi,
                                  placeholder: (context, url) => SpinKitCircle(
                                      color: const Color(0xff171732)),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  fit: BoxFit.fitHeight,
                                ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.0),
                            color: const Color(0xff444460),
                          ),
                          child: Text(
                            cdepart,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
//                                          fontFamily: 'Estedad-Black',
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                      ],
                    ),
                    width: 100,
                    height: 90,
                  ),
                  Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.0),
                        color: Colors.black12,
                      ),
                      child: Padding(
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
                      )),
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
                    cmodel != null
                        ? Positioned(
                            top: 30,
                            right: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "$cmodel",
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: Colors.blue,
//                                  fontFamily: 'Estedad-Black',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0,
                                        fontStyle: FontStyle.normal),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Icon(
                                      Icons.directions_car,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    Positioned(
                        top: 90,
                        right: 10,
                        child: SmoothStarRating(
                            isReadOnly: true,
//                            allowHalfRating: false,
//                            onRated: (v) {
////                                        rating = v;
//                              setState(() {});
//                            },
                            starCount: 5,
                            rating: cRate,
                            //setting value
                            size: 15.0,
                            color: Colors.amber,
                            borderColor: Colors.grey,
                            spacing: 0.0)),
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
                              width: _minimumPadding * 4,
                            ),
                            SizedBox(
                              height: _minimumPadding,
                              width: _minimumPadding,
                            ),
                            Text(
                              cname != null ? "$cname" : "اسم غير معلوم",
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
                              left: 0, right: 0, top: 0, bottom: 0),
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

  Widget _firebasedatdepart(
      index, length, cId, ctitle, csubtitle, curi, ccolor, colorcheck) {
    return Padding(
      padding: const EdgeInsets.only(top: 1.0, right: 5.0, left: 5.0),
      child: Card(
        shape: new RoundedRectangleBorder(
            side: new BorderSide(color: Colors.grey, width: 3.0),
            borderRadius: BorderRadius.circular(10.0)),
        //borderOnForeground: true,
        elevation: 10.0,
        margin: EdgeInsets.all(1),
        child: InkWell(
          onTap: () {
            setState(() {
              scolorcheck = !scolorcheck;
              if (scolorcheck) {
                ccolor = Colors.green;
              }
            });
            if (ctitle == 'الكل') {
              setState(() {
                dep = 'الكل';
                filterSearchResults(filt, _regioncurrentItemSelected,
                    _typecurrentItemSelected, dep, _indyearcurrentItemSelected);
              });
            } else {
              advlist.clear();
              advlist.addAll(costantList);

              setState(() {
                dep = ctitle;
                filterSearchResults(filt, _regioncurrentItemSelected,
                    _typecurrentItemSelected, dep, _indyearcurrentItemSelected);
              });
            }
            print("lllllll${ctitle.toString()}");
            setState(() {
              departlist1.clear();
              depart2 = false;
            });

            departments1databaseReference = FirebaseDatabase.instance;
            departments1databaseReference.setPersistenceEnabled(true);
            departments1databaseReference.setPersistenceCacheSizeBytes(1000000);
//            final departments1databaseReference = FirebaseDatabase.instance
//                .reference()
//                .child("Departments1")
//                .child(ctitle);
            departments1databaseReference
                .reference()
                .child("Departments1")
                .child(ctitle)
                .once()
                .then((DataSnapshot snapshot) {
              var KEYS = snapshot.value.keys;
              var DATA = snapshot.value;
              //Toast.show("${snapshot.value.keys}",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
              print("kkkk${DATA.toString()}");

              for (var individualkey in KEYS) {
                // if (!blockList.contains(individualkey) &&user.uid != individualkey) {
                DepartmentClass departmentclass = new DepartmentClass(
                    DATA[individualkey]['id'],
                    DATA[individualkey]['title'],
                    DATA[individualkey]['subtitle'],
                    DATA[individualkey]['uri'],
                    Colors.white,
                    false,
                    100);
                print("kkkkkkkkk" + ctitle + DATA[individualkey]['title']);
                setState(() {
                  departlist1.add(departmentclass);
                });
                // }
              }
            }).whenComplete(() {
              if (ctitle == 'الكل' || departlist1.length == 0) {
                setState(() {
                  depart1 = false;
                  setState(() {
                    carcheck = false;
                    _indyearcurrentItemSelected = "الموديل";
                  });
                });
              } else {
                setState(() {
                  depart1 = true;
                  if (departlist[index].title == 'السيارات') {
                    setState(() {
                      carcheck = true;
                    });
                  } else {
                    setState(() {
                      carcheck = false;
                      _indyearcurrentItemSelected = "الموديل";
                    });
                  }
                });
              }
            }).catchError(() {
              if (ctitle == 'الكل' || departlist1.length == 0) {
                setState(() {
                  depart1 = false;
                  carcheck = false;
                  _indyearcurrentItemSelected = "الموديل";
                });
              } else {
                setState(() {
                  depart1 = true;
                  if (departlist[index].title == 'السيارات') {
                    setState(() {
                      carcheck = true;
                    });
                  } else {
                    setState(() {
                      carcheck = false;
                      _indyearcurrentItemSelected = "الموديل";
                    });
                  }
                });
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
              color: ccolor,
              child: Container(
                width: 50,
                height: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 15,
                      height: 15,
                      child: new CachedNetworkImage(
                        imageUrl: curi,
                        placeholder: (context, url) =>
                            SpinKitCircle(color: const Color(0xff171732)),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 3),
                      child: Text(
                        ctitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xff171732),
                          fontFamily: "",
                          fontWeight: FontWeight.w400,
                          fontSize: 8,
                          letterSpacing: 0.5,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _firebasedatdepart1(
    index,
    length,
    cId,
    ctitle,
    csubtitle,
    curi,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 1.0, right: 5.0, left: 5.0),
      child: Card(
        shape: new RoundedRectangleBorder(
            side: new BorderSide(color: Colors.grey, width: 2.0),
            borderRadius: BorderRadius.circular(10.0)),
        //borderOnForeground: true,
        elevation: 10.0,
        margin: EdgeInsets.all(1),
        child: InkWell(
          onTap: () {
            if (ctitle == 'الكل') {
              setState(() {
                dep = 'الكل';
                filterSearchResults(filt, _regioncurrentItemSelected,
                    _typecurrentItemSelected, dep, _indyearcurrentItemSelected);
              });
            } else {
              advlist.clear();
              advlist.addAll(costantList);

              setState(() {
                dep = ctitle;
                filterSearchResults(filt, _regioncurrentItemSelected,
                    _typecurrentItemSelected, dep, _indyearcurrentItemSelected);
              });
            }
            setState(() {
              departlist2.clear();
              departlist2 = csubtitle.split(",");
            });
            if (ctitle == 'الكل' || departlist2.length == 0) {
              setState(() {
                depart2 = false;
              });
            } else {
              setState(() {
                depart2 = true;
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    child: new CachedNetworkImage(
                      imageUrl: curi,
                      placeholder: (context, url) =>
                          SpinKitCircle(color: const Color(0xff171732)),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      margin: EdgeInsets.only(right: 2),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            ctitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xff171732),
                              fontFamily: "Estedad-Black",
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _firebasedatdepart2(
    index,
    length,
    ctitle,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 1.0, right: 5.0, left: 5.0),
      child: Card(
        color: Colors.white,
        shape: new RoundedRectangleBorder(
            side: new BorderSide(color: Colors.grey, width: 2.0),
            borderRadius: BorderRadius.circular(10.0)),
        //borderOnForeground: true,
        elevation: 10.0,
        margin: EdgeInsets.all(1),
        child: InkWell(
          onTap: () {
            if (ctitle == 'الكل') {
              setState(() {
                dep = 'الكل';
                filterSearchResults(filt, _regioncurrentItemSelected,
                    _typecurrentItemSelected, dep, _indyearcurrentItemSelected);
              });
            } else {
              advlist.clear();
              advlist.addAll(costantList);

              setState(() {
                dep = ctitle;
                filterSearchResults(filt, _regioncurrentItemSelected,
                    _typecurrentItemSelected, dep, _indyearcurrentItemSelected);
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 3),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        ctitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xff171732),
                          fontFamily: "Estedad-Black",
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getUserName() async {
    FirebaseUser usr = await _firebaseAuth.currentUser();
    if (usr != null) {
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
            _cRating = values['rating'].toString();
            _cCustRate = values['custRate'].hashCode;
            print("$_cRating###########///////$_cCustRate");
//            _userId = usr.uid;
          });
        }
      });
    }
  }

  void _onDropDownItemSelectedindyear(String newValueSelected) {
    setState(() {
      this._indyearcurrentItemSelected = newValueSelected;
    });
    if (newValueSelected == 'الموديل') {
      setState(() {
        // dep= 'الكل';
        filterSearchResults(filt, _regioncurrentItemSelected,
            _typecurrentItemSelected, dep, _indyearcurrentItemSelected);
      });
    } else {
      advlist.clear();
      advlist.addAll(costantList);

      setState(() {
        // dep= 'الكل';
        filterSearchResults(filt, _regioncurrentItemSelected,
            _typecurrentItemSelected, dep, _indyearcurrentItemSelected);
      });
    }
  }

  //_onDropDownItemSelectedtype
  void _onDropDownItemSelectedtype(String newValueSelected) {
    setState(() {
      this._typecurrentItemSelected = newValueSelected;
    });
    if (newValueSelected == 'النوع') {
      setState(() {
        // dep= 'الكل';
        filterSearchResults(filt, _regioncurrentItemSelected,
            _typecurrentItemSelected, dep, _indyearcurrentItemSelected);
      });
    } else {
      advlist.clear();
      advlist.addAll(costantList);

      setState(() {
        // dep= 'الكل';
        filterSearchResults(filt, _regioncurrentItemSelected,
            _typecurrentItemSelected, dep, _indyearcurrentItemSelected);
      });
    }
  }

  void _onDropDownItemSelectedreg(String newValueSelected) {
    setState(() {
      this._regioncurrentItemSelected = newValueSelected;
    });
    if (newValueSelected == 'الحى') {
      setState(() {
        // dep= 'الكل';
        filterSearchResults(filt, _regioncurrentItemSelected,
            _typecurrentItemSelected, dep, _indyearcurrentItemSelected);
      });
    } else {
      advlist.clear();
      advlist.addAll(costantList);

      setState(() {
        // dep= 'الكل';
        filterSearchResults(filt, _regioncurrentItemSelected,
            _typecurrentItemSelected, dep, _indyearcurrentItemSelected);
      });
    }
  }

  update(String token) async {
    fcmReference.child(_userId).set({"Token": token});
  }

/**

    update(String token) async {
    DatabaseReference databaseReference = new FirebaseDatabase().reference();
    fcmReference.child(_userId).set({"Token": token});
    }
    void _onDropDownItemSelectedtype(String newValueSelected) {
    setState(() {
    this._typecurrentItemSelected = newValueSelected;
    });
    if (newValueSelected == 'طلبات') {
    orderlist.clear();
    orderlist.addAll(costantList);
    filterSearchResults("طلب");
    } else if (newValueSelected == 'عروض') {
    orderlist.clear();
    orderlist.addAll(costantList);
    filterSearchResults("عرض");
    } else if (newValueSelected == 'الكل') {
    filterSearchResults('');
    }
    }**/

}
