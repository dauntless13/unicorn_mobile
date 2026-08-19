import 'package:sizer/sizer.dart';
import 'common_hight_width.dart';

class CommonFontSize {
  const CommonFontSize._();

  static double extraSmallFont({double? extraSmallFont}) {
    final appDimensions = AppDimensions.instance;
    final height = appDimensions?.height;

    if (extraSmallFont != null) {
      return extraSmallFont;
    } else if (height != null) {
      return height * 0.08;
    } else {
      return 8.0.sp;
    }
  }

  static double smallFont({double? smallFont}) {
    final appDimensions = AppDimensions.instance;
    final height = appDimensions?.height;

    if (smallFont != null) {
      return smallFont;
    } else if (height != null) {
      return height * 0.012;
    } else {
      return 12.0.sp;
    }
  }

  static double mediumFont({double? mediumFont}) {
    final appDimensions = AppDimensions.instance;
    final height = appDimensions?.height;

    if (mediumFont != null) {
      return mediumFont;
    } else if (height != null) {
      return height * 0.018;
    } else {
      return 16.0.sp;
    }
  }

  static double regularFont({double? regularFont}) {
    final appDimensions = AppDimensions.instance;
    final height = appDimensions?.height;

    if (regularFont != null) {
      return regularFont;
    } else if (height != null) {
      return height * 0.016;
    } else {
      print('height is null');
      return 14.0.sp;
    }
  }

  static double largeFont({double? largeFont}) {
    final appDimensions = AppDimensions.instance;
    final height = appDimensions?.height;

    if (largeFont != null) {
      return largeFont;
    } else if (height != null) {
      return height * 0.021;
    } else {
      return 18.0.sp;
    }
  }

  static double extraLargeFont({double? extraLargeFont}) {
    final appDimensions = AppDimensions.instance;
    final height = appDimensions?.height;

    if (extraLargeFont != null) {
      return extraLargeFont;
    } else if (height != null) {
      return height * 0.026;
    } else {
      return 20.0.sp;
    }
  }
}
