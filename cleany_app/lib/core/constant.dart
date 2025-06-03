import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String baseUrl = dotenv.env['API_LOCAL_URL']!;

  // Auth API Endpoints
  static String apiLoginUrl = "${AppConstants.baseUrl}/api/auth/login";
  static String apiRegisterUrl = "${AppConstants.baseUrl}/api/auth/register";
  static String apiForgotPasswordUrl = "${AppConstants.baseUrl}/api/auth/forgot-password";
  static String apiVerifyPasswordUrl = "${AppConstants.baseUrl}/api/auth/verify-password";
  static String apiResetPasswordUrl = "${AppConstants.baseUrl}/api/auth/reset-password";

  // Task API Endpoints
  static String apiFetchUserRoutineTasksUrl(String userId) => "${AppConstants.baseUrl}/api/task/assignment/routine/user/$userId";
  static String apiFetchUserReportTasksUrl(String userId) => "${AppConstants.baseUrl}/api/task/assignment/report/user/$userId";
  static String apiFetchTaskByIdUrl(String userId) => "${AppConstants.baseUrl}/api/task/assignment/$userId";
  static String apiAddReportTaskUrl = "${AppConstants.baseUrl}/api/task/report/add";
  static String apiAddRoutineTaskUrl = "${AppConstants.baseUrl}/api/task/routine/add";
  static String apiUpdateRoutineTaskUrl(String taskId) => "${AppConstants.baseUrl}/api/task/routine/$taskId";
  static String apiUpdateReportTaskUrl(String taskId) => "${AppConstants.baseUrl}/api/task/report/$taskId";
  static String apiDeleteTaskUrl(String taskId) => "${AppConstants.baseUrl}/api/task/delete/$taskId";

  // UserProfile API Endpoints
  static String apiFetchUserProfileUrl(String userId) => "${AppConstants.baseUrl}/api/userProfile/$userId";
  static String updateUserProfileUrl(String userId) => "${AppConstants.baseUrl}/api/userProfile/update/$userId";
  static String apiDeleteUserProfileUrl(String userId) => "${AppConstants.baseUrl}/api/userProfile/softdelete/$userId";

  // Verification API Endpoints
  static String apiFetchVerificationUrl(String taskId) => "${AppConstants.baseUrl}/api/verification/task/$taskId";
  static String apiFetchVerificationByIdUrl(String verificationId) => "${AppConstants.baseUrl}/api/verification/$verificationId";

  // Area API Endpoints
  static String apiFetchAreaUrl = "${AppConstants.baseUrl}/api/area";


  // Key Secure Storage
  static String apiFetchUsersUrl = "${AppConstants.baseUrl}/api/user";
  static String keyToken = 'JwtToken';
  static String keyId = 'UserId';
  static String keyUsername = 'Username';
  static String keyRole = 'UserRole';
}
