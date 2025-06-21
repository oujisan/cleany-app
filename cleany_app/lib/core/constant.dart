import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String baseUrl = dotenv.env['API_LOCAL_URL']!;
  // static String baseUrl = dotenv.env['API_AZURE_URL']!;

  // Auth API Endpoints
  static String apiLoginUrl = "${AppConstants.baseUrl}/api/auth/login";
  static String apiRegisterUrl = "${AppConstants.baseUrl}/api/auth/register";
  static String apiForgotPasswordUrl = "${AppConstants.baseUrl}/api/auth/forgot-password";
  static String apiVerifyPasswordUrl = "${AppConstants.baseUrl}/api/auth/verify-password";
  static String apiResetPasswordUrl = "${AppConstants.baseUrl}/api/auth/reset-password";

  // Task API Endpoints
  static String apiFetchRoutineTasksUrl = "${AppConstants.baseUrl}/api/task/assignment/routine";
  static String apiFetchUserReportTasksUrl(String userId) => "${AppConstants.baseUrl}/api/task/assignment/report/user/$userId";
  static String apiFetchTaskAssignmentByIdUrl(String assignmentId) => "${AppConstants.baseUrl}/api/task/assignment/$assignmentId";
  static String apiAddReportTaskUrl = "${AppConstants.baseUrl}/api/task/report/add";
  static String apiAddRoutineTaskUrl = "${AppConstants.baseUrl}/api/task/routine/add";
  static String apiUpdateRoutineTaskUrl(String taskId) => "${AppConstants.baseUrl}/api/task/routine/update/$taskId";
  static String apiUpdateReportTaskUrl(String taskId) => "${AppConstants.baseUrl}/api/task/report/update/$taskId";
  static String apiDeleteTaskUrl(String taskId) => "${AppConstants.baseUrl}/api/task/delete/$taskId";

  static String apiFetchTaskReportUrl() => "${AppConstants.baseUrl}/api/task/assignment/report";
  static String apiUpdateLocationAssignmentUrl(String assignmentId) => "${AppConstants.baseUrl}/api/task/assignment/update/location/$assignmentId";

  static String apiUpdateStatusTaskAssignmentUrl(String assignmentId) => "${AppConstants.baseUrl}/api/task/assignment/update/status/$assignmentId";
  static String apiFetchVerificationByAssignmentIdUrl(String assignmentId) => "${AppConstants.baseUrl}/api/verification/assignment/$assignmentId";
  static String apiUpdateVerificationStatusUrl(String assignmentId) => "${AppConstants.baseUrl}/api/verification/assigment/update/$assignmentId";
  static String apiUpdateTaskProofImagesUrl(String assignmentId) => "${AppConstants.baseUrl}/api/task/assignment/update/proofimageurl/$assignmentId";
  static String apiDeleteTask(String taskId) => "${AppConstants.baseUrl}/api/task/delete/$taskId";

  // UserProfile API Endpoints
  static String apiFetchUserProfileUrl(String userId) => "${AppConstants.baseUrl}/api/userProfile/$userId";
  static String updateUserProfileUrl(String userId) => "${AppConstants.baseUrl}/api/userProfile/update/$userId";
  static String apiDeleteUserProfileUrl(String userId) => "${AppConstants.baseUrl}/api/userProfile/softdelete/$userId";

  // Verification API Endpoints
  static String apiFetchVerificationUrl(String taskId) => "${AppConstants.baseUrl}/api/verification/task/$taskId";
  static String apiFetchVerificationByIdUrl(String verificationId) => "${AppConstants.baseUrl}/api/verification/$verificationId";

  static String apiFetchProfileUserUrl = "${AppConstants.baseUrl}/api/userProfile";

  // Area API Endpoints
  static String apiFetchAreaUrl = "${AppConstants.baseUrl}/api/area";

  // User API Endpoints
  static String apiFetchUsersUrl = "${AppConstants.baseUrl}/api/user";
  

  // Key Secure Storage
  static String keyToken = 'JwtToken';
  static String keyId = 'UserId';
  static String keyUsername = 'Username';
  static String keyRole = 'UserRole';
  static String keyImageUrl = 'UserImageUrl';
  static String keyExpireInUnix = 'Exp';
}
