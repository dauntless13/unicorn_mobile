class VerifyOtpRequest {
  final String email;
  final String otp;
  final String lang;

  VerifyOtpRequest({
    required this.email,
    required this.otp,
    this.lang = "EN",
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "otp": otp,
      "lang": lang,
    };
  }
}