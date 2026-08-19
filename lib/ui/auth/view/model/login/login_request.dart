class LoginRequest {
  final String emailAddress;
  final String password;
  final String? fcmToken;
  final String? deviceId;
  final String deviceType;
  final String lang;

  LoginRequest({
    required this.emailAddress,
    required this.password,
    this.fcmToken,
    this.deviceId,
    required this.deviceType,
    required this.lang,
  });

  /// Convert object to JSON (For API request)
  Map<String, dynamic> toJson() {
    return {
      "emailAddress": emailAddress,
      "password": password,
      "fcmToken": fcmToken,
      "deviceId": deviceId,
      "deviceType": deviceType,
      "lang": lang,
    };
  }

  /// Create object from JSON (If needed)
  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      emailAddress: json["emailAddress"] ?? "",
      password: json["password"] ?? "",
      fcmToken: json["fcmToken"],
      deviceId: json["deviceId"],
      deviceType: json["deviceType"] ?? "",
      lang: json["lang"] ?? "",
    );
  }
}
