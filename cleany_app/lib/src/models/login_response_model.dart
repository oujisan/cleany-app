class LoginResponseModel {
  final String userId;
  final String token;
  final String username;
  final String role;

  LoginResponseModel({
    required this.token,
    required this.userId,
    required this.username,
    required this.role,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'],
      userId: json['user']['userId'].toString(),
      username: json['user']['username'],
      role: json['user']['role']
    );
  }
}
