import 'package:cloud_firestore/cloud_firestore.dart';

class DepositAddModel {
  String? parentName;
  String? parentID;
  double? ammount;
  String? paymentcatagory;
  String? note;
  String? transtype;
  String? status;
  String? imgurl;

  Timestamp? date;

  DepositAddModel(
      {required this.parentID,
      required this.parentName,
      required this.ammount,
      required this.paymentcatagory,
      required this.note,
      required this.transtype,
      required this.status,
      required this.date,
      required this.imgurl});

  DepositAddModel.fromMap(Map<String, dynamic> map) {
    parentName = map['parentName'];
    parentID = map['Added'];
    ammount = double.parse(map['Deposit Amount'].toString());
    paymentcatagory = map['Payment Catagory'];
    note = map['Note'];
    transtype = map['Type'];
    date = map['Date'];
    imgurl = map['imgUrl'];
  }
}
