class ChatList{
  String idTo;
  String id;
  ChatList (this.idTo,this.id);

  ChatList.fromJson(Map model){

    this.idTo = model["idTo"];
    this.id = model["id"];


  }
String get IdTo => idTo;
String get Id => id;


}