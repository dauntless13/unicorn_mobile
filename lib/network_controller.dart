import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final isNetworkAvailable = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initConnectivityListener();

    // 👇 REACT TO CHANGES SAFELY
    ever(isNetworkAvailable, _handleNetworkChange);
  }

  void _initConnectivityListener() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final hasInternet = await _hasInternetConnection();

    isNetworkAvailable.value =
        connectivityResult != ConnectivityResult.none && hasInternet;

    Connectivity().onConnectivityChanged.listen((result) async {
      final hasInternet = await _hasInternetConnection();
      isNetworkAvailable.value =
          result != ConnectivityResult.none && hasInternet;
    });
  }

  void _handleNetworkChange(bool isConnected) {
    if (!isConnected) {
      if (!(Get.isDialogOpen ?? false)) {
        Get.dialog(
          WillPopScope(
            onWillPop: () async => false,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.wifi_off,
                      size: 80,
                      color: Colors.white,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No Network Connection',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          barrierDismissible: false,
        );
      }
    } else {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }

  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
