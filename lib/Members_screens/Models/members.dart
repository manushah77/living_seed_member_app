import 'package:cloud_firestore/cloud_firestore.dart';

class MemberData {
  String? added;
  //String? classType;
  String? date;
  String? employee;
  String? imageUrl;
  String? phone;
  List? categories;
  double? earmingBalance;
  String? email;
  String? fname;
  String? lname;
  String? status;
  Timestamp? lastseen;
  String? token;
  MemberData(
      {required this.added,
      required this.categories,
      //required this.classType,
      required this.date,
      required this.earmingBalance,
      required this.email,
      required this.employee,
      required this.fname,
      required this.imageUrl,
      required this.lname,
      required this.phone,
      required this.status,
      required this.token,
      required this.lastseen});
  MemberData.fromMap(Map<String, dynamic> map) {
    added = map['Added'];
    //classType = map['Class Type'];
    date = map['Date'];
    employee = map['Employee_Off'];
    imageUrl = map['Image'];
    phone = map['Phone Number'];
    categories = map['categories'];
    earmingBalance = double.parse(map['earning_balance'].toString());
    email = map['email'];
    fname = map['fname'];
    lname = map['lname'];
    status = map['status'];
    lastseen = map['lastseen'];
    token = map['token'];
  }
}
