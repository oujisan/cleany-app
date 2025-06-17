import 'dart:convert';

// Helper function to decode JSON string
ApiResponse apiResponseFromJson(String str) => ApiResponse.fromJson(json.decode(str));

// Main API Response Wrapper
class ApiResponse {
    final bool success;
    final String message;
    final List<UserProfile>? data;
    final String? error;

    ApiResponse({
        required this.success,
        required this.message,
        this.data,
        this.error,
    });

    factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] != null
            ? List<UserProfile>.from(json["data"].map((x) => UserProfile.fromJson(x)))
            : null,
        error: json["error"],
    );
}


// UserProfile Model
class UserProfile {
    final String firstName;
    final String lastName;
    final String username;
    final String email;
    final String? password;
    final String? imageUrl;
    final String role;
    final String? shift;

    UserProfile({
        required this.firstName,
        required this.lastName,
        required this.username,
        required this.email,
        this.password,
        this.imageUrl,
        required this.role,
        this.shift,
    });

    factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        firstName: json["firstName"],
        lastName: json["lastName"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        imageUrl: json["imageUrl"],
        role: json["role"],
        shift: json["shift"],
    );
    
    // Helper getter for full name
    String get fullName => '$firstName $lastName';
    
    // Helper getter for initials
    String get initials {
        if (firstName.isEmpty && lastName.isEmpty) return '?';
        if (firstName.isEmpty) return lastName[0].toUpperCase();
        if (lastName.isEmpty) return firstName[0].toUpperCase();
        return '${firstName[0]}${lastName[0]}'.toUpperCase();
    }
}