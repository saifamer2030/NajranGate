class AdvNameClass {
  String cId;
  String cdate;
  String chead;
  String ctitle;
  String cdepart;
  String cregion;
  String cphone;
  String cprice;
  String cdetail;
  bool cpublished;
  String curi;
  String curilist;
  String cagekm;
  String csale;
  String cauto;
  String coil;
  String cNew;
  String cno;
  String cdep11;
  String cdep22;
  String cname;
  String cType;
  int carrange;
  bool consoome;
  String cmodel;
  String rating;
  int custRate;
  AdvNameClass(
  this.cId,
  this.cdate,
  this.chead,
  this.ctitle,
  this.cdepart,
  this.cregion,

  this.cphone,
  this.cprice,
  this.cdetail,

  this.cpublished,
  this.curi,
  this.curilist,
      this.cagekm,
      this.csale,
      this.cauto,
      this.coil,
      this.cNew,
      this.cno,
      this.cdep11,
      this.cdep22,
      this.cname,
      this.cType,
      this.carrange,
      this.consoome,
      this.cmodel,
      this.rating,
      this.custRate
      );
  AdvNameClass.fromJson(Map model) {
    this.cId = model["cId"];
    this.cdate = model["cdate"];
    this.chead = model["cEmail"];
    this.ctitle = model["ctitle"];
    this.cdepart = model["cdepart"];
    this.cregion = model["cregion"];
    this.cphone = model["cphone"];
    this.cprice = model["cprice"];
    this.cdetail = model["cdetail"];

    this.cpublished = model["cpublished"];
    this.curi = model["curi"];
    this.curilist = model["curilist"];
    this.cagekm = model["cagekm"];
    this.csale = model["csale"];
    this.cauto = model["cauto"];
    this.coil = model["coil"];
    this.cNew = model["cNew"];
    this.cno = model["cno"];
    this.cdep11 = model["cdep11"];
    this.cdep22 = model["cdep22"];
    this.cname = model["cname"];
    this.cType = model["cType"];
    this.carrange = model["carrange"];
    this.consoome = model["consoome"];
    this.cmodel = model["cmodel"];
    this.rating = model["rating"];
    this.custRate = model["custRate"];

  }

}
