import 'dart:io';
import 'package:intl/intl.dart';

import 'package:money_formatter/money_formatter.dart';

class Utils {
  static String idCurrencyFormatter(double amount) {
    MoneyFormatter fmf = MoneyFormatter(amount: amount);
    String idrFormatter = fmf
        .copyWith(
          symbol: 'IDR',
          symbolAndNumberSeparator: ' ',
        )
        .output
        .symbolOnLeft
        .toString();
    return idrFormatter;
  }

  static String getMonthNow() {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[DateTime.now().month - 1];
  }

  static int getWeekOfMonth() {
    DateTime firstDayOfMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    int firstWeekday = firstDayOfMonth.weekday;
    int offset = (firstWeekday + DateTime.now().day - 1) ~/ 7;
    return offset + 1;
  }

  static String getLocalCurrency() {
    return NumberFormat.simpleCurrency(locale: Platform.localeName).currencySymbol;
  }

  static List<DateTime> getFirstAndLastDayOfWeek() {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;
    DateTime firstDayOfWeek = now.subtract(Duration(days: currentWeekday));
    DateTime lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));
    return [firstDayOfWeek, lastDayOfWeek];
  }

  static String formatWeekRange(DateTime firstDay, DateTime lastDay) {
    String month = DateFormat.MMM().format(firstDay);
    String year = DateFormat.y().format(firstDay);
    String formattedFirstDay = DateFormat.d().format(firstDay);
    String formattedLastDay = DateFormat.d().format(lastDay);
    return '$month $formattedFirstDay - $formattedLastDay, $year';
  }

  static String getFormattedWeekRange() {
    List<DateTime> weekRange = getFirstAndLastDayOfWeek();
    return formatWeekRange(weekRange[0], weekRange[1]);
  }

  static String convertDateTimeToString(DateTime dateTime) {
    String year = dateTime.year.toString();

    String month = dateTime.month.toString();
    if (month.length == 1) {
      month = '0$month';
    }

    String day = dateTime.day.toString();
    if (day.length == 1) {
      month = '0$day';
    }
    String yyyymmdd = year + month + day;

    return yyyymmdd;
  }
}
