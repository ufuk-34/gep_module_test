import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CustomText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final String? fontFamily;
  final TextAlign? textAlign;
  final TextDecoration? underLine;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? height;
  final FontWeight? fontWeight;

  const CustomText({
    super.key,
    this.color = Colors.black,
    required this.text,
    this.fontSize = 13,
    this.fontFamily,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.underLine,
    this.height,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
        overflow: overflow,
        maxLines: maxLines,
        style: TextStyle(
          height: height,
          decoration: underLine,
          decorationStyle: TextDecorationStyle.solid,
          decorationThickness: 1.5.w,
          color: color,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          fontSize: fontSize.sp,
          fontStyle: FontStyle.normal,
        ),
        textAlign: textAlign);
  }
}
