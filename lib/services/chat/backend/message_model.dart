class MessageModel {
  String uid;
  String message;
  String datetime;

  MessageModel({
    required this.uid,
    required this.message,
    required this.datetime,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'message': message,
      'datetime': datetime,
    };
  }
}
