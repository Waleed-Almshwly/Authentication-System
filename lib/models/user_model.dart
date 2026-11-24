class UserModel {
  const UserModel({
    required this.fullName,
    required this.academicId,
    required this.email,
    required this.password,
  });

  final String fullName;
  final String academicId;
  final String email;
  final String password;

  UserModel copyWith({String? password}) => UserModel(
    fullName: fullName,
    academicId: academicId,
    email: email,
    password: password ?? this.password,
  );
}
