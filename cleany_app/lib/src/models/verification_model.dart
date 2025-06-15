class VerificationModel {
  final String verificationId;
  final String assignmentId;
  final String? username;
  final String? status;
  final String? feedback;
  final String? verificationAt;

  VerificationModel({
    required this.verificationId,
    required this.assignmentId,
    this.username,
    this.status,
    this.feedback,
    this.verificationAt,
  });

  factory VerificationModel.fromJson(Map<String, dynamic> json) =>
      VerificationModel(
        verificationId: json['verification_id'].toString(),
        assignmentId: json['assignment_id'].toString(),
        username: json['verification_by']?['username'] ?? '',
        status: json['status'] ?? '',
        feedback: json['feedback'] ?? '',
        verificationAt: json['verification_at'] ?? '',
      );

  static VerificationModel empty() => VerificationModel(
    verificationId: '',
    assignmentId: '',
    username: '',
    status: '',
    feedback: '',
    verificationAt: '',
  );
}
