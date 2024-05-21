import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

/// Displays various, flexible modals.
class ModalService {
  /// Shows a brief, customizable toast.
  static void showToast({
    required String title,
    required ToastificationType toastificationType,
    required Widget? icon,
    required MaterialColor primaryColor,
  }) {
    toastification.show(
      autoCloseDuration: const Duration(seconds: 3),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 26,
          fontFamily: 'Montserrat',
        ),
      ),
      type: toastificationType,
      style: ToastificationStyle.fillColored,
      icon: icon,
      primaryColor: primaryColor,
      backgroundColor: primaryColor.shade100,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: true,
    );
  }
}
