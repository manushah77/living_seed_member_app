import 'package:cloud_firestore/cloud_firestore.dart';

class NewRecordData {
  double? amount;
  String? comID;
  String? parentID;
  String? paymentType;
  String? transactionCategory;
  Timestamp? date;
  String? parentName;
  String? typetrance;

  NewRecordData(
      {required this.amount,
      required this.comID,
      required this.date,
      required this.parentID,
      required this.parentName,
      required this.paymentType,
      required this.transactionCategory,
      required this.typetrance});

  NewRecordData.fromMap(Map<String, dynamic> map) {
    amount = double.parse(map['Ammount'].toString());
    comID = map['CompId'];
    parentID = map['ParentId'];
    paymentType = map['Payment Type'];
    transactionCategory = map['Transaction Category'];
    date = map['date'];
    parentName = map['parentName'];
    typetrance = map['typetrans'];
  }
}
