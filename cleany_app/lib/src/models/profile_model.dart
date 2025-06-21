class ProfileModel {
  final String firstName;
  final String? lastName;
  final String username;
  final String email;
  final String password;
  final String? imageUrl; 
  final String role;
  final String? shift;
  
  ProfileModel({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.password,
    this.imageUrl,
    required this.role,
    this.shift
  });

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'userName': username,
    'email': email,
    'password': password,
    'imageUrl': imageUrl,
    'role': role,
    'shift': shift
  };

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    firstName: json['firstName'] ?? '',
    lastName: json['lastName'],
    username: json['username'] ?? '', 
    email: json['email'] ?? '',
    password: json['password'] ?? '',
    imageUrl: json['imageUrl'],
    role: json['role'] ?? '',
    shift: json['shift'],
  );


  static ProfileModel empty() => ProfileModel(
    firstName: '',
    lastName: null,
    username: '',
    email: '',
    password: '',
    imageUrl: null,
    role: '',
    shift: null
  );
}