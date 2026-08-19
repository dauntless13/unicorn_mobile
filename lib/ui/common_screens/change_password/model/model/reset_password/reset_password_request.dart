class ResetPasswordRequest {
  String? email;
  String? newPassword;
  String? confirmPassword;
  String? lang;

  ResetPasswordRequest({
    this.email,
    this.newPassword,
    this.confirmPassword,
    this.lang,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
      "lang": lang,
    };
  }
}