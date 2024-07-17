import 'package:expanse_tracker_app/database/hive_database.dart';
import 'package:expanse_tracker_app/helper/utils.dart';
import 'package:expanse_tracker_app/models/expense_item.dart';
import 'package:flutter/material.dart';

class ExpenseData extends ChangeNotifier {
  // list all expenses
  List<ExpenseItem> overallExpenseList = [];

  // get expenses
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  final db = HiveDatabase();
  void prepareData() {
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

  // add new expenses
  void addNewExpanse(ExpenseItem newExpenseItem) {
    overallExpenseList.add(newExpenseItem);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // edit expanse
  void editExpanse(ExpenseItem oldExpenseItem, ExpenseItem newExpenseItem) {
    int index = overallExpenseList.indexOf(oldExpenseItem);
    if (index != -1) {
      overallExpenseList[index] = newExpenseItem;
      notifyListeners();
      db.saveData(overallExpenseList);
    }
  }

  // delete expenses
  void removeNewExpanse(ExpenseItem expenseItem) {
    overallExpenseList.remove(expenseItem);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // get weekday
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thr';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return 'Invalid day';
    }
  }

  // get start of the week
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    // get today date
    DateTime today = DateTime.now();

    // go backwards from today to find sunday
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }

    return startOfWeek!;
  }

  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {
      // date (yyyymmdd) : ammountTotalForDay
    };

    for (var expense in overallExpenseList) {
      String date = Utils.convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }

    return dailyExpenseSummary;
  }

  double getTotalAmountThisWeek() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    double totalAmount = 0.0;
    for (ExpenseItem expense in overallExpenseList) {
      if (expense.dateTime.isAfter(startOfWeek) && expense.dateTime.isBefore(endOfWeek)) {
        totalAmount += double.parse(expense.amount);
      }
    }

    return totalAmount;
  }
}
