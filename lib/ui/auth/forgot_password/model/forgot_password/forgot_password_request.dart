class ForgotPasswordRequest {
  final String email;
  final String lang;

  ForgotPasswordRequest({
    required this.email,
    this.lang = "EN",
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "lang": lang,
    };
  }
}