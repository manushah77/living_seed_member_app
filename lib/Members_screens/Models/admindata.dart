class AdminData {
  String? accountHolder;
  String? accountNumber;
  String? addedBy;
  String? bankName;
  String? check;
  String? company;
  double? defaultAmount;
  String? img;
  String? email;
  String? token;

  AdminData(
      {required this.accountHolder,
      required this.accountNumber,
      required this.addedBy,
      required this.bankName,
      required this.check,
      required this.company,
      required this.defaultAmount,
      required this.img,
      required this.email,
      required this.token});
  AdminData.fromMap(Map<String, dynamic> map) {
    accountHolder = map['Account Holder Name'];
    accountNumber = map['Account Number'];
    addedBy = map['Added By'];
    bankName = map['Bank name'];
    check = map['check'];
    company = map['Company'];
    defaultAmount = map['Default Amount'];
    img = map['Image'];
    email = map['email'];
    token = map['token'];
  }

  Map<String, dynamic> toMap() {
    return {
      'Account Holder Name': accountHolder,
      'Account Number': accountNumber,
      'Added By': addedBy,
      'Bank name': bankName,
      'check': check,
      'Company': company,
      'Defult Amount': defaultAmount,
      'Image':
          'https://firebasestorage.googleapis.com/v0/b/testoneal.appspot.com/o/images%2Fpost_1664262436729.jpg?alt=media&token=33bdeae9-78be-4f5d-9b39-253ce924e818',
      'email': email,
      'token': token
    };
  }
}
