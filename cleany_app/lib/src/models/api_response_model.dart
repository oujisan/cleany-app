class ApiResponseModel<T> {
  final bool success;
  final String message;
  final T? data;
  final String? error;

  ApiResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.error,
  });

  factory ApiResponseModel.fromJson(Map<String, dynamic> json,T Function(dynamic) fromJsonT,) 
  {
    return ApiResponseModel<T>(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      error: json['error'],
    );
  }
}
