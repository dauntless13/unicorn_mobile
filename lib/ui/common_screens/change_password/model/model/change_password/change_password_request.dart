class ChangePasswordRequest {
  String? password;
  String? newPassword;
  String? confirmPassword;
  String? lang;

  ChangePasswordRequest({
    this.password,
    this.newPassword,
    this.confirmPassword,
    this.lang,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['password'] = password;
    data['newPassword'] = newPassword;
    data['confirmPassword'] = confirmPassword;
    data['lang'] = lang;
    return data;
  }
}