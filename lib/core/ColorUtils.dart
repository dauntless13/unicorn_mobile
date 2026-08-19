import 'package:flutter/material.dart';
const Color boldTextColor =  Color(0xFF032241);
const Color normalTextColor =  Color(0xFF4F647A);
const Color borderColor =  Color(0xFF648DDB);
const Color primaryColor = Color(0xFF0C7189);
const Color secondaryColor = Color(0xFF00B69B);

const Color screenbackground = Color(0xFFE8FAFC);
// text color
const Color primaryTextColor = Color(0xFF212121);
const Color Buttonbarbordercolor = Color(0x80142247);
const Color chiptextcolor = Color(0xFF969696);
const Color searchbarcolor = const Color(0xFFF0F0F0);
const Color searchbarcolor1 = const Color(0xFFB4B4B4);

//border
const Color containerborder = Color(0x80002D5B);

//border
const Color screenbg = Color(0xFFFfFfFf);
const Color textFieldBorderColor = Color(0xFF94A3B8);

//slider
const Color slideractive = Color(0xFF142247);
const Color sliderinactive = Color(0xFFD9D9D9);
const Color cardborder = Color(0x80142247);

const Color teal = Color(0x14142247);
const Color backgroundfield = Color(0xFFFFFFFF);
const Color buttontheme = Color(0xFFFfFfFf);

// const Color trackColor = Color(0x6646A2BC);
const Color whiteColor = Color(0xFFFFFFFF);
const Color blackColor = Color(0xFF000000);

const Color errorColor = Color(0xFFDB4437);
const Color dividerColor = Color(0xFFBAB5B5);

// text color
const Color secondaryTextColor = Color(0xFF757575);

const Color greyColor = Color(0xFF424242);
// const Color  primaryColor = Color(0xFF008080);

/// BACK GROUND COLOR
const Color backgroundColor = Color(0xFFFEF8F0);

/// Container Color
const Color primaryContainerColor = Color(0xFFFFFFFF);

/// Button Color
const Color primaryButtonColor = Color(0xff7DC12A);

/// Primary Icon Color
const Color primaryIconColor = Color(0xFF6C757D);

/// Shadow Color
const Color shadowColor = Color(0x40000000);

/// COMMON COLOR  ///
const Color cursorColor = Color(0xFF000000);

/// General
 const white = Colors.white;
 const black = Colors.black;

 const red = Colors.red;

bool isLight(BuildContext context) => Theme.of(context).brightness == Brightness.light;

Color pageBg(BuildContext context) => isLight(context) ? Colors.white : const Color(0xFF0F0F0F);
Color cardBg(BuildContext context) => isLight(context) ? Colors.white : const Color(0xFF1A1A1A);
Color softBg(BuildContext context) => isLight(context) ? Colors.grey.shade100 : const Color(0xFF242424);

Color primaryText(BuildContext context) => isLight(context) ? Colors.black87 : Colors.white;
Color secondaryText(BuildContext context) => isLight(context) ? Colors.grey.shade600 : Colors.grey.shade400;

Color borderClr(BuildContext context) => isLight(context) ? Colors.grey.shade300 : Colors.white.withOpacity(0.12);
Color dividerClr(BuildContext context) => isLight(context) ? Colors.grey.shade200 : Colors.white.withOpacity(0.08);

// Onboarding specific
Color onboardHeaderLight = const Color(0xFF8DBEC7);
Color onboardHeaderDark  = const Color(0xFF1E3A40);

Color onboardHeaderBg(BuildContext context) => isLight(context) ? onboardHeaderLight : onboardHeaderDark;