class CoiffureRegDataClass {
  String cId;
  String cType;
  String cName;
  String cPhone;


  CoiffureRegDataClass(
      this.cId,
      this.cType,
      this.cName,
      this.cPhone,
     );

  CoiffureRegDataClass.fromJson(Map model) {
    this.cId = model["cId"];
    this.cType = model["cType"];
    this.cName = model["cName"];
    this.cPhone = model["cPhone"];

  }
  String get CId => cId;

  String get CType => cType;

  String get CName => cName;

  String get CPhone => cPhone;
}
