class RegisterModel {
  String firstName;
  String lastName;
  String username;
  String email;
  String password;

  RegisterModel({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'userName': username,
    'email': email,
    'password': password,
  };
}
