class VerificationModel {
  final String verificationId;
  final String assignmentId;
  final String? userId;
  final String? username;
  final String? role;
  final String? status;
  final String? feedback;
  final String? verificationAt;

  VerificationModel({
    required this.verificationId,
    required this.assignmentId,
    required this.userId,
    this.username,
    this.role,
    this.status,
    this.feedback,
    this.verificationAt,
  });

  factory VerificationModel.fromJson(Map<String, dynamic> json) =>
      VerificationModel(
        verificationId: json['verification_id'].toString(),
        assignmentId: json['assignment_id'].toString(),
        userId: json['verification_by']['userId'].toString(),
        username: json['verification_by']['username'] ?? '',
        role: json['verification_by']['role'] ?? '',
        status: json['status'] ?? '',
        feedback: json['feedback'] ?? '',
        verificationAt: json['verification_at'] ?? '',
      );

  static VerificationModel empty() => VerificationModel(
    verificationId: '',
    assignmentId: '',
    userId: '',
    username: '',
    role: '',
    status: '',
    feedback: '',
    verificationAt: '',
  );
}
