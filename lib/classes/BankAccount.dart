class BankAccount {
  String id;
  String AccountIBAN;
  String AccountName;
  String AccountNum;
  String NameCompany;

  BankAccount(this.id, this.AccountIBAN, this.AccountName, this.AccountNum,
      this.NameCompany);

  BankAccount.fromJson(Map model) {
    this.id = model["id"];
    this.AccountIBAN = model["AccountIBAN"];
    this.AccountName = model["AccountName"];
    this.AccountNum = model['AccountNum'];
    this.NameCompany = model['NameCompany'];
  }
}
