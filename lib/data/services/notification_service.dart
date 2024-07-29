import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/constants/colors.dart';

class NotificationService {
  factory NotificationService() {
    return _instance;
  }

  NotificationService._privateConstructor();

  static final NotificationService _instance =
      NotificationService._privateConstructor();

  void showSnackBar({
    required BuildContext context,
    required String message,
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 6),
    SnackBarBehavior behavior = SnackBarBehavior.fixed,
  }) {
    final snackBar = SnackBar(
      content: Text(message, style: TextStyle(color: textColor)),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: behavior,
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showMaterialBanner({
    required BuildContext context,
    required String message,
    Color? backgroundColor,
    Color textColor = Colors.white,
    String dismissText = 'Dismiss',
    Duration duration = const Duration(seconds: 3),
  }) {
    final materialBanner = MaterialBanner(
      content: Text(message, style: TextStyle(color: textColor)),
      backgroundColor: backgroundColor ?? ColorPalette.primary,
      actions: [
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).clearMaterialBanners();
          },
          child: Text(
            dismissText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
    ScaffoldMessenger.of(context).showMaterialBanner(materialBanner);
    Future.delayed(duration, () {
      ScaffoldMessenger.of(context).clearMaterialBanners();
    });
  }

  void showToast({
    required String message,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    double fontSize = 16.0,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }
}
