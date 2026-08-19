class OtpVerifyResponse {
  final bool success;
  final String message;
  final String data;

  OtpVerifyResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OtpVerifyResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerifyResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      data: json['data'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "data": data,
    };
  }
}