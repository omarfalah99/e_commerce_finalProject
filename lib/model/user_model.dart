class UserModel {
  String uid;
  String? email;
  String? displayName;
  String? phoneNumber;

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.phoneNumber,
  });
}
