
import 'package:flutter/material.dart';

class MyThemeButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool showLoader;

  const MyThemeButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.showLoader = true,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = const Color(0xFF0A6C7D);

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          disabledBackgroundColor: buttonColor.withOpacity(0.55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: isLoading && showLoader
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              )
            : Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(isLoading ? 0.92 : 1),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
