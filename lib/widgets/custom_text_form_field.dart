import 'package:flutter/material.dart';
import 'package:pizzamenu/values/values.dart';

class CustomTextFormField extends StatelessWidget {
  final TextStyle textFormFieldStyle;
  final TextStyle hintTextStyle;
  final BorderStyle borderStyle;
  final double borderRadius;
  final double borderWidth;
  final double contentPaddingHorizontal;
  final double contentPaddingVertical;
  final String prefixIconImagePath;
  final String hintText;
  final Color prefixIconColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color enabledBorderColor;
  final Color fillColor;
  final bool filled;
  final bool obscured;
  final bool hasPrefixIcon;
  final int maxLines;
  final TextEditingController controller;
  Function(String) onChanged;
  Function(String) onFieldSubmitted;
  CustomTextFormField({
    this.hasPrefixIcon = false,
    required this.prefixIconImagePath,
    this.maxLines = 1,
    this.textFormFieldStyle = Styles.normalTextStyle,
    this.hintTextStyle = Styles.normalTextStyle,
    this.borderStyle = BorderStyle.none,
    this.borderRadius = Sizes.RADIUS_12,
    this.borderWidth = Sizes.WIDTH_0,
    this.contentPaddingHorizontal = Sizes.PADDING_0,
    this.contentPaddingVertical = Sizes.PADDING_22,
    required this.hintText,
    this.prefixIconColor = AppColors.secondaryText,
    this.borderColor = AppColors.greyShade1,
    this.focusedBorderColor = AppColors.greyShade1,
    this.enabledBorderColor = AppColors.greyShade1,
    this.fillColor = AppColors.fillColor,
    this.filled = true,
    required this.obscured,
    required this.controller,
    required this.onChanged,
    required this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    // controller.
    return Container(
      child: TextFormField(

        textDirection: TextDirection.ltr,
        focusNode: FocusNode(),
        // controller: controller,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        style: textFormFieldStyle,
        // maxLines: maxLines,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: borderColor,
              width: borderWidth,
              style: borderStyle,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: enabledBorderColor,
              width: borderWidth,
              style: borderStyle,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: focusedBorderColor,
              width: borderWidth,
              style: borderStyle,
            ),
          ),
          prefixIcon: hasPrefixIcon
              ? ImageIcon(
                  AssetImage(prefixIconImagePath),
                  color: prefixIconColor,
                )
              : null,
          contentPadding: EdgeInsets.symmetric(
            horizontal: contentPaddingHorizontal,
            vertical: contentPaddingVertical,
          ),
          hintText: hintText,
          hintStyle: hintTextStyle,
          filled: filled,
          fillColor: fillColor,
        ),
        obscureText: obscured,
      ),
    );
  }
}
