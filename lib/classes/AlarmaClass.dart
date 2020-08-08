class AlarmaClass {
  String alarmid;
  String wid;
  String Name;
  String cType;
  String cDate;
  String chead;
  int arrange;
  AlarmaClass(
  this.alarmid,
      this.wid,
  this.Name,
  this.cType,
      this.cDate,
      this.chead,

      this.arrange,

      );
  AlarmaClass.fromJson(Map model) {
    this.alarmid = model["alarmid"];
    this.Name = model["Name"];
    this.cType = model["cType"];
    this.cDate = model['cDate'];
    this.cDate = model['chead'];
    this.arrange = model['arrange'];
  }

}
