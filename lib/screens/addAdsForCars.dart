import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:souqnagran/classes/DepartmentClass.dart';
import 'package:souqnagran/screens/alladvertsments.dart';
import 'package:souqnagran/screens/splash.dart';
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;
import 'package:image/image.dart' as Img;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../FragmentSouqNajran.dart';
import 'advprofile.dart';

class AddAdsForCars extends StatefulWidget {
  String department;
  int index;
  List<String> departlist = [];
  List<String> regionlist = [];

  AddAdsForCars(this.department, this.departlist, this.index,this.regionlist);

  @override
  _AddAdsForCarsState createState() => _AddAdsForCarsState();
}

enum SingingCharacter1 { sale, give }
enum SingingCharacter2 { outo, manul }
enum SingingCharacter3 { solar, oil, haiprd }
enum SingingCharacter4 { used, New, crashed }
enum SingingCharacter5 { yes, no }

class _AddAdsForCarsState extends State<AddAdsForCars> {
  final double _minimumPadding = 5.0;
  var _formKey = GlobalKey<FormState>();
  bool _load2 = false;
  String _userId;
  String dep1;
  String dep2;
  int picno = 0;
  SingingCharacter1 _character1 = SingingCharacter1.sale;
  SingingCharacter2 _character2 = SingingCharacter2.outo;
  SingingCharacter3 _character3 = SingingCharacter3.oil;
  SingingCharacter4 _character4 = SingingCharacter4.New;
  SingingCharacter5 _character5 = SingingCharacter5.no;
  List<String> urlList = [];
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String _cName;
  File sampleImage1;
  File sampleImage2;
  File sampleImage3;
  File sampleImage4;
  File sampleImage5;
  File sampleImage6;
  File sampleImage7;

  String imagepathes='';
  final advdatabaseReference =
      FirebaseDatabase.instance.reference().child("advdata");


  double _value = 0.0;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _detailController = TextEditingController();
  var _departcurrentItemSelected = '';
  var _regioncurrentItemSelected = '';

  void _setvalue(double value) => setState(() => _value = value);

  Future onSelectNotification(String payload) async {
    if (payload != null) {

//    await Navigator.push(
//      context,
//      new MaterialPageRoute(
//          builder: (context) =>
//          new AdvProlile(payload.split(",")[0], payload.split(",")[1], payload.split(",")[2])),
//    );
   }
//    await Navigator.push(
//      context,
//      new MaterialPageRoute(
//          builder: (context) =>
//          new Splash()),
//    );
  }
  @override
  void initState() {
    super.initState();
    //print("######################${widget.department}");
    _departcurrentItemSelected = widget.department;//widget.departlist[widget.index];
    _regioncurrentItemSelected = widget.regionlist[0];
    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? null
        : setState(() {
      _userId = user.uid;
      final userdatabaseReference =
      FirebaseDatabase.instance.reference().child("userdata");

      //////////////////////////
      userdatabaseReference
          .child(_userId)
          .child("cName")
          .once()
          .then((DataSnapshot snapshot5) {
        setState(() {
          if (snapshot5.value != null) {
            setState(() {
              _cName=snapshot5.value;
            });
          }else{
            setState(() {
              _cName="اسم غير معلوم";
            });
          }

        });
      });

      ////////////////////////
    }));

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@drawable/ic_lancher');
    var ios = IOSInitializationSettings();
    var initSettings = InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onSelectNotification: onSelectNotification,
    );
  }
 showNotification(date1,title,_userId,head,name) async {

    DateTime scheduledNotificationDateTime =DateTime.parse('$date1').add(new Duration(days: 13));
//    DateTime scheduledNotificationDateTime = DateTime.now();

//    DateTime scheduledNotificationDateTime = new DateTime(
//        notificationbooking.year,
//        notificationbooking.month,
//        notificationbooking.day,
//        notificationbooking.hour - 1,
//        notificationbooking.minute,
//        notificationbooking.second,
//        notificationbooking.millisecond,
//        notificationbooking.microsecond);
//   Toast.show("${scheduledNotificationDateTime1}",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
    /////////////************************
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channelId', 'channelName', 'channelDescription',
        importance: Importance.Max,
        priority: Priority.High /*, ticker: 'ticker'*/);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//    Toast.show(
//        ' ح طال عمرك',
//        context,
//        duration: Toast.LENGTH_SHORT,
//        gravity: Toast.BOTTOM);

    await flutterLocalNotificationsPlugin.schedule(
        111,
        'تذكير بحذف الاعلان',
        'عزيزى العميل سيتم حذف اعلان $title غدا يرجى عمل تمديد له',
        scheduledNotificationDateTime,
        platformChannelSpecifics,
        payload:""
      //  "$_userId,$head,$_cName"
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load2
        ? new Container(
            child: SpinKitCircle(
              color: const Color(0xff171732),
            ),
          )
        : new Container();

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
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding * 15,
                      bottom: _minimumPadding * 2,
                      right: _minimumPadding * 2,
                      left: _minimumPadding * 2),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              if (picno == 0) {
                                getImage1();
                              } else if (picno == 1) {
                                getImage2();
                              } else if (picno == 2) {
                                getImage3();
                              } else if (picno == 3) {
                                getImage4();
                              }else if (picno == 4) {
                                getImage5();
                              }else if (picno == 5) {
                                getImage6();
                              }else if (picno == 6) {
                                getImage7();
                              }
                              else {
                                Toast.show(
                                    'نحتاج سبعة صور فقط حق إعلانك طال عمرك',
                                    context,
                                    duration: Toast.LENGTH_SHORT,
                                    gravity: Toast.BOTTOM);
                              }
                            },
                            child: Center(
                              child: Container(
                                width: 200,
                                height: 150,
                                color: Colors.grey[300],
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 25.0),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            alignment: Alignment.center,
                                            matchTextDirection: true,
                                            repeat: ImageRepeat.noRepeat,
                                            image: AssetImage(
                                                "assets/images/ic_ads.png"),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Icon(
                                          Icons.add_circle,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, left: 160.0),
                                        child: (picno > 0)
                                            ? Container(
                                                width: 30,
                                                height: 30,
                                                decoration: new BoxDecoration(
                                                    color: Colors.green,
                                                    shape: BoxShape.circle),
                                                child: Center(
                                                  child: Text(
                                                    "$picno",
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    style: TextStyle(
                                                        color: const Color(
                                                            0xff171732),
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              )
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  child: Text(
                                    "عنوان الاعلان",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
//                                      fontFamily: 'Estedad-Black',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  child: Icon(
                                    Icons.rate_review,
                                    color: const Color(0xff171732),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 80,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Card(
                                elevation: 0.0,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                    textAlign: TextAlign.right,
                                    keyboardType: TextInputType.text,
                                    textDirection: TextDirection.rtl,
                                    controller: _titleController,
                                    validator: (String value) {
                                      if ((value.isEmpty)) {
                                        return "اكتب عنوان حق إعلانك طال عمرك";
                                      }
                                    },
                                    decoration: InputDecoration(
                                        errorStyle: TextStyle(
                                            color: Colors.red, fontSize: 15.0),
                                        labelText: "ادخل عنوان الاعلان....",
                                        hintText: "ادخل عنوان الاعلان....",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)))),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 1, left: 1),
                                  child: Text(
                                    "الحي",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
//                                      fontFamily: 'Estedad-Black',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  child: Icon(
                                    Icons.business,
                                    color: const Color(0xff171732),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 250,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Card(
                                elevation: 0.0,
                                color: const Color(0xff171732),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton<String>(
                                    items: widget.regionlist.map((String value) {
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
                                      color: Colors.grey,
                                    ),
                                  ),
                                )),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 1, left: 1),
                                  child: Text(
                                    "القسم",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
//                                      fontFamily: 'Estedad-Black',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  child: Icon(
                                    Icons.dehaze,
                                    color: const Color(0xff171732),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                height: 40,
                                color: Colors.grey,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      showDialog(
                                          context: context,
                                          builder: (context) => MyForm3(widget.department,
                                              onSubmit3: onSubmit3));
                                    });
//showBottomSheet();
                                  },
                                  child:  Card(
                                    elevation: 0.0,
                                    color: const Color(0xff171732),
                                    shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "تفاصيل القسم",
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 250,
                                height: 50,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Card(
                                    elevation: 0.0,
                                    color: const Color(0xff171732),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                        child: ButtonTheme(
                                          alignedDropdown: true,
                                          child: DropdownButton<String>(
                                            items:
                                            widget.departlist.map((String value) {
                                              return new DropdownMenuItem<String>(
                                                value: value,
                                                child: new Text(value),
                                              );
                                            }).toList(),
                                            value: _departcurrentItemSelected,
                                            onChanged: (String newValueSelected) {
                                              // Your code to execute, when a menu item is selected from dropdown
                                              _onDropDownItemSelecteddep(
                                                  newValueSelected);
                                            },
                                            style: new TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                              ),

                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 1, left: 1),
                                  child: Text(
                                    "وسيلة الاتصال",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
//                                      fontFamily: 'Estedad-Black',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  child: Icon(
                                    Icons.call,
                                    color: const Color(0xff171732),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 80,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Card(
                                elevation: 0.0,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                    textAlign: TextAlign.right,
                                    keyboardType: TextInputType.number,
                                    textDirection: TextDirection.rtl,
                                    controller: _phoneController,
                                    validator: (String value) {
                                      if ((value.isEmpty)) {
                                        return "اكتب رقم جوالك طال عمرك";
                                      }
                                    },
                                    decoration: InputDecoration(
                                        errorStyle: TextStyle(
                                            color: Colors.red, fontSize: 15.0),
                                        labelText: "مثال: 0512345678",
                                        hintText: "مثال: 0512345678",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)))),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          widget.department == "السيارات"
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10, left: 10),
                                        child: Text(
                                          "نوع الاعلان؟",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
//                                            fontFamily: 'Estedad-Black',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          widget.department == "السيارات"
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    ListTile(
                                      title: const Text(
                                        'بيع',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
//                                          fontFamily: 'Estedad-Black',
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                      trailing: Radio(
                                        value: SingingCharacter1.sale,
                                        groupValue: _character1,
                                        onChanged: (SingingCharacter1 value) {
                                          setState(() {
                                            _character1 = value;
                                          });
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text(
                                        'تنازل',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
//                                          fontFamily: 'Estedad-Black',
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                      trailing: Radio(
                                        value: SingingCharacter1.give,
                                        groupValue: _character1,
                                        onChanged: (SingingCharacter1 value) {
                                          setState(() {
                                            _character1 = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          widget.department == "السيارات"
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10, left: 10),
                                        child: Text(
                                          "نوع القير؟",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
//                                            fontFamily: 'Estedad-Black',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          widget.department == "السيارات"
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    ListTile(
                                      title: const Text(
                                        'عادي',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
//                                          fontFamily: 'Estedad-Black',
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                      trailing: Radio(
                                        value: SingingCharacter2.manul,
                                        groupValue: _character2,
                                        onChanged: (SingingCharacter2 value) {
                                          setState(() {
                                            _character2 = value;
                                          });
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text(
                                        'اتوماتيك',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
//                                          fontFamily: 'Estedad-Black',
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                      trailing: Radio(
                                        value: SingingCharacter2.outo,
                                        groupValue: _character2,
                                        onChanged: (SingingCharacter2 value) {
                                          setState(() {
                                            _character2 = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          widget.department == "السيارات"
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10, left: 10),
                                        child: Text(
                                          "نوع الوقود؟",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
//                                            fontFamily: 'Estedad-Black',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          widget.department == "السيارات"
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    ListTile(
                                      title: const Text(
                                        'بنزين',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
//                                          fontFamily: 'Estedad-Black',
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                      trailing: Radio(
                                        value: SingingCharacter3.oil,
                                        groupValue: _character3,
                                        onChanged: (SingingCharacter3 value) {
                                          setState(() {
                                            _character3 = value;
                                          });
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text(
                                        'هايبرد-هجين',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
//                                          fontFamily: 'Estedad-Black',
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                      trailing: Radio(
                                        value: SingingCharacter3.haiprd,
                                        groupValue: _character3,
                                        onChanged: (SingingCharacter3 value) {
                                          setState(() {
                                            _character3 = value;
                                          });
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text(
                                        'ديزل',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
//                                          fontFamily: 'Estedad-Black',
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                      trailing: Radio(
                                        value: SingingCharacter3.solar,
                                        groupValue: _character3,
                                        onChanged: (SingingCharacter3 value) {
                                          setState(() {
                                            _character3 = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          widget.department == "السيارات"
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10, left: 10),
                                        child: Text(
                                          "حالة السيارة؟",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
//                                            fontFamily: 'Estedad-Black',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          widget.department == "السيارات"
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    ListTile(
                                      title: const Text(
                                        'مستعملة',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
//                                          fontFamily: 'Estedad-Black',
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                      trailing: Radio(
                                        value: SingingCharacter4.used,
                                        groupValue: _character4,
                                        onChanged: (SingingCharacter4 value) {
                                          setState(() {
                                            _character4 = value;
                                          });
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text(
                                        'جديدة وكالة',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
//                                          fontFamily: 'Estedad-Black',
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                      trailing: Radio(
                                        value: SingingCharacter4.New,
                                        groupValue: _character4,
                                        onChanged: (SingingCharacter4 value) {
                                          setState(() {
                                            _character4 = value;
                                          });
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text(
                                        'مصدومة',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
//                                          fontFamily: 'Estedad-Black',
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                      trailing: Radio(
                                        value: SingingCharacter4.crashed,
                                        groupValue: _character4,
                                        onChanged: (SingingCharacter4 value) {
                                          setState(() {
                                            _character4 = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          widget.department == "السيارات"
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10, left: 10),
                                        child: Text(
                                          "الدبل؟",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
//                                            fontFamily: 'Estedad-Black',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          widget.department == "السيارات"
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    ListTile(
                                      title: const Text(
                                        'نعم',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
//                                          fontFamily: 'Estedad-Black',
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                      trailing: Radio(
                                        value: SingingCharacter5.yes,
                                        groupValue: _character5,
                                        onChanged: (SingingCharacter5 value) {
                                          setState(() {
                                            _character5 = value;
                                          });
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text(
                                        'لا',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
//                                          fontFamily: 'Estedad-Black',
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                      trailing: Radio(
                                        value: SingingCharacter5.no,
                                        groupValue: _character5,
                                        onChanged: (SingingCharacter5 value) {
                                          setState(() {
                                            _character5 = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          widget.department == "السيارات"
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10, left: 10),
                                        child: Text(
                                          "العداد:  ${(_value * 500000).round()}   الف كم",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
//                                            fontFamily: 'Estedad-Black',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          widget.department == "السيارات"
                              ? Row(
                                  textDirection: TextDirection.rtl,
                                  children: <Widget>[
                                    Expanded(
                                        child: new Slider(
                                            value: _value,
                                            onChanged: _setvalue)),
                                    Text(
                                      ' كم${(_value * 500000).round()} ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
//                                        fontFamily: 'Estedad-Black',
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  child: Text(
                                    "حدد السعر",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
//                                      fontFamily: 'Estedad-Black',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  child: Icon(
                                    Icons.monetization_on,
                                    color: const Color(0xff171732),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 80,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Card(
                                elevation: 0.0,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                    textAlign: TextAlign.right,
                                    keyboardType: TextInputType.number,
                                    textDirection: TextDirection.rtl,
                                    controller: _priceController,
//                                    validator: (String value) {
////                                      if ((value.isEmpty)) {
////                                        return "اكتب السعر حق إعلانك طال عمرك";
////                                      }
////                                    },
                                    decoration: InputDecoration(
                                        errorStyle: TextStyle(
                                            color: Colors.red, fontSize: 15.0),
                                        labelText: "ادخل السعر....",
                                        hintText: "ادخل السعر....",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)))),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  child: Text(
                                    "نص الاعلان",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
//                                      fontFamily: 'Estedad-Black',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  child: Icon(
                                    Icons.rate_review,
                                    color: const Color(0xff171732),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 300,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Card(
                                elevation: 0.0,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Directionality(

                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                    controller: _detailController,
                                    validator: (String value) {
                                      if ((value.isEmpty)) {
                                        return "اكتب تفاصيل حق إعلانك طال عمرك";
                                      }
                                    },
                                    maxLength: 100,
                                    maxLines: 2,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            new EdgeInsets.symmetric(
                                                vertical: 100.0),
                                        errorStyle: TextStyle(
                                            color: Colors.red, fontSize: 15.0),
                                        labelText: "ادخل نص الاعلان....",
                                        hintText: "ادخل نص الاعلان....",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)))),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            /*MediaQuery.of(context).size.width*/
                            height: 50,
                            child: new RaisedButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  ),
                                  new Text(
                                    "إرسال",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
//                                      fontFamily: 'Estedad-Black',
                                    ),
                                  ),
                                ],
                              ),
                              textColor: Colors.white,
                              color: const Color(0xff171732),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  if (sampleImage1 != null&& (dep1!=null||dep1!="")&&(dep2!=null||dep2!="")) {
                                    try {
                                      final result =
                                          await InternetAddress.lookup(
                                              'google.com');
                                      if (result.isNotEmpty &&
                                          result[0].rawAddress.isNotEmpty) {
                                        uploadpp1();

                                        setState(() {
                                          _load2 = true;
                                        });
                                      }
                                    } on SocketException catch (_) {
                                      Toast.show(
                                          "انت غير متصل بشبكة إنترنت طال عمرك",
                                          context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.BOTTOM);
                                    }
                                  } else {
                                    Toast.show(
                                        "ضيف صورة علي الاقل حق إعلانك طال عمرك",
                                        context,
                                        duration: Toast.LENGTH_SHORT,
                                        gravity: Toast.BOTTOM);
                                  }
                                }
                              },
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(10.0)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
            new Align(
              child: loadingIndicator,
              alignment: FractionalOffset.center,
            ),
          ],
        ));
  }

  void _onDropDownItemSelectedreg(String newValueSelected) {
    setState(() {
      this._regioncurrentItemSelected = newValueSelected;
    });
  }

  void _onDropDownItemSelecteddep(String newValueSelected) {
    setState(() {
      this._departcurrentItemSelected = newValueSelected;
      setState(() {
        widget.department = newValueSelected;
      });
    });
  }

  Future getImage1() async {
    var tempImage1 = await ImagePicker.pickImage(source: ImageSource.gallery);

    ///***************************************
    final tempDir1 = await getTemporaryDirectory();
    final path1 = tempDir1.path;

    int rand1 = new Math.Random().nextInt(100000);

    Img.Image image1 = Img.decodeImage(tempImage1.readAsBytesSync());
    Img.Image smallerImg1 = Img.copyResizeCropSquare(image1, 500);
    var compressImg1 = new File("$path1/image1_$rand1.jpg")
      ..writeAsBytesSync(Img.encodeJpg(smallerImg1, quality: 50));

    /// **********************************
    setState(() {
      imagepathes=imagepathes+"$path1/image1_$rand1.jpg,";

      sampleImage1 = compressImg1;
      picno++;
      // Toast.show(sampleImage1.toString(),context,duration: Toast.LENGTH_SHORT,gravity:  Toast.BOTTOM);
    });
  }

  Future getImage2() async {
    var tempImage2 = await ImagePicker.pickImage(source: ImageSource.gallery);

    ///***************************************
    final tempDir2 = await getTemporaryDirectory();
    final path2 = tempDir2.path;

    int rand2 = new Math.Random().nextInt(100000);

    Img.Image image2 = Img.decodeImage(tempImage2.readAsBytesSync());
    Img.Image smallerImg2 = Img.copyResizeCropSquare(image2, 500);
    var compressImg2 = new File("$path2/image2_$rand2.jpg")
      ..writeAsBytesSync(Img.encodeJpg(smallerImg2, quality: 50));

    /// **********************************
    setState(() {
      imagepathes=imagepathes+"$path2/image2_$rand2.jpg,";
      sampleImage2 = compressImg2;
      picno++;
      // Toast.show(sampleImage1.toString(),context,duration: Toast.LENGTH_SHORT,gravity:  Toast.BOTTOM);
    });
  }

  Future getImage3() async {
    var tempImage3 = await ImagePicker.pickImage(source: ImageSource.gallery);

    ///***************************************
    final tempDir3 = await getTemporaryDirectory();
    final path3 = tempDir3.path;

    int rand3 = new Math.Random().nextInt(100000);

    Img.Image image3 = Img.decodeImage(tempImage3.readAsBytesSync());
    Img.Image smallerImg3 = Img.copyResizeCropSquare(image3, 500);
    var compressImg3 = new File("$path3/image3_$rand3.jpg")
      ..writeAsBytesSync(Img.encodeJpg(smallerImg3, quality: 50));

    /// **********************************
    setState(() {
      imagepathes=imagepathes+"$path3/image3_$rand3.jpg,";

      sampleImage3 = compressImg3;
      picno++;
      // Toast.show(sampleImage1.toString(),context,duration: Toast.LENGTH_SHORT,gravity:  Toast.BOTTOM);
    });
  }
  Future getImage4() async {
    var tempImage4 = await ImagePicker.pickImage(source: ImageSource.gallery);

    ///***************************************
    final tempDir4 = await getTemporaryDirectory();
    final path4 = tempDir4.path;

    int rand4 = new Math.Random().nextInt(100000);

    Img.Image image4 = Img.decodeImage(tempImage4.readAsBytesSync());
    Img.Image smallerImg4 = Img.copyResizeCropSquare(image4, 500);
    var compressImg4 = new File("$path4/image4_$rand4.jpg")
      ..writeAsBytesSync(Img.encodeJpg(smallerImg4, quality: 50));

    /// **********************************
    setState(() {
      imagepathes=imagepathes+"$path4/image4_$rand4.jpg,";

      sampleImage4 = compressImg4;
      picno++;
      // Toast.show(sampleImage1.toString(),context,duration: Toast.LENGTH_SHORT,gravity:  Toast.BOTTOM);
    });
  }
  Future getImage5() async {
    var tempImage5 = await ImagePicker.pickImage(source: ImageSource.gallery);

    ///***************************************
    final tempDir5 = await getTemporaryDirectory();
    final path5= tempDir5.path;

    int rand5 = new Math.Random().nextInt(100000);

    Img.Image image5 = Img.decodeImage(tempImage5.readAsBytesSync());
    Img.Image smallerImg5 = Img.copyResizeCropSquare(image5, 500);
    var compressImg5= new File("$path5/image5_$rand5.jpg")
      ..writeAsBytesSync(Img.encodeJpg(smallerImg5, quality: 50));

    /// **********************************
    setState(() {
      imagepathes=imagepathes+"$path5/image5_$rand5.jpg,";

      sampleImage5 = compressImg5;
      picno++;
      // Toast.show(sampleImage1.toString(),context,duration: Toast.LENGTH_SHORT,gravity:  Toast.BOTTOM);
    });
  }
  Future getImage6() async {
    var tempImage6 = await ImagePicker.pickImage(source: ImageSource.gallery);

    ///***************************************
    final tempDir6 = await getTemporaryDirectory();
    final path6 = tempDir6.path;

    int rand6 = new Math.Random().nextInt(100000);

    Img.Image image6 = Img.decodeImage(tempImage6.readAsBytesSync());
    Img.Image smallerImg6 = Img.copyResizeCropSquare(image6, 500);
    var compressImg6 = new File("$path6/image6_$rand6.jpg")
      ..writeAsBytesSync(Img.encodeJpg(smallerImg6, quality: 50));

    /// **********************************
    setState(() {
      imagepathes=imagepathes+"$path6/image6_$rand6.jpg,";

      sampleImage6 = compressImg6;
      picno++;
      // Toast.show(sampleImage1.toString(),context,duration: Toast.LENGTH_SHORT,gravity:  Toast.BOTTOM);
    });
  }
  Future getImage7() async {
    var tempImage7 = await ImagePicker.pickImage(source: ImageSource.gallery);

    ///***************************************
    final tempDir7 = await getTemporaryDirectory();
    final path7 = tempDir7.path;

    int rand7 = new Math.Random().nextInt(100000);

    Img.Image image7 = Img.decodeImage(tempImage7.readAsBytesSync());
    Img.Image smallerImg7 = Img.copyResizeCropSquare(image7, 500);
    var compressImg7 = new File("$path7/image7_$rand7.jpg")
      ..writeAsBytesSync(Img.encodeJpg(smallerImg7, quality: 50));

    /// **********************************
    setState(() {
      imagepathes=imagepathes+"$path7/image7_$rand7.jpg,";

      sampleImage7 = compressImg7;
      picno++;
      // Toast.show(sampleImage1.toString(),context,duration: Toast.LENGTH_SHORT,gravity:  Toast.BOTTOM);
    });
  }




  Future uploadpp1() async {
    // Toast.show("22222",context,duration: Toast.LENGTH_SHORT,gravity:  Toast.BOTTOM);

    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child('myimage');
    DateTime now = DateTime.now();

//    String currentTime = new DateTime(now.year, now.month, now.day, now.hour, now.minute) as String;
    final StorageUploadTask uploadTask =
        storageRef.child('$now.jpg').putFile(sampleImage1);
    var Imageurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url1 = Imageurl.toString();
    //print('URL Is $url1');

    Toast.show("الصورة الاولي اتحملت طال عمرك", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    setState(() {
      urlList.add(url1);
      _load2 = false;
    });
    if (picno >= 2) {
      uploadpp2(url1);
    } else if (picno == 1) {
      createRecord(url1);
    }
    setState(() {
      _load2 = true;
    });
  }

  Future uploadpp2(url1) async {
    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child('myimage');
    DateTime now = DateTime.now();

//    String currentTime = new DateTime(now.year, now.month, now.day, now.hour, now.minute) as String;
    final StorageUploadTask uploadTask =
        storageRef.child('$now.jpg').putFile(sampleImage2);
    var Imageurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url2 = Imageurl.toString();
    // print('URL Is $url');
    setState(() {
      _load2 = false;
    });
    Toast.show("الصورة الثانية اتحملت طال عمرك", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    // uploadwp(url);
    setState(() {
      urlList.add(url2);
      // _load1 = false;
    });
    if (picno >= 3) {
      uploadpp3(url1);
    } else if (picno == 2) {
      createRecord(url1);
    }
    setState(() {
      _load2 = true;
    });
  }
  Future uploadpp3(url1) async {
    final StorageReference storageRef =
    FirebaseStorage.instance.ref().child('myimage');
    DateTime now = DateTime.now();

//    String currentTime = new DateTime(now.year, now.month, now.day, now.hour, now.minute) as String;
    final StorageUploadTask uploadTask =
    storageRef.child('$now.jpg').putFile(sampleImage3);
    var Imageurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url2 = Imageurl.toString();
    // print('URL Is $url');
    setState(() {
      _load2 = false;
    });
    Toast.show("الصورة الثالثة اتحملت طال عمرك", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    // uploadwp(url);
    setState(() {
      urlList.add(url2);
      // _load1 = false;
    });
    if (picno >= 4) {
      uploadpp4(url1);
    } else if (picno == 3) {
      createRecord(url1);
    }
    setState(() {
      _load2 = true;
    });
  }
  Future uploadpp4(url1) async {
    final StorageReference storageRef =
    FirebaseStorage.instance.ref().child('myimage');
    DateTime now = DateTime.now();

//    String currentTime = new DateTime(now.year, now.month, now.day, now.hour, now.minute) as String;
    final StorageUploadTask uploadTask =
    storageRef.child('$now.jpg').putFile(sampleImage4);
    var Imageurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url2 = Imageurl.toString();
    // print('URL Is $url');
    setState(() {
      _load2 = false;
    });
    Toast.show("الصورة الرابعة اتحملت طال عمرك", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    // uploadwp(url);
    setState(() {
      urlList.add(url2);
      // _load1 = false;
    });
    if (picno >= 5) {
      uploadpp5(url1);
    } else if (picno == 4) {
      createRecord(url1);
    }
    setState(() {
      _load2 = true;
    });
  }
  Future uploadpp5(url1) async {
    final StorageReference storageRef =
    FirebaseStorage.instance.ref().child('myimage');
    DateTime now = DateTime.now();

//    String currentTime = new DateTime(now.year, now.month, now.day, now.hour, now.minute) as String;
    final StorageUploadTask uploadTask =
    storageRef.child('$now.jpg').putFile(sampleImage5);
    var Imageurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url2 = Imageurl.toString();
    // print('URL Is $url');
    setState(() {
      _load2 = false;
    });
    Toast.show("الصورة الخامسة اتحملت طال عمرك", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    // uploadwp(url);
    setState(() {
      urlList.add(url2);
      // _load1 = false;
    });
    if (picno >= 6) {
      uploadpp6(url1);
    } else if (picno == 5) {
      createRecord(url1);
    }
    setState(() {
      _load2 = true;
    });
  }
  Future uploadpp6(url1) async {
    final StorageReference storageRef =
    FirebaseStorage.instance.ref().child('myimage');
    DateTime now = DateTime.now();

//    String currentTime = new DateTime(now.year, now.month, now.day, now.hour, now.minute) as String;
    final StorageUploadTask uploadTask =
    storageRef.child('$now.jpg').putFile(sampleImage6);
    var Imageurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url2 = Imageurl.toString();
    // print('URL Is $url');
    setState(() {
      _load2 = false;
    });
    Toast.show("الصورة السادسة اتحملت طال عمرك", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    // uploadwp(url);
    setState(() {
      urlList.add(url2);
      // _load1 = false;
    });
    if (picno >= 7) {
      uploadpp7(url1);
    } else if (picno == 6) {
      createRecord(url1);
    }
    setState(() {
      _load2 = true;
    });
  }

  Future uploadpp7(url1) async {
    // Toast.show("22222",context,duration: Toast.LENGTH_SHORT,gravity:  Toast.BOTTOM);

    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child('myimage');
    DateTime now = DateTime.now();

//    String currentTime = new DateTime(now.year, now.month, now.day, now.hour, now.minute) as String;
    final StorageUploadTask uploadTask =
        storageRef.child('$now.jpg').putFile(sampleImage7);
    var Imageurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url3 = Imageurl.toString();
    //print('URL Is $url3');
    setState(() {
      // _load1 = false;
    });
    Toast.show("الصورة السابعة اتحملت طال عمرك", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    // uploadwp(url);
    setState(() {
      urlList.add(url3);
      _load2 = false;
    });
    createRecord(url1);

    setState(() {
      _load2 = true;
    });
  }

  void createRecord(url1) {
    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? null
        : setState(() {
            _userId = user.uid;
            DateTime now = DateTime.now();
            String date =
                '${now.year}-${now.month}-${now.day}-${now.hour}-${now.minute}-00-000';

            String b = now.month.toString();
            if (b.length < 2) {
              b = "0" + b;
            }
            String c = now.day.toString();
            if (c.length < 2) {
              c = "0" + c;
            }
            String d = now.hour.toString();
            if (d.length < 2) {
              d = "0" + d;
            }
            String e = now.minute.toString();
            if (e.length < 2) {
              e = "0" + e;
            }
            String date1 =
                '${now.year}-${b}-${c} ${d}:${e}:00';

            advdatabaseReference.child(_userId).child(date).set({
              'cId': _userId,
              'cdate': date1,
              'chead': date,
              'ctitle': _titleController.text,
              'cdepart': _departcurrentItemSelected,
              'cregion': _regioncurrentItemSelected,
              'cphone': _phoneController.text,
              'cprice': _priceController.text,
              'cdetail': _detailController.text,
              'cpublished': false,
              'curi': url1,
              'curilist': urlList.toString(),
              //////////////////////////
              'cagekm': widget.department == "السيارات"
                  ? '${(_value * 500000).round()}'
                  : "0",
              'csale': widget.department == "السيارات"
                  ? (_character1.toString().contains("sale") ? "بيع" : "تنازل")
                  : "",
              'cauto': widget.department == "السيارات"
                  ? _character2.toString().contains("outo")
                      ? "أتوماتيك"
                      : "عادى"
                  : "",
              'coil': widget.department == "السيارات"
                  ? _character3.toString().contains("oil")
                      ? "بنزين"
                      : _character3.toString().contains("solar")
                          ? "ديزل"
                          : "هايبرد-هجين"
                  : "",
              'cNew': widget.department == "السيارات"
                  ? _character4.toString().contains("used")
                      ? "مستعملة"
                      : _character4.toString().contains("New")
                          ? "جديدة وكالة"
                          : "مصدومة"
                  : "",
              'cno': widget.department == "السيارات"
                  ? _character5.toString().contains("yes") ? "نعم" : "لا"
                  : "",
              'cdep11': dep1,
              'cdep22': dep2,


            }).whenComplete(() {
              //   Toast.show("تم إرسال طلبك للمراجعه بنجاح",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);

              //showInSnackBar("تم إرسال طلبك للمراجعه بنجاح");
              setState(() {
                _load2 = false;
                urlList.clear();
                _titleController.text = "";
                _phoneController.text = "";
                _priceController.text = "";
                _detailController.text = "";
                _departcurrentItemSelected = widget.departlist[widget.index];
                _regioncurrentItemSelected = widget.regionlist[0];
                _character2 = SingingCharacter2.outo;
                _character3 = SingingCharacter3.oil;
                _character4 = SingingCharacter4.New;
                _character5 = SingingCharacter5.no;
                _value = 0;
              });
              showNotification(date1,_titleController.text,_userId,date, _cName);

              showAlertDialog(context);
            }).catchError((e) {
              Toast.show(e, context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              setState(() {
                _load2 = false;
              });
            });
          }));
  }

  showAlertDialog(BuildContext context) {
//    // set up the button
//    Widget okButton = FlatButton(
//      child: Text("تم"),
//      onPressed: () {
//        Navigator.push(context,
//            MaterialPageRoute(builder: (context) => AllAdvertesmenta()));
//      },
//    );
//
//    // set up the AlertDialog
//    CupertinoDialogAction alert = CupertinoDialogAction(
//
//      title: Text("تهانناا"),
//      content: Text("إعلانك موجود الحين ضمن شبكة سوق نجران"),
//      actions: [
//        okButton,
//      ],
//    );

    // show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
                title: new Text("تهاننا"),
                content: new Text("إعلانك موجود الحين ضمن شبكة سوق نجران"),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: false,
                    child: new FlatButton(
                      child: Text("تم"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FragmentSouq1(widget.regionlist)));
                      },
                    ),
                  )
                ]));
  }
  void onSubmit3(String result) {
    setState(() {
      dep1=result.split(",")[0];
      dep2=result.split(",")[1];
      Toast.show("${result.split(",")[0]}///////${result.split(",")[1]}", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

    });
  }
}
//////////////////////////////////

typedef void MyFormCallback3(String result);

class MyForm3 extends StatefulWidget {
  final MyFormCallback3 onSubmit3;
  String dep;

  MyForm3(this.dep, {this.onSubmit3});

  @override
  _MyForm3State createState() => _MyForm3State();
}

class _MyForm3State extends State<MyForm3> {
  String _currentValue = '';
  String _currentValue1 = '';

  List<DepartmentClass> departlist1 = [];



  @override
  void initState() {
    super.initState();
    _currentValue = widget.dep;

    final departments1databaseReference =
    FirebaseDatabase.instance.reference().child("Departments1").child(widget.dep);
    print("##########${widget.dep}");
    departments1databaseReference.once().then((DataSnapshot snapshot) {
      var KEYS = snapshot.value.keys;
      var DATA = snapshot.value;
      //Toast.show("${snapshot.value.keys}",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
      print("kkkk${DATA.toString()}");

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
          false,
          DATA[individualkey]['arrange'],
        );
      //  print("kkkkkkkkk"+ctitle+ DATA[individualkey]['title']);
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
          departlist1.add(departmentclass);
          setState(() {
            print("size of list : 5");
            departlist1.sort((depart1, depart2) =>
                depart1.arrange.compareTo(depart2.arrange));
          });
        });
        // }
      }


    });
  }


  @override
  Widget build(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("إلغاء"),
      onPressed: () {
        setState(() {
          Navigator.pop(context);
        });
      },
    );
    Widget continueButton = FlatButton(
      child: Text("حفظ"),
      onPressed: () {
        setState(() {
          Navigator.pop(context);
          widget.onSubmit3(_currentValue1.toString()+","+_currentValue.toString());
        });
      },
    );
    return AlertDialog(
      title: Text(
        widget.dep,
        style: TextStyle(fontWeight: FontWeight.bold),
        textDirection: TextDirection.rtl,
      ),
      content:new ListView.builder(
        itemCount: departlist1.length,
        itemBuilder: (context, i) {
          return new ExpansionTile(
            title: new Text(departlist1[i].title, style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
            children: <Widget>[
              Column(
                // padding: EdgeInsets.all(8.0),
                children: departlist1[i].subtitle!=null? departlist1[i].subtitle.split(",")
                    .map((value) => RadioListTile(
                  groupValue: _currentValue,
                  title: Text(
                    value,
                    textDirection: TextDirection.rtl,
                  ),
                  value: value,
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      _currentValue = val;
                      _currentValue1=departlist1[i].title;
                    });
                  },
                ))
                    .toList():departlist1[i].title.split(",")
                    .map((value) => RadioListTile(
                  groupValue: _currentValue,
                  title: Text(
                    value,
                    textDirection: TextDirection.rtl,
                  ),
                  value: value,
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      _currentValue = val;
                      _currentValue1=departlist1[i].title;
                    });
                  },
                ))
                    .toList(),
              ),
//              new Column(
//                children:
//                _buildExpandableContent(regionlist[i]),
//              ),
            ],
          );
        },
      ),

      actions: [
        cancelButton,
        continueButton,
      ],
    );
  }
}
