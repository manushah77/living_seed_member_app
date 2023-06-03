import 'package:cloud_firestore/cloud_firestore.dart';

class RecordsData{
  String? parentName;
  String? parentID;
  String? ammount;
  String? paymentType;
  String? category;
  String? transtype;
  String? compID;
  Timestamp? date;



  RecordsData({
    required this.parentID,
    required this.parentName,
    required this.ammount,
    required this.paymentType,
    required this.category,
    required this.transtype,
    required this.compID,
    required this.date

});

  RecordsData.fromMap(Map<String, dynamic> map){
    parentName = map['parentName'];
    parentID = map['Parentid'];
    ammount = map['Ammount'].toString();
    paymentType = map['Payment Type'];
    category = map['Transaction Category'];
    transtype = map['typetrans'];
    compID = map['CompId'];
    date = map['date'];

  }
}
