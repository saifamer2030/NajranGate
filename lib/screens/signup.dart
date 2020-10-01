import 'dart:io';

import 'package:NajranGate/FragmentSouqNajran.dart';
import 'package:NajranGate/screens/loginphone.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:toast/toast.dart';

import 'loginmail.dart';

class SignUp extends StatefulWidget {
  List<String> regionlist = [];

  SignUp(this.regionlist);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var _formKey = GlobalKey<FormState>();
  final double _minimumPadding = 5.0;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _codeController = TextEditingController();

  var _initpassword = '';
  var _initpasswordconf = '';
  bool _load = false;
  final userdatabaseReference =
      FirebaseDatabase.instance.reference().child("userdata");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load
        ? new Container(
            child: SpinKitCircle(color: const Color(0xff171732)),
          )
        : new Container();
    TextStyle textStyle = Theme.of(context).textTheme.subtitle;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xffffffff),
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
                      top: _minimumPadding * 20,
                      bottom: _minimumPadding * 2,
                      right: _minimumPadding * 2,
                      left: _minimumPadding * 2),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      //getImageAsset(),
                      Padding(
                        padding: EdgeInsets.only(
                            top: _minimumPadding, bottom: _minimumPadding),
                        child: Center(
                          child: Text(
                            "إنشاء حساب",
                            style: TextStyle(
                                color: const Color(0xff171732),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),

//                      Padding(
//                          padding: EdgeInsets.only(
//                              top: _minimumPadding, bottom: _minimumPadding),
//                          child: Directionality(
//                            textDirection: TextDirection.rtl,
//                            child: TextFormField(
//                              textAlign: TextAlign.right,
//                              keyboardType: TextInputType.text,
//                              style: textStyle,
//                              //textDirection: TextDirection.rtl,
//                              controller: _nameController,
//                              validator: (String value) {
//                                if (value.isEmpty) {
//                                  return "ادخل الاسم كامل";
//                                }
//                              },
//                              decoration: InputDecoration(
//                                labelText: "الاسم كامل",
//                                //hintText: 'Name',
//                                labelStyle: textStyle,
//                                errorStyle: TextStyle(
//                                    color: Colors.red, fontSize: 15.0),
//                                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
//                              ),
//                            ),
//                          )),
//                      SizedBox(
//                        height: _minimumPadding,
//                        width: _minimumPadding,
//                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: _minimumPadding, bottom: _minimumPadding),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              textAlign: TextAlign.right,
                              keyboardType: TextInputType.emailAddress,
                              style: textStyle,
                              //textDirection: TextDirection.rtl,
                              controller: _emailController,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "برجاء إدخال بريد إلكتروني صالح";
                                }
                                Pattern pattern =
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                RegExp regex = new RegExp(pattern);
                                if (!regex.hasMatch(value)) {
                                  return "برجاء إدخال بريد إلكتروني صالح";
                                }
                              },
                              decoration: InputDecoration(
                                labelText: "البريد لالكتروني",
                                //hintText: 'Name',
                                labelStyle: textStyle,
                                errorStyle: TextStyle(
                                    color: Colors.red, fontSize: 15.0),
                                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                              ),
                            ),
                          )),
                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: _minimumPadding, bottom: _minimumPadding),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              textAlign: TextAlign.right,
                              keyboardType: TextInputType.number,
                              style: textStyle,
                              //textDirection: TextDirection.rtl,
                              controller: _phoneController,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "برجاء إدخال رقم جوالك";
                                }
                                if (value.length < 9) {
                                  return "برجاء إدخال رقم جوال صالح";
                                }
                              },
                              decoration: InputDecoration(
                                labelText: "رقم الجوال",
                                hintText: 'مثال:523456789',
                                labelStyle: textStyle,
                                errorStyle: TextStyle(
                                    color: Colors.red, fontSize: 15.0),
                                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                              ),
                            ),
                          )),
                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: _minimumPadding, bottom: _minimumPadding),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              obscureText: true,
                              textAlign: TextAlign.right,
                              keyboardType: TextInputType.text,
                              style: textStyle,
                              //textDirection: TextDirection.rtl,
                              controller: _passwordController,
                              validator: (String value) {
                                _initpassword = value;
                                if (value.isEmpty) {
                                  return "برجاء إدخال الرقم السري";
                                }
                                if (value.length < 2) {
                                  return "الرقم السري غير آمن";
                                }
                              },
                              decoration: InputDecoration(
                                labelText: "الرقم السري",
                                //hintText: 'Name',
                                labelStyle: textStyle,
                                errorStyle: TextStyle(
                                    color: Colors.red, fontSize: 15.0),
                                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                              ),
                            ),
                          )),
                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: _minimumPadding, bottom: _minimumPadding),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              obscureText: true,
                              textAlign: TextAlign.right,
                              keyboardType: TextInputType.text,
                              style: textStyle,
                              //textDirection: TextDirection.rtl,
                              controller: _confirmpasswordController,
                              validator: (String value) {
                                _initpasswordconf = value;
                                if (value.isEmpty) {
                                  return "الرجاء إدخال تأكيد الرقم السري";
                                }
                                if (value.length < 2) {
                                  return "الرقم السري غير آمن او غير مطابق";
                                }
                                if (_initpasswordconf != _initpassword) {
                                  return "الرقم السري غير مطابق";
                                }
                              },
                              decoration: InputDecoration(
                                labelText: "الرقم السري",
                                //hintText: 'Name',
                                labelStyle: textStyle,
                                errorStyle: TextStyle(
                                    color: Colors.red, fontSize: 15.0),
                                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                              ),
                            ),
                          )),
                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),

                      Padding(
                        padding: EdgeInsets.only(
                            top: _minimumPadding, bottom: _minimumPadding),
                        child: Center(
                          child: Text(
                            "بالضغط على زر التسجيل فإنك توافق على الشروط والأحكام",
                            style: TextStyle(
                                color: const Color(0xff000000),
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),

                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
//                            Padding(
//                              padding: EdgeInsets.all(_minimumPadding),
//
//                              child: Container(
//                                height: 50.0,
//                                width: 150,
//                                child: Material(
//                                  borderRadius: BorderRadius.circular(20.0),
//                                  shadowColor: const Color(0xff41a0cb),
//                                  color: const Color(0xff41a0cb),
//                                  elevation: 3.0,
//                                  child: GestureDetector(
//                                    onTap: () async {
//                                      if (_formKey.currentState.validate()) {
//                                        try {
//                                          final result = await InternetAddress.lookup('googl.com');
//                                          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//                                            //  print('connected');
//                                            loginUserphone(_phoneController.text.trim(), context);
//                                            setState(() {
//                                              _load = true;
//                                            });
//                                          }
//                                        } on SocketException catch (_) {
//                                          //  print('not connected');
//                                          //  Toast.show(Translations.of(context).translate('please_see_network_connection'),context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
//                                          showInSnackBar( Translations.of(context).translate('please_see_network_connection'));
//
//                                        }
//
//                                      } else
//                                        print('correct');
//                                    },
//                                    child: Row(
//                                      mainAxisAlignment: MainAxisAlignment.center,
//
//                                      children: <Widget>[
//                                        Text(
//                                          Translations.of(context).translate('sign_up'),
//                                          textAlign: TextAlign.center,
//                                          style: TextStyle(
//                                              color: Colors.white,
//                                              fontWeight: FontWeight.bold,
//                                              fontFamily: 'Montserrat'),
//                                        ),
//                                        Icon(
//                                          Icons.phone_android,
//                                          color: Colors.white,
//                                        ),
//                                      ],
//                                    ),
//                                  ),
//                                ),
//                              ),
//                            ),

                            Padding(
                              padding: EdgeInsets.all(_minimumPadding),
                              child: Container(
                                height: 50.0,
                                width: 250,
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  shadowColor: const Color(0xff171732),
                                  color: const Color(0xff171732),
                                  elevation: 3.0,
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (_formKey.currentState.validate()) {
                                        try {
                                          final result =
                                              await InternetAddress.lookup(
                                                  'google.com');
                                          if (result.isNotEmpty &&
                                              result[0].rawAddress.isNotEmpty) {
                                            //  print('connected');
                                            loginUserphone(
                                                _phoneController.text.trim(),
                                                context);
                                            setState(() {
                                              _load = true;
                                            });
                                          }
                                        } on SocketException catch (_) {
                                          //  print('not connected');
                                          //Toast.show(Translations.of(context).translate('please_see_network_connection'),context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
                                          showInSnackBar(
                                              "خطأ بالاتصال بالشبكة");
                                        }
                                        //loginUserphone(_phoneController.text.trim(), context);

                                      } else
                                        print('correct');
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          " تسجيل",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Montserrat'),
                                        ),
                                        Icon(
                                          Icons.email,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),
                      Padding(
                        padding: EdgeInsets.all(_minimumPadding),
                        child: Container(
                          height: 50.0,
                          width: 150,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: const Color(0xffbdbdbd),
                            color: const Color(0xffbdbdbd),
                            elevation: 3.0,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FragmentSouq1(widget.regionlist)));
                              },
                              child: Center(
                                child: Text(
                                  " تخطي الدخول",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: _minimumPadding, bottom: _minimumPadding),
                        child: Center(
                          child: FlatButton(
                            child: Text(
                              " لديك حساب مسجل بالفعل",
                              style: TextStyle(
                                  color: const Color(0xff171732),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          LoginScreen2(widget.regionlist)));
                            },
                          ),
                        ),
                      ),
                      // ),
                    ],
                  )),
            ),
            new Align(
              child: loadingIndicator,
              alignment: FractionalOffset.center,
            ),
            // new Align(child: loadingIndicator,alignment: FractionalOffset.center,),
          ],
        ),
      ),
    );
  }

  Future<bool> loginUserphone(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: "+966$phone",
        //phoneNumber: "+2$phone",
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();

          AuthResult result = await _auth.signInWithCredential(credential);
          createRecord(result.user.uid);

          //FirebaseUser user = result.user;
          // Navigator.of(context).pushReplacementNamed('/fragmentsouq');

//          if(user != null){
//            Navigator.push(context, MaterialPageRoute(
//                builder: (context) => HomeScreen(user: user,)
//            ));
//          }else{
//            print("Error");
//          }

          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (AuthException exception) {
          print(exception);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Column(
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            alignment: Alignment.center,
                            matchTextDirection: true,
                            repeat: ImageRepeat.noRepeat,
                            image: AssetImage(
                                "assets/images/ic_confirmephone.png"),
                          ),
                          borderRadius: BorderRadius.circular(21.0),
                          //color: const Color(0xff4fc3f7),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text("تحقق من الكود المرسل؟"),
                      ),
                    ],
                  ),
//                  AssetImage("assets/logowhite.png"),
//Text("Give the code?"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        color: Colors.grey[300],
                        width: 150,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _codeController,
                        ),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("تأكيد"),
                      textColor: Colors.white,
                      color: Colors.black,
                      onPressed: () async {
                        final code = _codeController.text.trim();
                        AuthCredential credential =
                            PhoneAuthProvider.getCredential(
                                verificationId: verificationId, smsCode: code);

                        AuthResult result =
                            await _auth.signInWithCredential(credential);

                        //FirebaseUser user = result.user;
                        createRecord(result.user.uid);
                        // Navigator.of(context).pushReplacementNamed('/fragmentsouq');
                      },
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: null);
  }

  void _uploaddataemail() {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )
        .then((signedInUser) {
      //Toast.show("${signedInUser.user.uid}",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);

      //createRecord2(signedInUser.user.uid);
    }).catchError((e) {
      // Toast.show(e,context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
//      showInSnackBar(e);

//      setState(() {
//        _load = false;
//      });
    });
  }

  void createRecord(signedInUserid) {
    _uploaddataemail();
    setState(() {
      _load = false;
    });
    final userdatabaseReference =
        FirebaseDatabase.instance.reference().child("userdata");


    if (signedInUserid == null) {
      userdatabaseReference.child(signedInUserid).set({
        "cId": signedInUserid,
        "cPhone": _phoneController.text,
        'cEmail': _emailController.text,
      }).then((_) {
        setState(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => FragmentSouq1(widget.regionlist)));
        });
      });
    } else {
      userdatabaseReference.child(signedInUserid).update({
        "cPhone": _phoneController.text,
        "cId": signedInUserid,
        'cEmail': _emailController.text,
      }).then((_) {
        setState(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => FragmentSouq1(widget.regionlist)));
        });
      });
    }
  }
  void createRecord2(signedInUserid) {
    userdatabaseReference.child(signedInUserid).set({
      'cId': signedInUserid,
//      'cName': _nameController.text,
      'cEmail': _emailController.text,
      'cPhone': _phoneController.text,
//      'cType': "مستخدم",
//      'rating': "0",
//      'custRate': 0,

      //'published': false,
    }).whenComplete(() {
      // Toast.show(Translations.of(context).translate('sign_in_successful'),context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
      showInSnackBar("تم تسجيل الدخول بنجاح");
    });

    setState(() {
      _load = false;
    });
//    Navigator.pushReplacement(
//        context,
//        MaterialPageRoute(
//            builder: (context) => FragmentSouq1(widget.regionlist)));
  }
//  Widget _getImageAsset() {
//    AssetImage assetImage = AssetImage("assets/images/twitter-icon.png");
//    Image image = Image(
//      image: assetImage,
//      width: 50,
//      height: 50,
//    );
//
//    return Container(
//      child: image,
//
//    );
//  }
//  Future<FirebaseUser> _handleSignIn() async {
//    GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
//    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//    final AuthCredential credential = GoogleAuthProvider.getCredential(
//      accessToken: googleAuth.accessToken,
//      idToken: googleAuth.idToken,
//    );
//    final FirebaseUser user = await FirebaseAuth.instance.signInWithCredential(credential);
//    print("signed in " + user.displayName);
//    return user;
//  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        style: TextStyle(color: Colors.white),
      ),
    ));
  }
}
