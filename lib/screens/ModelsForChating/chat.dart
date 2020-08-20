import 'dart:collection';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart' as intl;
import "package:NajranGate/screens/ModelsForChating/state.dart";

class ChatPage extends StatefulWidget {
  ChatPage({Key key, this.url, this.name, this.uid}) : super(key: key);
  final String url;
  final String name;
  final String uid;

  @override
  _ChatState createState() => _ChatState();
}

final mDatabase = FirebaseDatabase.instance.reference();

class _ChatState extends State<ChatPage> {
  @override
  final double _minimumPadding = 5.0;

  ChatPage get widget => super.widget;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  DatabaseReference reference1, reference2, reference3, reference4, reference5;
  TextEditingController _controller;
  List<Message> chatHolder;
  File image;
  String _cName =" ";
  String _imgUrl = "";
  bool isLoaded = false;

  picker() async {
    DateTime time = DateTime.now();
    String formattedDate = intl.DateFormat('hh:mm').format(time);
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    // File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      int timestamp = new DateTime.now().millisecondsSinceEpoch;
      StorageReference storageReference =
      FirebaseStorage.instance.ref().child("PhotoChating");

      StorageUploadTask uploadTask = storageReference
          .child("img_" + timestamp.toString() + ".jpg")
          .putFile(img);
      image = img;
      var Imageurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      String url1 = Imageurl.toString();
      sendMessage(msg: null, img: url1, time: formattedDate);
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    getLoggedInUser();
    getUser();
    _controller = new TextEditingController();
    chatHolder = new List<Message>();
    setState(() {
      isLoaded = true;
    });
  }

  void getUser() async {
    FirebaseUser usr = await _auth.currentUser();
    if (usr != null) {
      mDatabase
          .child("userdata")
          .child(usr.uid)
          .once()
          .then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        if (values != null) {
          setState(() {
            _cName = values['cName'].toString();
            _imgUrl = values['curi'].toString();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    DateTime time = DateTime.now();
    String formattedDate = intl.DateFormat('hh:mm').format(time);

    return new Scaffold(
      backgroundColor: const Color(0xffffffff),
//      appBar: new AppBar(
//        title: new Text(widget.name,style: TextStyle(color: Colors.black),),
//        backgroundColor: Colors.pinkAccent,
//        leading: Padding(
//          padding: const EdgeInsets.all(5.0),
//          child: Container(
//            height: 50,
//            width: 50,
//            decoration: BoxDecoration(
//
//                image: new DecorationImage(
//
//                  image: // NetworkImage(_imgUrl)
//                    new AssetImage("assets/logo.png"),
//
//                )),
//          ),
//        ),
//      ),
//
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
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    alignment: Alignment.centerLeft,
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
//                Padding(
//                  padding: EdgeInsets.only(
//                      top: _minimumPadding * 22,
//                      left: _minimumPadding,
//                      right: _minimumPadding),
//                  child: Container(
//                    width: MediaQuery.of(context).size.width,
//                    height: 80,
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        new RaisedButton(
//                          child: new Text("طلب تتبع"),
//                          textColor: Colors.white,
//                          color: Colors.grey,
//                          onPressed: () {},
//
//                          //#48B2E1
//                          shape: new RoundedRectangleBorder(
//                              borderRadius: new BorderRadius.circular(10.0)),
//                        ),
//                        new RaisedButton(
//                          textColor: Colors.white,
//                          color: const Color(0xff48B2E1),
//                          onPressed: () {
//
//
////                            Navigator.push(
////                              context,
////                              new MaterialPageRoute(
////                                  builder: (BuildContext context) =>
////                                  new UserRatingPage(Rating(widget.uid,"" , "",))),
////                            );
//                          },
//
//                          //#48B2E1
//                          shape: new RoundedRectangleBorder(
//                              borderRadius: new BorderRadius.circular(10.0)),
//                          child: Row(
//                            children: <Widget>[
//                              Text(
//                                'إتمام الصفقة',
//                                style: TextStyle(color: Colors.white),
//                              ),
//                              Icon(
//                                Icons.thumb_up,
//                                color: Colors.white,
//                              )
//                            ],
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
////                Padding(
////                  padding: EdgeInsets.only(
////                      top: _minimumPadding * 40,
////                      left: _minimumPadding * 2,
////                      right: _minimumPadding * 2),
////                  child: InkWell(
////                    onTap: () {
////                      Navigator.pop(context);
////                    },
////                    child: Container(
////                      width: MediaQuery.of(context).size.width,
////                      height: 80.0,
////                      decoration: BoxDecoration(
////                        borderRadius: BorderRadius.circular(10.0),
////                        color: const Color(0xffe5e5e5),
////                        boxShadow: [
////                          BoxShadow(
////                              color: const Color(0x33000000), blurRadius: 3)
////                        ],
////                      ),
////                      child: Row(
////                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
////                        children: <Widget>[
////                          Icon(
////                            Icons.call,
////                            color: Colors.lightBlueAccent,
////                          ),
////                          Row(
////                            children: <Widget>[
////                              Padding(
////                                padding: const EdgeInsets.all(8.0),
////                                child: Text(widget.name,
////                                    style: new TextStyle(
////                                      color: Colors.lightBlueAccent,
////                                      fontSize: 16,
////                                    )),
////                              ),
////                              new Container(
////                                child: new Text(widget.name[0],
////                                    style: new TextStyle(
////                                        color: Colors.lightBlueAccent,
////                                        fontSize: 30,
////                                        fontWeight: FontWeight.w900)),
////                                decoration: new BoxDecoration(
////                                    shape: BoxShape.circle,
////                                    color: Colors.grey[400]),
////                                padding: new EdgeInsets.all(20.0),
////                              ),
////                              Icon(
////                                Icons.keyboard_arrow_right,
////                                color: Colors.lightBlueAccent,
////                              ),
////                            ],
////                          ),
////
//////                        Container(
//////                          height: 50,
//////                          width: 50,
//////                          decoration: BoxDecoration(
//////                              shape: BoxShape.circle,
//////                              image: new DecorationImage(
//////                                fit: BoxFit.cover,
//////                                image: // NetworkImage(_imgUrl)
//////                                    new AssetImage(
//////                                        "assets/images/ic_driver.png"),
//////                              )),
//////                        ),
////                        ],
////                      ),
////                    ),
////                  ),
////                ),

                 new Positioned(
                      child: isLoaded
                          ? chatHolder.length == 0
                          ? Center(child: Text("لا توجد محادثة"))
                          : Padding(
                            padding: const EdgeInsets.only(top:100 ),
                            child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (BuildContext ctxt, int index) {
                            if (chatHolder[index].senderUser ==
                                user.uid) {
                              if (chatHolder[index].img != null) {
                                print("this Me =" +
                                    chatHolder[index].img);
                              }
                              return Bubble(
                                message: chatHolder[index].message,
                                time: chatHolder[index].timeData,
                                delivered: true,
                                isMe: true,
                                img: chatHolder[index].img,
                              );
                            } else {
                              return new Bubble(
                                message: chatHolder[index].message,
                                time: chatHolder[index].timeData,
                                delivered: false,
                                isMe: false,
                                img: chatHolder[index].img,
                              );
                            }
                        },
                        itemCount: chatHolder.length,
                        padding: new EdgeInsets.fromLTRB(0, 0, 0, 70),
                      ),
                          )
                          : Center(
                        child: SpinKitPumpingHeart(
                          color: const Color(0xff171732),
                        ),
                      )),

                new Positioned(
                    child: new Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: new Container(
                        child: new Row(
                          children: <Widget>[
                            Expanded(
                              child: new Padding(
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: new TextField(
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                    maxLines: null,
                                    decoration: new InputDecoration.collapsed(
                                      hintText: "اكتب رساله هنا",
                                    ),
                                    controller: _controller,
                                  ),
                                ),
                                padding: EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                              ),
                            ),
                            new IconButton(
                                icon: new Icon(
                                  Icons.insert_photo,
                                  color: const Color(0xff171732),
                                ),
                                onPressed: () => picker()),
                            new IconButton(
                              onPressed: () => sendMessage(
                                  msg: _controller.text,
                                  img: null,
                                  time: formattedDate),
                              icon: new Icon(
                                Icons.send,
                                color: const Color(0xff171732),
                              ),
                            ),
                          ],
                        ),
                        decoration: new BoxDecoration(
                            borderRadius:
                            new BorderRadius.all(Radius.circular(25.0)),
                            color: Colors.white,
                            border: Border.all(color: Colors.black)),
                        margin: EdgeInsets.all(10.0),
                      ),
                    ))


        ],
      ),
    );
  }

  getLoggedInUser() async {
    DateTime now = DateTime.now();
    int dateNow =
    int.parse('${now.year}${now.month}${now.day}${now.hour}${now.minute}');
    user = await _auth.currentUser();
    reference1 = FirebaseDatabase.instance
        .reference()
        .child("Chats")
        .child(widget.uid)
        .child(user.uid /*+ " : " + widget.uid*/);
    reference2 = FirebaseDatabase.instance
        .reference()
        .child("Chats")
        .child(user.uid)
        .child(widget.uid /*+ " : " + user.uid*/);

    reference3 = FirebaseDatabase.instance
        .reference()
        .child("ChatList")
        .child(user.uid)
        .child("idTo");
    reference4 = FirebaseDatabase.instance
        .reference()
        .child("ChatList")
        .child(widget.uid)
        .child("idTo");
    reference5 = FirebaseDatabase.instance
        .reference()
        .child("Alarm")
        .child(widget.uid)
        .child("$dateNow");

    reference1.onChildAdded.listen((Event event) {
      Map map = event.snapshot.value;

      Message m = Message.fromJson(map);
      setState(() {
        isLoaded = true;
        chatHolder.add(m);
      });
    }, onError: (Object o) {
      final DatabaseError error = o;
      print('Error: ${error.code} ${error.message}');
    });

//    reference5.onChildAdded.listen((Event event) {
//      Map map = event.snapshot.value;
//
//      AlarmaClass A = AlarmaClass.fromJson(map);
//      setState(() {
//        isLoaded = true;
//      });
//    }, onError: (Object o) {
//      final DatabaseError error = o;
//      print('Error: ${error.code} ${error.message}');
//    });
    // here you write the codes to input the data into firestore
  }

  void sendMessage({String msg, String img, String time}) {
//    DateTime time = DateTime.now();
//    String formattedDate = DateFormat('yyyy-MM-dd hh:mm').format(time);
    DateTime now = DateTime.now();
    int dateNow =
    int.parse('${now.year}${now.month}${now.day}${now.hour}${now.minute}');

    if (msg != "") {
      setState(() {
        isLoaded = true;
      });
      Map<String, String> map = new HashMap<String, String>();
      Map<String, String> mapalarm = new HashMap<String, String>();
      map.putIfAbsent("message", () => msg);
      map.putIfAbsent("img", () => img);
      map.putIfAbsent("senderUser", () => user.uid);
      map.putIfAbsent("recevdUser", () => widget.uid);
      map.putIfAbsent("recevdName", () => widget.name);
      map.putIfAbsent("timeData", () => time);



//      mapalarm.putIfAbsent("alarmid", () => widget.uid);
//      mapalarm.putIfAbsent("Name", () => _cName);
//      mapalarm.putIfAbsent("arrange", () => "$dateNow");
//      mapalarm.putIfAbsent("cDateID", () => "$dateNow2");
//      mapalarm.putIfAbsent("cType", () => "chat");
      reference1.push().set(map);
      reference2.push().set(map);
      reference3.set(widget.uid);
      reference4.set(user.uid);
      //reference5.push().set(mapalarm);
      final databasealarm = FirebaseDatabase
          .instance
          .reference()
          .child("Alarm")
          .child(widget.uid);

      databasealarm.push().set({
        'alarmid': databasealarm.push().key,
        'wid': widget.uid,
        'Name': _cName,
        'cType': "chat",
        'cDateID':"$now",
        'arrange':int.parse("$dateNow")
      });

      _controller.clear();
    } else {
      Fluttertoast.showToast(
          msg: "لا يمكن إرسال رسالة فارغة",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          fontSize: 15.0,
          textColor: Colors.black,
          backgroundColor: Theme.of(context).accentColor);
    }
  }
}

class Bubble extends StatelessWidget {
  Bubble({this.message, this.time, this.delivered, this.isMe, this.img});

  final String message, time, img;
  final delivered, isMe;

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? const Color(0xff171732) : const Color(0xff171732);
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final icon = delivered ? Icons.done : Icons.done;
    final radius = isMe
        ? BorderRadius.only(
      topLeft: Radius.circular(10.0),
      bottomLeft: Radius.circular(10.0),
      bottomRight: Radius.circular(10.0),
    )
        : BorderRadius.only(
//            topRight: Radius.circular(10.0),
      bottomLeft: Radius.circular(10.0),
      bottomRight: Radius.circular(10.0),
    );
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(.12))
            ],
            color: bg,
            borderRadius: radius,
          ),
          child: Stack(
            children: <Widget>[
              img == null
                  ? Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(message,style: TextStyle(
                  color: Colors.white
                ),),
              )
                  : Padding(
                padding: EdgeInsets.all(15.0),
                child: InkWell(
                  onTap: () => null,
                  child: Container(
                    child: Image.network(img),
                  ),
                ),
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Row(
                  children: <Widget>[
                    Text(time,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.0,
                        )),
                    SizedBox(width: 3.0),
                    Icon(
                      icon,
                      size: 10.0,
                      color: Colors.black38,
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
