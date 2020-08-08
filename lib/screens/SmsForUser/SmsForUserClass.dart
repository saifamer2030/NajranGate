import 'package:firebase_database/firebase_database.dart';

class SmsForUser {
  String _id ;
  String _name;
  String _email;
  String _city;
  String _phone;
  String _smsText;


  SmsForUser(this._id,this._name,this._email,this._city,this._phone,this._smsText);


////////////////// لوضع اسم لكل بيان فى قاعدة البيانات /////////////////////////
  SmsForUser.map(dynamic obj){
    this._id = obj['id'];
    this._name = obj['Name'];
    this._email = obj['Email'];
    this._city = obj['City'];
    this._phone = obj['Phone'];
    this._smsText = obj['SmsText'];

  }


///////////////////////// للحصول على بيانات من اليوزر ///////////////////
  String get id => _id;
  String get name => _name;
  String get email => _email;
  String get city => _city;
  String get phone => _phone;
  String get smsText => _smsText;




//////////////// لاستعادة البيانات من الفاير بيز /////////////////////
  SmsForUser.fromSnapShot(DataSnapshot snapshot){
    _id = snapshot.key;
    _name = snapshot.value['Name'];
    _email = snapshot.value['Email'];
    _city = snapshot.value['City'];
    _phone = snapshot.value['Phone'];
    _smsText = snapshot.value['SmsText'];
  }
}