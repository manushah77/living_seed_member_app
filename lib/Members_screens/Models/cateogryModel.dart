class CategoryModel {
  String? addedBy;
  String? categoryName;
  bool? isSelected;
  String? id;
  String? bankname;
  String? bankaccname;
  String? bankaccnumber;

  CategoryModel({
    required this.addedBy,
    required this.categoryName,
    this.isSelected,
    required this.id,
    required this.bankaccname,
    required this.bankaccnumber,
    required this.bankname,
  });

  CategoryModel.fromMap(Map<String, dynamic> map) {
    addedBy = map['Added By'];
    categoryName = map['Category'];
    id = map['id'];
    bankaccname = map['Account Holder Name'];
    bankaccnumber = map['Account Number'];
    bankname = map['Bank name'];
  }
}
