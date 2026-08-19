import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDimensions extends ChangeNotifier {
  static AppDimensions? _instance;

  static AppDimensions? get instance => _instance;
  double width = 0;
  double height = 0;
  int gridItemCount = 1;
  Orientation? orientation;

  AppDimensions._internal(BuildContext context, BoxConstraints constraints) {
    orientation = MediaQuery.of(context).orientation;
    width = constraints.maxWidth;
    height = constraints.maxHeight;
    gridItemCount = _getCrossAxisCount(context);
    notifyListeners();
  }

  static AppDimensions createInstance(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    AppDimensions.update(context, constraints);

    return _instance ??= AppDimensions._internal(context, constraints);
  }

  int _getCrossAxisCount(BuildContext context) {
    final screenWidth = context.width;
    if (screenWidth > 1000) {
      return 3;
    } else if (screenWidth >= 800) {
      return 2;
    } else {
      return 2;
    }
  }

  AppDimensions.updateGridCount(BuildContext context) {
    gridItemCount = _getCrossAxisCount(context);
    notifyListeners();
  }

  AppDimensions.update(BuildContext context, BoxConstraints constraints) {
    _instance = AppDimensions._internal(context, constraints);
    _updateDimensions(context, constraints);
    _updateOrientation(context);
    _getCrossAxisCount(context);
    _logDimensions();
  }

  void _updateDimensions(BuildContext context, BoxConstraints constraints) {
    print('updating dimensions++$height');
    width = constraints.maxWidth;
    height = constraints.maxHeight;
    notifyListeners();
  }

  void _updateOrientation(BuildContext context) {
    orientation = MediaQuery.orientationOf(context);
  }

  void _logDimensions() {
    print("SCREEN WIDTH: $width");
    print("SCREEN HEIGHT: $height");
    print("ORIENTATION: $orientation");
    print("GRID: $gridItemCount");
  }
}
