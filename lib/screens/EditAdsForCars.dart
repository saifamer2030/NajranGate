import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:NajranGate/FragmentSouqNajran.dart';
import 'package:NajranGate/classes/DepartmentClass.dart';
import 'package:NajranGate/screens/alladvertsments.dart';
import 'package:NajranGate/screens/splash.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;
import 'package:image/image.dart' as Img;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';

import 'advprofile.dart';
import 'myadvertisement.dart';

class EditAdsForCars extends StatefulWidget {
  int position;
      int length;
  String cId;
      String cdate;
  String chead;
      String ctitle;
  String cdepart;
      String cregion;
  String cphone;
      String cprice;
      String cmodel;
  String cdetail;
      bool cpublished;
  String curi;
      String curilist;
  String cagekm;
      String csale;
  String cauto;
      String coil;
  String cNew;
      String cno;
  String cname;
  List<String> departlist = [];
  List<String> regionlist = [];
  String cdep11;
  String cdep22;
  int arrange;
  EditAdsForCars(this.position, this.length, this.cId,
  this.cdate,
  this.chead,
  this.ctitle,
  this.cdepart,
  this.cregion,
  this.cphone,
  this.cprice,
  this.cdetail,
  this.cpublished,
  this.curi,
  this.curilist,
  this.cagekm,
  this.csale,
  this.cauto,
  this.coil,
  this.cNew,
  this.cno,
  this.cname,
      this.departlist,
      this.regionlist,
      this.cdep11,
      this.cdep22,
      this.cmodel,this.arrange
  );

  @override
  _EditAdsForCarsState createState() => _EditAdsForCarsState();
}

enum SingingCharacter1 { sale, give }
enum SingingCharacter2 { outo, manul }
enum SingingCharacter3 { solar, oil, haiprd }
enum SingingCharacter4 { used, New, crashed }
enum SingingCharacter5 { yes, no }

class _EditAdsForCarsState extends State<EditAdsForCars> {
  final double _minimumPadding = 5.0;
  var _formKey = GlobalKey<FormState>();
  bool _load2 = false;
  String _userId;
  String dep1="اخري";
  String dep2="اخري";
  int picno = 0;
  SingingCharacter1 _character1 = SingingCharacter1.sale;
  SingingCharacter2 _character2 = SingingCharacter2.outo;
  SingingCharacter3 _character3 = SingingCharacter3.oil;
  SingingCharacter4 _character4 = SingingCharacter4.New;
  SingingCharacter5 _character5 = SingingCharacter5.no;
  //List<String> urlList = [];
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String _cName;
  List<Asset> images = List<Asset>();
  String _uri;
  String url1;

  String _urilist;
  List<String> _imageUrls;
  final advdatabaseReference =
  FirebaseDatabase.instance.reference().child("advdata");
  String _error = 'No Error Dectected';

  String csale,cauto,coil,cNew,cno;
  double _value = 0.0;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _modelController = TextEditingController();
  TextEditingController _detailController = TextEditingController();
  var _departcurrentItemSelected = '';
  var _regioncurrentItemSelected = '';

  void _setvalue(double value) => setState(() => _value = value);

  Future onSelectNotification(String payload) async {
    if (payload != null) {
     await Navigator.push(
       context,
       new MaterialPageRoute(
           builder: (context) =>
           new AdvProlile(payload.split(",")[0], payload.split(",")[1], payload.split(",")[2],0.0)),
      );
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
    print("###################${widget.departlist}");
    setState(() {
      _departcurrentItemSelected = widget.cdepart;
      _regioncurrentItemSelected = widget.cregion;
// print("llll${images.length}");
      _titleController = TextEditingController(text: widget.ctitle);
       _phoneController = TextEditingController(text: widget.cphone);
       _priceController = TextEditingController(text: widget.cprice);
      _modelController = TextEditingController(text: widget.cmodel);
       _detailController = TextEditingController(text: widget.cdetail);
      ((widget.cdep11=="")||(widget.cdep11==null))?dep1="${widget.cdepart} اخري": dep1=widget.cdep11;
      ((widget.cdep22=="")||(widget.cdep22==null))?dep2="${widget.cdepart} اخري": dep2=widget.cdep11;

      //dep2==widget.cdep22;
      _uri=widget.curi;
      _urilist=widget.curilist;
      _imageUrls =_urilist
          .replaceAll(" ", "")
          .replaceAll("[", "")
          .replaceAll("]", "")
          .split(",");
////////////////
      _value =double.parse(widget.cagekm)/2000000;

      csale=widget.csale;
      cauto=widget.cauto;
      coil=widget.coil;
      cNew=widget.cNew;
      cno=widget.cno;

      widget.cdepart == "السيارات"?
      csale=="تنازل"?_character1 = SingingCharacter1.give:_character1 = SingingCharacter1.sale
          :csale=widget.csale;
      widget.cdepart == "السيارات"?
      cauto=="أتوماتيك"?_character2 = SingingCharacter2.outo:_character2 = SingingCharacter2.manul
          :cauto=widget.csale;
      widget.cdepart == "السيارات"?
      cno=="نعم"?_character5 = SingingCharacter5.yes:_character5 = SingingCharacter5.no
          :cno=widget.cno;

      widget.cdepart == "السيارات"?
      coil=="بنزين"?_character3 = SingingCharacter3.oil:coil=="ديزل"?_character3 = SingingCharacter3.solar:_character3 = SingingCharacter3.haiprd
          :coil=widget.cno;
      widget.cdepart == "السيارات"?
      cNew=="مستعملة"?_character4 = SingingCharacter4.used:cNew=="جديدة وكالة"?_character4 = SingingCharacter4.New:_character4 = SingingCharacter4.crashed
          :cNew=widget.cno;

    });
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


  }
  showNotification(date1,title,_userId,head,name) async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@drawable/ic_lancher');
    var ios = IOSInitializationSettings();
    var initSettings = InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onSelectNotification: onSelectNotification,
    );
    DateTime scheduledNotificationDateTime = DateTime.now().add(new Duration(days: 45));
   // DateTime scheduledNotificationDateTime = DateTime.now();

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
        widget.arrange-202000000000,
        'تذكير بحذف الاعلان',
        'عزيزى العميل سيتم حذف اعلان $title بعد اسبوعين يرجى عمل تمديد له',
        scheduledNotificationDateTime,
        platformChannelSpecifics,
        payload://""
        "$_userId,$head,$_cName"
    );
  }
  showAlertDialog1(BuildContext context) {
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
            content: new Text("إعلانك موجود الحين ضمن شبكة بوابة نجران"),
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
  showAlertDialog11(BuildContext context,int index) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("موافق"),
      onPressed: () {
        setState(() {
          //print("aaaa${_imageUrls.length}///$index");
          _urilist=  _urilist.replaceAll( _imageUrls[index], "");
        if(_urilist.contains(", ,")) _urilist= _urilist.replaceAll( ", ,", ",");
        //  print("aaaa${_imageUrls.length}///$index");
          Navigator.pop(context);
          _imageUrls.removeAt(index);
          Future.delayed(Duration(seconds: 0), () async {
            print("dellll");
            FirebaseStorage.instance
                .getReferenceFromUrl(_imageUrls[index])
                .then((reference){ reference.delete();
            print("dellllok");
                }).catchError((e) => print("dellll"+e));
            /////////////////////////////////////
            // StorageReference storageReference =
            // await FirebaseStorage.instance.getReferenceFromUrl(_imageUrls[index]);
            //
            // print("dellll"+storageReference.path);
            //
            // await storageReference.delete().whenComplete(() {
            // print("dellll");
            // }).catchError((e){print("dellll$e");});
///////////////////////////////////////////////////////////////
//             final StorageReference storageRef =
//             await FirebaseStorage.instance.getReferenceFromUrl(_imageUrls[index]);
//             await storageRef.delete().whenComplete(() {
// print("del");
//             }).catchError((e){print("del$e");});

            //  final StorageReference storageRef =FirebaseStorage.instance.ref().child('myimage');
            //  final StorageReference storageRef =
            // await FirebaseStorage.instance.getReferenceFromUrl(_imageUrls[index]);
            // await storageRef.delete();
          });


        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("مسح صورة"),
      content: Text("هل انت موافق على مسح الصورة"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(_imageUrls.length, (index) {

        return  Container(
          width: 300,
          height: 300,
          child: Stack(
            children: <Widget>[
              new Image.network(
                _imageUrls[index],
                fit: BoxFit.contain,
              ),
          IconButton(
              icon: Icon(Icons.close,color: Colors.red,size:35),
              tooltip: 'مسح صورة',
              onPressed: ()  {
                showAlertDialog11(context,index);
              }),
            ],
          ),
        );
      }),
    );
  }
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
print("hhhhhhhhh");
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10-_imageUrls.length,
        enableCamera: false,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "اعلان"),
        materialOptions: MaterialOptions(
          statusBarColor: "#000000",
          actionBarColor: "#000000",
          actionBarTitle: "بوابة نجران",
          allViewTitle: "كل الصور",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
      // print("hhh$e");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    //  picno = images.length;

      //    print("hhhh$images");
    });
  }
  Future uploadpp0() async {
    if (images.length==0) {
      createRecord();
    } else {
    final StorageReference storageRef =
    FirebaseStorage.instance.ref().child('myimage');
    int i = 0;
    for (var f in images) {
      var byteData = await f.getByteData(quality: 20);
      DateTime now = DateTime.now();
      final file = File('${(await getTemporaryDirectory()).path}/$f');
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      final StorageUploadTask uploadTask =
      storageRef.child('$_userId$now.jpg').putFile(file);
      var Imageurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      print("oooo8");

      setState(() {
        url1 = Imageurl.toString();
        _imageUrls.add(url1);
        //  print('URL Is${images.length} ///$url1///$urlList');
        i++;
        // _load2 = false;
      });
      if (i == images.length) {
        // print('gggg${images.length} ///$i');
        createRecord();
      }
    }
    Toast.show("تم تحميل الصور طال عمرك", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    setState(() {
      _load2 = true;
    });
  }
  }
  Widget buildGridViewass() {
    return GridView.count(
      crossAxisCount: 5,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
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
                  width:  MediaQuery.of(context).size.width,
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
                            Icons.arrow_back_ios,
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
                          Center(
                            child: Container(
                              width: 200,
                              height: 200,
                              color: Colors.grey[300],
                              child:Stack(
                                children: <Widget>[
                                  buildGridView(),


                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                            Center(
                            child: Row(
                              mainAxisAlignment:MainAxisAlignment.spaceAround ,
                              children: <Widget>[
                                images==0?Container(): Container(
                                  width: 200,
                                  height: 100,
                                  color: Colors.grey[300],
                                  child:buildGridViewass(),
                                ),
                                IconButton(
                                    icon: Icon(Icons.add_a_photo,color: Colors.grey[800],size:50),
                                    tooltip: 'إضافة صورة',
                                    onPressed: ()  {
                                      print("hhhh111");
                                      loadAssets();
                                    }),
                              ],
                            ),
                          ),


                          // buildGridView(),

                          // Center(
                          //   child: Container(
                          //     height:150,
                          //     width: 150,
                          //     child: new Image.network(
                          //       _uri,
                          //       fit: BoxFit.fitHeight,
                          //     ),
                          //   ),
                          // ),
                          /**InkWell(
                            onTap: () {
//                              if (picno == 0) {
//                                getImage1();
//                              } else if (picno == 1) {
//                                getImage2();
//                              } else if (picno == 2) {
//                                getImage3();
//                              } else {
//                                Toast.show(
//                                    'نحتاج ثلاثة صور فقط حق إعلانك طال عمرك',
//                                    context,
//                                    duration: Toast.LENGTH_SHORT,
//                                    gravity: Toast.BOTTOM);
//                              }
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
                                       child: new Image.network(
                                          _uri,
                                          fit: BoxFit.fitHeight,
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
                          ),**/
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
                                    maxLength: 100,
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


                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyForm3(widget.cdepart,widget.cdep22,
                                                onSubmit3: onSubmit3)));
//                                    setState(() {
//                                      showDialog(
//                                          context: context,
//                                          builder: (context) => MyForm3(widget.cdepart,widget.cdep22,
//                                              onSubmit3: onSubmit3));
//                                    });
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
                                          "القسم الفرعي",
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
                          widget.cdepart == "السيارات"
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
                                     // fontFamily: 'Estedad-Black',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                              : Container(),
                          widget.cdepart == "السيارات"
                              ? Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              ListTile(
                                title: const Text(
                                  'بيع',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                 //   fontFamily: 'Estedad-Black',
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
                              //      fontFamily: 'Estedad-Black',
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
                          widget.cdepart == "السيارات"
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
                                   //   fontFamily: 'Estedad-Black',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                              : Container(),
                          widget.cdepart == "السيارات"
                              ? Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              ListTile(
                                title: const Text(
                                  'عادي',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                   // fontFamily: 'Estedad-Black',
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
                                //    fontFamily: 'Estedad-Black',
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
                          widget.cdepart == "السيارات"
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
                                     // fontFamily: 'Estedad-Black',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                              : Container(),
                          widget.cdepart == "السيارات"
                              ? Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              ListTile(
                                title: const Text(
                                  'بنزين',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                //    fontFamily: 'Estedad-Black',
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
                                 //   fontFamily: 'Estedad-Black',
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
                                  //  fontFamily: 'Estedad-Black',
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
                          widget.cdepart == "السيارات"
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
                                    //  fontFamily: 'Estedad-Black',
                                    ),

                                  ),
                                ),
                              ],
                            ),
                          )
                              : Container(),
                          widget.cdepart == "السيارات"
                              ? Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              ListTile(
                                title: const Text(
                                  'مستعملة',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                 //   fontFamily: 'Estedad-Black',
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
                                  //  fontFamily: 'Estedad-Black',
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
                                  //  fontFamily: 'Estedad-Black',
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
                          widget.cdepart == "السيارات"
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
                                     // fontFamily: 'Estedad-Black',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                              : Container(),
                          widget.cdepart == "السيارات"
                              ? Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              ListTile(
                                title: const Text(
                                  'نعم',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    //fontFamily: 'Estedad-Black',
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
                                   // fontFamily: 'Estedad-Black',
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
                          widget.cdepart == "السيارات"
                              ? Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  child: Text(
                                    "العداد:  ${(_value * 2000000).round()}   الف كم",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                     // fontFamily: 'Estedad-Black',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                              : Container(),
                          widget.cdepart == "السيارات"
                              ? Row(
                            textDirection: TextDirection.rtl,
                            children: <Widget>[
                              Expanded(
                                  child: new Slider(
                                      value: _value,
                                      onChanged: _setvalue)),
                              Text(
                                ' كم${(_value * 2000000).round()} ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                 // fontFamily: 'Estedad-Black',
                                ),
                              ),
                            ],
                          )
                              : Container(),
                          widget.cdepart == "السيارات"
                              ? Container(
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
                                    controller: _modelController,
//                                    validator: (String value) {
////                                      if ((value.isEmpty)) {
////                                        return "اكتب السعر حق إعلانك طال عمرك";
////                                      }
////                                    },
                                    decoration: InputDecoration(
                                        errorStyle: TextStyle(
                                            color: Colors.red,
                                            fontSize: 15.0),
                                        labelText: "ادخل سنة الصنع....",
                                        hintText: "ادخل موديل السيارة....",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.all(
                                                Radius.circular(
                                                    5.0)))),
                                  ),
                                ),
                              ),
                            ),
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
//                                    maxLength: 100,
                                    maxLines: 10,
                                    decoration: InputDecoration(
                                        contentPadding:
                                        new EdgeInsets.symmetric(
                                            vertical: 20.0),
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
                                    "تعديل",
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
                                 // if (sampleImage1 != null|| dep1!=null||dep2!=null||dep1!=""||dep2!="") {
                                    try {
                                      final result =
                                      await InternetAddress.lookup(
                                          'google.com');
                                      if (result.isNotEmpty &&
                                          result[0].rawAddress.isNotEmpty) {
                                        uploadpp0();
                                      //  createRecord();
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
                                  // } else {
                                  //   Toast.show(
                                  //       "ضيف صورة علي الاقل حق إعلانك طال عمرك",
                                  //       context,
                                  //       duration: Toast.LENGTH_SHORT,
                                  //       gravity: Toast.BOTTOM);
                                  // }
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
        widget.cdepart = newValueSelected;
      });
    });
  }


  void createRecord() {
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
print("jjjjjjjj///$_userId///${widget.chead}");
      advdatabaseReference.child(_userId).child(widget.chead).update({
        'cId': _userId,
        'cdate': date1,
        'chead': widget.chead,
        'ctitle': _titleController.text,
        'cdepart': _departcurrentItemSelected,
        'cregion': _regioncurrentItemSelected,
        'cphone': _phoneController.text,
        'cprice': _priceController.text,
        'cdetail': _detailController.text,
        'cpublished': false,

        'curi': _imageUrls[0],
        'curilist': _imageUrls.toString(),
      //////////////////////////
        'cagekm': widget.cdepart == "السيارات"
            ? ' ${(_value * 2000000).round()}'
            : "0",
        'csale': widget.cdepart == "السيارات"
            ? (_character1.toString().contains("sale") ? "بيع" : "تنازل")
            : "",
        'cauto': widget.cdepart == "السيارات"
            ? _character2.toString().contains("outo")
            ? "أتوماتيك"
            : "عادى"
            : "",
        'coil': widget.cdepart == "السيارات"
            ? _character3.toString().contains("oil")
            ? "بنزين"
            : _character3.toString().contains("solar")
            ? "ديزل"
            : "هايبرد-هجين"
            : "",
        'cNew': widget.cdepart == "السيارات"
            ? _character4.toString().contains("used")
            ? "مستعملة"
            : _character4.toString().contains("New")
            ? "جديدة وكالة"
            : "مصدومة"
            : "",
        'cno': widget.cdepart == "السيارات"
            ? _character5.toString().contains("yes") ? "نعم" : "لا"
            : "",
        'cdep11': ((dep1=="اخري")||(dep1=="")||(dep1==null))?"${widget.cdepart} اخري":dep1,
        'cdep22': ((dep2=="اخري")||(dep2=="")||(dep2==null))?"${widget.cdepart} اخري":dep2,


      }).whenComplete(() {
        //   Toast.show("تم إرسال طلبك للمراجعه بنجاح",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => MyAdvertisement(widget.regionlist)));

        //showInSnackBar("تم إرسال طلبك للمراجعه بنجاح");
        setState(() {
        });
        showNotification(date1,_titleController.text,_userId,widget.chead, _cName);

        showAlertDialog1(context);
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
            content: new Text("تم تعديل إعلانك الموجود الحين ضمن شبكة بوابة نجران"),
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
  String dep22;

  MyForm3(this.dep,this.dep22, {this.onSubmit3});

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
    _currentValue = widget.dep22;

    final departments1databaseReference =
    FirebaseDatabase.instance.reference().child("Departments1").child(widget.dep);
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
            false,100
        );
          print("kkkkkkkkk${ DATA[individualkey]['title']}");
        setState(() {
          departlist1.add(departmentclass);

        });
        // }
      }
      setState(() {
        departlist1.add( new DepartmentClass(
            "id",
            "${widget.dep} اخري",
            null,
            "",
            Colors.white,
            false,100
        ));
      });


    });
  }


  @override
  Widget build(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("إلغاء",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      onPressed: () {
        setState(() {
          Navigator.pop(context);
        });
      },
    );
    Widget continueButton = FlatButton(
      child: Text("حفظ",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      onPressed: () {
        setState(() {
          Navigator.pop(context);
          widget.onSubmit3(_currentValue1.toString()+","+_currentValue.toString());
        });
      },
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff171732),
        centerTitle:true ,
        title: Text(
          widget.dep,
          style: TextStyle(fontWeight: FontWeight.bold),
          textDirection: TextDirection.rtl,
        ),

      ),

      body:new ListView.builder(
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
                      widget.onSubmit3(_currentValue1.toString()+","+_currentValue.toString());
                      Navigator.pop(context);
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
                      widget.onSubmit3(_currentValue1.toString()+","+_currentValue.toString());
                      Navigator.pop(context);

                    });
                  },
                ))
                    .toList(),
              ),
//              new Column(
//                children:
//                _buildExpandableContent(regionlist[i]),
//              ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   cancelButton,
//                   continueButton,
//                 ],
//               )
            ],
          );
        },
      ),

    );
  }
}
