import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../ColorUtils.dart';
import '../common_size/common_font_size.dart';
import 'decoration_utils.dart';

class MyFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final bool isEnable;
  final bool isRequire;
  final bool isReadOnly;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final bool isIconDisplay;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final GestureTapCallback? onTap;
  final Widget? icon;
  final Widget? suffixIcon;
  final double borderRadius;

  const MyFormField({
    Key? key,
    this.controller,
    this.labelText,
    this.hintText,
    this.isEnable = true,
    this.isRequire = false,
    this.isReadOnly = false,
    this.isIconDisplay = true,
    this.textInputAction,
    this.onSubmitted,
    this.textInputType = TextInputType.text,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.onTap,
    this.inputFormatters,
    this.icon,
    this.suffixIcon,
    this.obscureText = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.borderRadius = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLight =
        Theme.of(context).brightness == Brightness.light;

    return TextFormField(
      controller: controller,
      enabled: isEnable,
      obscureText: obscureText,
      enableSuggestions: enableSuggestions,
      autocorrect: autocorrect,
      readOnly: isReadOnly,
      inputFormatters: inputFormatters,
      style: TextStyle(
        fontSize: CommonFontSize.regularFont(),
        fontFamily: GoogleFonts.roboto().fontFamily,
        color: isLight ? Colors.black87 : Colors.white,
      ),
      cursorColor: const Color(0xFF0C7189),
      textInputAction: textInputAction ?? TextInputAction.done,
      keyboardType: textInputType,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: DecorationUtils(context)
          .getInputDecoration(
        borderRadius: borderRadius,
        icon: icon,
        suffixIcon: suffixIcon,
        labelText: labelText,
        hintText: hintText,
        isRequire: isRequire,
        isEnable: isEnable,
        isIconDisplay: isIconDisplay,
      ),
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      onFieldSubmitted: onSubmitted ??
              (_) => FocusScope.of(context).unfocus(),
    );
  }
}
