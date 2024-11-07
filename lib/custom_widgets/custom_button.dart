import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:property_app/constant_widget/constant_widgets.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {super.key,
      this.onTap,
      this.width,
      this.margin,
      required this.text,
      this.height,
      this.fontSize,
      this.btnColor,
      this.borderColor,
      this.btnTextColor,
      this.isLoading,
      this.borderRadius,
      this.gradientColor});

  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final String? text;
  final double? fontSize;
  bool? isLoading = false;
  Color? btnColor;
  Color? borderColor;
  Color? btnTextColor;
  BorderRadius? borderRadius;
  Gradient? gradientColor;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap ??
          () {
            if (kDebugMode) {
              print(btnColor);
            }
          },
      child: Container(
        width: width ?? size.width * 0.4,
        height: height ?? size.height * 0.07,
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(10),
          gradient: gradientColor ?? gradient(),
          border: Border.all(color: borderColor ?? Colors.grey.shade100),
        ),
        child: Center(
            child: isLoading == true
                ? const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ))
                : customText(
                    text: text,
                    color: btnTextColor ?? Colors.white,
                    fontSize: fontSize ?? 24,
                    fontWeight: FontWeight.w500)),
      ),
    );
  }
}

String formatTime(DateTime time) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(time);

  if (time.year == now.year && time.month == now.month && time.day == now.day) {
    // If the timestamp is from today, show the time only
    return DateFormat('hh:mm a').format(time);
  } else if (difference.inDays == 1 && now.day != time.day) {
    // If the timestamp is from yesterday, show 'Yesterday'
    return 'Yesterday';
  } else {
    // Otherwise, show the date
    return DateFormat('dd MMM yyyy').format(time);
  }
}
