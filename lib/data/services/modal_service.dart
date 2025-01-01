import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/presentation/widgets/input_match_confirmation_widget.dart';
import 'package:toastification/toastification.dart';

/// Displays various, flexible modals.
class ModalService {
  static void showSuccess({
    required String title,
  }) {
    _showToast(
      title: title,
      toastificationType: ToastificationType.success,
      icon: const Icon(Icons.check),
      primaryColor: Colors.green,
    );
  }

  static void showError({
    required String title,
  }) {
    _showToast(
      title: title,
      toastificationType: ToastificationType.error,
      icon: const Icon(Icons.error),
      primaryColor: Colors.red,
    );
  }

  /// Shows a brief, customizable toast.
  static void _showToast({
    required String title,
    required ToastificationType toastificationType,
    required Widget icon,
    required MaterialColor primaryColor,
  }) {
    toastification.show(
      autoCloseDuration: const Duration(seconds: 3),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: Globals.isTablet ? 26 : 18,
          fontFamily: 'Montserrat',
        ),
      ),
      type: toastificationType,
      style: ToastificationStyle.fillColored,
      icon: icon,
      primaryColor: primaryColor,
      backgroundColor: primaryColor.shade100,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: true,
    );
  }

  static Future<bool?> showInputMatchConfirmation({
    required BuildContext context,
    required String title,
    required String hintText,
    required String match,
  }) =>
      showDialog<bool>(
        useRootNavigator: false,
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => Material(
          color: Colors.transparent,
          child: InputMatchConfirmationWidget(
            hintText: hintText,
            title: title,
            match: match,
          ),
        ),
      );
}
