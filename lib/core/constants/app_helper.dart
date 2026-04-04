import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppHelper {
  static String getFormattedDateString(DateTime selectedDate) {
    return DateFormat().add_yMMMd().format(selectedDate);
  }

  static DateTime getFormattedDateTime(String selectedDate) {
    return DateFormat.yMMMd().parse(selectedDate);
  }

  static String getFormattedTimeString(
    TimeOfDay selectedTime,
    BuildContext context,
  ) {
    return selectedTime.format(context);
  }

  static TimeOfDay getFormattedTime(String selectedTime) {
    final format = DateFormat("hh:mm a");
    DateTime dateTime = format.parse(selectedTime.toUpperCase());

    return TimeOfDay.fromDateTime(dateTime);
  }
}
