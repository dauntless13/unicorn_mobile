import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:unicorn/service/session/session_manager.dart';
import '../../ui/auth/view/model/login/login_response.dart';

class SessionHelper {
  SessionHelper._();

  static SessionHelper _instance = SessionHelper._();

  factory SessionHelper() {
    return _instance;
  }

  Future<void> setLoginResponse(LoginResponse response) async {
    await SessionManager.setStringValue(
      spSignupResponse,
      json.encode(response.toJson()),
    );
  }

  Future<void> setIntro(int status) async {
    // save user values in shared pref
    await SessionManager.setIntValue(spIntro, status);
  }

  Future<int?> getIntro() async {
    int response = await SessionManager.getIntValue(spIntro);
    return response;
  }

  Future<LoginResponse?> getLoginResponse() async {
    String? response = await SessionManager.getStringValue(spSignupResponse);

    if (response == null || response.isEmpty) {
      return null;
    }

    try {
      return LoginResponse.fromJson(json.decode(response));
    } catch (e) {
      debugPrint("LoginResponse parse error: $e");
      return null;
    }
  }

  Future<void> clearLoginSession() async {
    await SessionManager.deleteData(spSignupResponse);
  }
}

const String spSignupResponse = "spSignupResponse";
const String spIntro = "spIntro";
