import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toast/toast.dart';

import '../FragmentSouqNajran.dart';
import 'bottomsheet_widget.dart';
import 'privcy_policy.dart';

class PersonalPage extends StatefulWidget {
  List<String> regionlist = [];

  PersonalPage(this.regionlist);

  @override
  __PersonalPageState createState() => __PersonalPageState();
}

final mDatabase = FirebaseDatabase.instance.reference();

@override
class __PersonalPageState extends State<PersonalPage> {
  final double _minimumPadding = 5.0;
  TextEditingController phoneController;
  TextEditingController nameController;

  FirebaseAuth _firebaseAuth;
  String _cName = "";
  String _cMobile = "";
  String _cType = "";

  String _userId;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _firebaseAuth = FirebaseAuth.instance;
    FirebaseAuth.instance.currentUser().then((user) => user == null
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
                if (snapshot5.value != null) {
                  setState(() {
                    _cMobile = snapshot5.value;
                  });
                } else {
                  setState(() {
                    _cMobile = "رقم هاتف غير معلوم";
                  });
                }
              });
            });
            //////////////////////////
            userdatabaseReference
                .child(_userId)
                .child("cName")
                .once()
                .then((DataSnapshot snapshot5) {
              setState(() {
                if (snapshot5.value != null) {
                  setState(() {
                    _cName = snapshot5.value;
                  });
                } else {
                  setState(() {
                    _cName = "اسم غير معلوم";
                  });
                }
              });
            });

            ////////////////////////
            userdatabaseReference
                .child(_userId)
                .child("cType")
                .once()
                .then((DataSnapshot snapshot5) {
              setState(() {
                if (snapshot5.value != null) {
                  setState(() {
                    _cType = snapshot5.value;
                  });
                } else {
                  setState(() {
                    _cType = "نوع غير معلوم";
                  });
                }
              });
            });

            ////////////////////////
          }));
    setState(() {
      nameController = TextEditingController(text: _cName);
      phoneController = TextEditingController(text: _cMobile);
    });

    //getUser();
  }

  /** void getUser() async {
      FirebaseUser usr = await _firebaseAuth.currentUser();
      if (usr != null) {
      //      setState(() {
      //        _userId=usr.uid;
      //      });

      mDatabase
      .child("userdata")
      .child(usr.uid)
      .once()
      .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
      setState(() {
      _cName = values['cName'].toString();
      _cMobile = values['cPhone'].toString();
      _cType = values['cType'].toString();
      nameController = TextEditingController(text: _cName);
      phoneController = TextEditingController(text: _cMobile);
      });
      }
      });
      }
      }**/

  @override
  Widget build(BuildContext context) {
    bool checkingFlight = false;
    bool success = false;

    return Scaffold(
      key: _scaffoldKey,
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
                  decoration: BoxDecoration(

                    color: const Color(0xff171732),
                  ),
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
              child: Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding * 23,
                    bottom: _minimumPadding * 2,
                    right: _minimumPadding * 2,
                    left: _minimumPadding * 2),
                child: ListView(
                  children: <Widget>[
//                  Container(84848E
//                    width: 70,
//                    height: 70,
//                    decoration: BoxDecoration(
//                      image: DecorationImage(
//                        alignment: Alignment.center,
//                        matchTextDirection: true,
//                        repeat: ImageRepeat.noRepeat,
//                        image: AssetImage("assets/images/ic_person.png"),
//                      ),
//                    ),
//                  ),
                    Container(
                      height: 70,
                      color: const Color(0xff171732).withOpacity(.4),
                      child: Center(
                          child: Text(
                        "بيانات حسابك الشخصي",
                        style: TextStyle(
                            color: const Color(0xff171732),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 8, right: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Card(
                            elevation: 2,
                            shadowColor: Colors.blueAccent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      _cName != null ? _cName : "الاسم",
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Icon(Icons.person),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          showAlertDialogname(context, _cName);
                                        });
                                      },
                                      child: Icon(Icons.mode_edit)),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: .2,
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Card(
                              elevation: 2,
                              shadowColor: Colors.blueAccent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        _cMobile != null
                                            ? _cMobile
                                            : "رقم الجوال",
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Icon(Icons.phone_iphone),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            showAlertDialogphone(
                                                context, _cMobile);
                                          });
                                        },
                                        child: Icon(Icons.mode_edit)),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: .2,
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Card(
                              elevation: 2,
                              shadowColor: Colors.blueAccent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  InkWell(
                                      onTap: () {
                                        return showInSnackBar(
                                            "يجب الافصاح عن نوع حسابك");
                                      },
                                      child: Icon(Icons.help)),
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        _cType != null ? _cType : "النوع",
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Icon(Icons.title),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        showDialog(
                                            context: context,
                                            builder: (context) => MyForm4(_cType,
                                                onSubmit4: onSubmit4));
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Icon(Icons.mode_edit),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: .2,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 100, left: 50, right: 50),
                      child: SheetButton(widget.regionlist),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: (){
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PrivcyPolicy()));
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Text("إتفاقية الاستخدام",style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text("*",style: TextStyle(color: Colors.red),),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Row(
        children: <Widget>[
          Icon(
            Icons.live_help,
            color: Colors.yellow,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: new Text(
              value,
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    ));
  }

  showAlertDialogname(BuildContext context, name) {
    nameController = TextEditingController(text: name);

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(
        "إلغاء",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "حفظ",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        setState(() {
          if (_formKey.currentState.validate()) {
            final userdatabaseReference =
                FirebaseDatabase.instance.reference().child("userdata");
            userdatabaseReference.child(_userId).update({
              "cName": nameController.text,
            }).then((_) {
              setState(() {
                _cName = nameController.text;
                Navigator.of(context).pop();
              });
            });
          }
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("تأكيد"),
      content: Form(
        key: _formKey,
        child: Padding(
            padding:
                EdgeInsets.only(top: _minimumPadding, bottom: _minimumPadding),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormField(
                textAlign: TextAlign.right,
                keyboardType: TextInputType.text,
                //style: textStyle,
                //textDirection: TextDirection.rtl,
                controller: nameController,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'برجاء إدخال الاسم';
                  }
                },
                decoration: InputDecoration(
                  labelText: 'الاسم',
                  //hintText: '$name',
                  //labelStyle: textStyle,
                  errorStyle: TextStyle(color: Colors.red, fontSize: 15.0),
                  // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                ),
              ),
            )),
      ),
      actions: [
        cancelButton,
        continueButton,
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

  showAlertDialogphone(BuildContext context, phone) {
    phoneController = TextEditingController(text: phone);

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(
        "إلغاء",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "حفظ",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        setState(() {
          if (_formKey.currentState.validate()) {
            final userdatabaseReference =
                FirebaseDatabase.instance.reference().child("userdata");
            userdatabaseReference.child(_userId).update({
              "cPhone": phoneController.text,
            }).then((_) {
              setState(() {
                _cMobile = phoneController.text;
                Navigator.of(context).pop();
              });
            });
          }
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("تأكيد"),
      content: Form(
        key: _formKey,
        child: Padding(
            padding:
                EdgeInsets.only(top: _minimumPadding, bottom: _minimumPadding),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormField(
                textAlign: TextAlign.right,
                keyboardType: TextInputType.number,
                //style: textStyle,
                //textDirection: TextDirection.rtl,
                controller: phoneController,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'برجاء إدخال رقم الهاتف';
                  }
                  if (value.length < 10) {
                    return ' رقم الهاتف غير صحيح';
                  }
                },
                decoration: InputDecoration(
                  labelText: 'رقم الهاتف',
                  //hintText: '$name',
                  //labelStyle: textStyle,
                  errorStyle: TextStyle(color: Colors.red, fontSize: 15.0),
                  // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                ),
              ),
            )),
      ),
      actions: [
        cancelButton,
        continueButton,
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

  void onSubmit4(String result) {
//    print(result);
//    Toast.show("${result}", context,
//        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    setState(() {
      final userdatabaseReference =
          FirebaseDatabase.instance.reference().child("userdata");
      userdatabaseReference.child(_userId).update({
        "cType": result,
      }).then((_) {
        setState(() {
          _cType = result;
          //   Navigator.of(context).pop();
        });
      });
    });
  }
}
///////////////////////////////////

typedef void MyFormCallback4(String result);

class MyForm4 extends StatefulWidget {
  final MyFormCallback4 onSubmit4;
  String quarter11;

  MyForm4(this.quarter11, {this.onSubmit4});

  @override
  _MyForm4State createState() => _MyForm4State();
}

class _MyForm4State extends State<MyForm4> {
  String _currentValue = '';

  final _buttonOptions = [
    'محل',
    'مقر',
    'معرض',
    'فرد',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _currentValue = widget.quarter11;
  }

  @override
  Widget build(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text(
        "إلغاء",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        setState(() {
          Navigator.pop(context);
        });
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "حفظ",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        setState(() {
          Navigator.pop(context);
          widget.onSubmit4(_currentValue.toString());
        });
      },
    );
    return AlertDialog(
      title: Text(
        "النوع",
        style: TextStyle(fontWeight: FontWeight.bold),
        textDirection: TextDirection.rtl,
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buttonOptions
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
                        });
                      },
                    ))
                .toList(),
          ),
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
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

class SheetButton extends StatefulWidget {
  List<String> regionlist = [];

  SheetButton(this.regionlist);

  _SheetButtonState createState() => _SheetButtonState();
}

class _SheetButtonState extends State<SheetButton> {
  bool checkingFlight = false;
  bool success = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return !checkingFlight
        ? MaterialButton(
            key: _scaffoldKey,
            color: const Color(0xff171732),
            onPressed: () async {
              setState(() {
                checkingFlight = true;
              });

              await Future.delayed(Duration(seconds: 2));

              setState(() {
                success = true;

              });

              await Future.delayed(Duration(seconds: 1));

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FragmentSouq1(widget.regionlist)));
//              return showInSnackBar("تم تحديث حسابك");
            },
            child: Text(
              'تحديث',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        : !success
            ? CircularProgressIndicator()
            : Icon(
                Icons.check,
                size: 100,
                color: Colors.green,
              );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        style: TextStyle(color: const Color(0xffffffff)),
      ),
    ));
  }
}
