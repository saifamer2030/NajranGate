import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'SmsForUserClass.dart';

class SmsForUserPage extends StatefulWidget {
  SmsForUserPage(this.smsForUserPage);

  SmsForUser smsForUserPage;

  @override
  _SmsForUserPage createState() => new _SmsForUserPage();
}

final Reference = FirebaseDatabase.instance.reference().child('SMSForUser');

class _SmsForUserPage extends State<SmsForUserPage> {
  FirebaseAuth _firebaseAuth;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  // تعريف الايتم المراد ادخال قيم فيها
  TextEditingController _Name;
  TextEditingController _Emali;
  TextEditingController _City;
  TextEditingController _Phone;
  TextEditingController _SmsText;

/////////////// لتهئة الداتا بيز وعرض البيانات فور فتح التطبيق ///////////
  @override
  void initState() {
    super.initState();
    _firebaseAuth = FirebaseAuth.instance;

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    var initSettings = InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
//      onSelectNotification: onSelectNotification,
    );

    // ربط الايتم بالقيم
    _Name = new TextEditingController(text: widget.smsForUserPage.name);
    _Emali = new TextEditingController(text: widget.smsForUserPage.email);
    _City = new TextEditingController(text: widget.smsForUserPage.city);
    _Phone = new TextEditingController(text: widget.smsForUserPage.phone);
    _SmsText = new TextEditingController(text: widget.smsForUserPage.smsText);
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
//        backgroundColor: Colors.white,
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
                        alignment: Alignment.centerLeft,
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
                padding: const EdgeInsets.only(top: 40),
                child: Center(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 5.0, right: 5.0),
                            child: Card(
                              elevation: 0.0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextField(
                                controller: _Name,
                                onChanged: (value) {},
                                //  controller: controller,
                                decoration: InputDecoration(
                                    labelText: "اسمك الكامل طال عمرك",
                                    hintText: "اسمك الكامل طال عمرك",
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: const Color(0xff171732),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)))),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Card(
                              elevation: 0.0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextField(
                                controller: _Emali,
                                onChanged: (value) {},
                                //  controller: controller,
                                decoration: InputDecoration(
                                    labelText: "ايميلك طال عمرك",
                                    hintText: "ايميلك طال عمرك",
                                    prefixIcon: Icon(
                                      Icons.alternate_email,
                                      color:  const Color(0xff171732),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)))),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Card(
                              elevation: 0.0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextField(
                                controller: _City,
                                onChanged: (value) {},
                                //  controller: controller,
                                decoration: InputDecoration(
                                    labelText: "الحي طال عمرك",
                                    hintText: "الحي طال عمرك",
                                    prefixIcon: Icon(
                                      Icons.location_city,
                                      color:  const Color(0xff171732),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)))),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Card(
                              elevation: 0.0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: _Phone,
                                onChanged: (value) {},
                                //  controller: controller,
                                decoration: InputDecoration(
                                    labelText: "رقم جوالك طال عمرك",
                                    hintText: "رقم جوالك طال عمرك",
                                    prefixIcon: Icon(
                                      Icons.phone_iphone,
                                      color:  const Color(0xff171732),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)))),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Card(
                              elevation: 0.0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextField(
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                                maxLines: null,
                                controller: _SmsText,
                                onChanged: (value) {},
                                //  controller: controller,
                                decoration: InputDecoration(
                                    labelText:
                                        "ارسل لنا رايك او اي مشكلة تواجها سواء مشكلة تقنيه او مشكلة مع مزود الخدمة",
                                    hintText:
                                        "ارسل لنا رايك او اي مشكلة تواجها سواء مشكلة تقنيه او مشكلة مع مزود الخدمة",
                                    hintStyle: TextStyle(fontSize: 10.0),
                                    labelStyle: TextStyle(fontSize: 10.0),
                                    prefixIcon: Icon(
                                      Icons.comment,
                                      color:  const Color(0xff171732),
                                    ),
                                    contentPadding:
                                        new EdgeInsets.symmetric(vertical: 50.0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)))),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Container(
                              width: 300 /*MediaQuery.of(context).size.width*/,
                              height: 50,
                              child: new RaisedButton(
                                child: new Text("إرسال الشكوي"),
                                textColor: Colors.white,
                                color: Colors.red,
                                onPressed: () {
                                  User(
                                      name: _Name.text,
                                      email: _Emali.text,
                                      city: _City.text,
                                      phone: _Phone.text,
                                      smstext: _SmsText.text);
                                },
//
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(10.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void User(
      {String name,
      String email,
      String city,
      String phone,
      String smstext}) async {
    FirebaseUser usr = await _firebaseAuth.currentUser();
    if (usr != null &&
        smstext != "" &&
        name != "" &&
        email != "" &&
        city != "" &&
        phone != "") {
      Reference.child(usr.uid).push().set({
        'Name': _Name.text,
        'Email': _Emali.text,
        'District': _City.text,
        'Phone': _Phone.text,
        'SmsText': _SmsText.text,
      }).then((_) {
        Fluttertoast.showToast(
            msg: "تم إرسال ملاحظاتك وسوف يتم الرد عليك في اقرب وقت",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            fontSize: 15.0,
            textColor: Colors.white,
            backgroundColor:  const Color(0xff171732),);
        showNotification();
        Navigator.of(context).pop();

      });
    } else {
      Fluttertoast.showToast(
          msg: "برجاء ملئ النموذج بالكامل",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          fontSize: 15.0,
          textColor: Colors.white,
          backgroundColor:  const Color(0xff171732),);
    }
  }

  showNotification() async {
    var android = AndroidNotificationDetails(
        'com.arabdevelopers.souqnagran', 'NajranGate', 'channel description',
        importance: Importance.Max);
    var ios = IOSNotificationDetails();
    var platform = NotificationDetails(android, ios);
    await flutterLocalNotificationsPlugin.show(
        1,
        'سوف نراجع ملاحظاتك وسوف نقوم بالرد عليك',
        'انتظر اتصالنا بك ثقتك محل إهتمامنا',
        platform,
        payload: 'Hello, Flutter!');
  }
}
