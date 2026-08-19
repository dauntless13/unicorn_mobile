import 'package:flutter/material.dart';
import '../ColorUtils.dart';
import '../common_size/common_font_size.dart';

class MyRegularText extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? decorationColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? align;
  final int? maxlines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final TextStyle? style;
  final FontStyle? fontStyle;

  const MyRegularText({
    super.key,
    required this.label,
    this.color,
    this.decorationColor,
    this.fontSize,
    this.fontStyle,
    this.fontWeight = FontWeight.w400,
    this.align = TextAlign.center,
    this.maxlines,
    this.overflow,
    this.decoration = TextDecoration.none,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: align,
      maxLines: maxlines,
      overflow: overflow ?? TextOverflow.ellipsis,
      style: style ??
          TextStyle(
            fontFamily: 'GramatikaTrial', // 👈 FORCE FONT
            color: color ?? blackColor,
            fontSize: fontSize ?? CommonFontSize.regularFont(),
            fontWeight: fontWeight,
            fontStyle: fontStyle ?? FontStyle.normal,
            decoration: decoration,
            decorationColor: decorationColor,
          ),
    );
  }
}
