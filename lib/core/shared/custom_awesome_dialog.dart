import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class CustomAwesomeDialog {
  static void showInfoDialog(
    BuildContext context, {
    String title = "",
    String desc = "",
    DialogType dialogtype = DialogType.info,
    VoidCallback? onOkPress,
    VoidCallback? onCancelPress,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: dialogtype,
      animType: AnimType.rightSlide,
      title: title,
      desc: desc,
      btnCancelOnPress: onCancelPress,
      btnOkOnPress: onOkPress,
    ).show();
  }
}
