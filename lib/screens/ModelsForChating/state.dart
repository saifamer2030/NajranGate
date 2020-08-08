import 'package:firebase_auth/firebase_auth.dart';

class StateModel {
  bool isLoading;
  FirebaseUser user;

  StateModel({
    this.isLoading = false,
    this.user,
  });
}

class Message {
  String Name;
  String senderUser;
  String recevdUser;
  String message;
  String img;
  String timeData;
  bool delivered;

  Message.fromJson(Map model) {
//    print(model["username"]);
    this.Name = model["recevdName"];
    this.senderUser = model["senderUser"];
    this.recevdUser = model["recevdUser"];
    this.message = model["message"];
    this.img = model['img'];
    this.timeData = model['timeData'];
    this.delivered = model['delivered'];
  }
}
