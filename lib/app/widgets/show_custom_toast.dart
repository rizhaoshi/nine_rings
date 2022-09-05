import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

void showCustomToast(String message) {
  var toast = Container(
    constraints: const BoxConstraints(maxWidth: 300),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.black.withOpacity(0.8),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    child: Text(
      message,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
  );

  showToastWidget(
    toast,
    // duration: _defaultDuration,
    // animationDuration: _defaultAnimaDuration,
    position: ToastPosition.center,
  );
}
