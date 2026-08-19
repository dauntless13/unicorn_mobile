import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'my_regular_text.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade200,
            ),
            padding: const EdgeInsets.all(12),
            child: Image.asset('assets/png/splash_screen.png'),
          ),
          const SizedBox(height: 12),
          MyRegularText(
            label: 'No Records Found'.tr,
            fontSize: 14,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
