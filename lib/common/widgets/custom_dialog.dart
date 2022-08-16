import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showTimePickerDialog(BuildContext context,
    {Color? bgColor, Function(String? selectedHour, String? selectedMins)? selectTimeCallBack}) {
  
  showCupertinoDialog(context: context, builder: builder)
}
