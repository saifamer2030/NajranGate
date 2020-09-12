import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:NajranGate/classes/BankAccount.dart';

class CommissionNajran extends StatefulWidget {
  @override
  _CommissionNajranState createState() => _CommissionNajranState();
}

class _CommissionNajranState extends State<CommissionNajran> {
  final double _minimumPadding = 5.0;

  TextEditingController _priceController = TextEditingController();

  List<BankAccount> bankaccountlist = [];

  //List<String> namelist = [];
  bool _load = false;
  String _userId;
  final databasebankaccount =
      FirebaseDatabase.instance.reference().child("BankAccount");

  @override
  void initState() {
    super.initState();
    _priceController.text = "0.0";
    setState(() {
      _load = true;
    });
    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? null
        : setState(() {
            _userId = user.uid;
            final databasebankaccount =
                FirebaseDatabase.instance.reference().child("BankAccount");

            //   for (var id in uuId) {
            databasebankaccount.once().then((DataSnapshot data1) {
              var DATA = data1.value;
              var keys = data1.value.keys;
              bankaccountlist.clear();
              for (var individualkey in keys) {
                BankAccount banlaccountlass = new BankAccount(
                  DATA[individualkey]['id'],
                  DATA[individualkey]['AccountIBAN'],
                  DATA[individualkey]['AccountName'],
                  DATA[individualkey]['AccountNum'],
                  DATA[individualkey]['NameCompany'],
                );
                setState(() {
                  bankaccountlist.add(banlaccountlass);
                });
              }
            });
            // }
            //  });
          }));
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load
        ? new Container(
            child: SpinKitCircle(
              color: const Color(0xff171732),
            ),
          )
        : new Container();
    return Scaffold(
//        backgroundColor: const Color(0xffffffff),
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
                              Icons.arrow_back,
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
                  child: Padding(
                      padding: EdgeInsets.only(
                          top: _minimumPadding * 23,
                          bottom: _minimumPadding * 2,
                          right: _minimumPadding * 2,
                          left: _minimumPadding * 2),
                      child: Column(
//                      physics: BouncingScrollPhysics(),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 10, left: 10),
                                  child: Text(
                                    "حساب العمولة",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
//                                    fontFamily: 'Estedad-Black',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 10, left: 10),
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
                                    keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                    textDirection: TextDirection.rtl,
                                    controller: _priceController,
                                    validator: (String value) {
                                      if ((value.isEmpty)) {
                                        return "اكتب السعر حق إعلانك طال عمرك";
                                      }
                                    },
                                    decoration: InputDecoration(
                                        errorStyle: TextStyle(
                                            color: Colors.red, fontSize: 15.0),
                                        labelText: "إذا تم بيع السلعة بسعر",
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    ". ريال",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
//                                    fontFamily: 'Estedad-Black',
                                    ),
                                  ),
                                ),
                                Container(
                                  color: Colors.green,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(right: 1, left: 1),
                                    child: Container(
                                        child: _priceController.text.isEmpty
                                            ? Text(
                                                "0.0",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
//                                    fontFamily: 'Estedad-Black',
                                                ),
                                              )
                                            : Text(
                                                getNewPrice(
                                                  _priceController.text,
                                                ),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
//                                    fontFamily: 'Estedad-Black',
                                                ),
                                              )),
                                  ),
                                ),

                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 30, left: 1),
                                  child: Text(
                                    "عمولة التطبيق هي ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
//                                    fontFamily: 'Estedad-Black',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 10, left: 10),
                                  child: Text(
                                    "طريقة التحويل",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
//                                    color: Colors.black,
//                                    fontFamily: 'Estedad-Black',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 10, left: 10),
                                  child: Icon(
                                    Icons.transfer_within_a_station,
                                    color: const Color(0xff171732),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              child: Center(
                            child: bankaccountlist.length == 0
                                ? new Center(child: Text("لا يوجد بيانات")

//                                  loadingIndicator,
                                    )
                                : new ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    // reverse: true,
                                    itemCount: bankaccountlist.length,
                                    itemBuilder: (BuildContext ctxt, int index) {
                                      return InkWell(
                                        child: _firebasedata(
                                          index,
                                          bankaccountlist.length,
                                          bankaccountlist[index].id,
                                          bankaccountlist[index].AccountName,
                                          bankaccountlist[index].NameCompany,
                                          bankaccountlist[index].AccountNum,
                                          bankaccountlist[index].AccountIBAN,
                                        ),
                                      );
                                    }),
                          )),
                        ],
                      )))
            ],
          ),
        ));
  }

  String getNewPrice(String lastPrice) {
    double lp = double.parse(lastPrice.toString());
    double newPrice = lp * (1 / 100);

    return newPrice.toString();
  }
}

_firebasedata(int index, int length, String id, String accountName,
    String nameCompany, String accountNum, String accountIBAN) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
        color: Colors.white,
        shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0)),
        //borderOnForeground: true,
        elevation: 10.0,
        margin: EdgeInsets.only(right: 1, left: 1, bottom: 2),
        child: Container(
          child: Column(
            children: <Widget>[
              Text(
                accountName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
//                fontFamily: 'Estedad-Black',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  nameCompany,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blue,
//                  fontFamily: 'Estedad-Black',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  accountNum,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.grey,
//                  fontFamily: 'Estedad-Black',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  accountIBAN,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.grey,
//                  fontFamily: 'Estedad-Black',
                  ),
                ),
              ),
            ],
          ),
        )),
  );
}
