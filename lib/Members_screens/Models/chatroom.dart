class ChatroomModel {
  String? id;
  List? members;
  ChatroomModel({required this.id, required this.members});

  ChatroomModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    members = map['members'];
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'members': members};
  }
}
