import 'package:expanse_tracker_app/bar_graph/bar_graph.dart';
import 'package:expanse_tracker_app/data/expense_data.dart';
import 'package:expanse_tracker_app/helper/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;

  const ExpenseSummary({
    super.key,
    required this.startOfWeek,
  });

  @override
  Widget build(BuildContext context) {
    String sun = convertDateTimeToString(startOfWeek.add(const Duration(days: 0)));
    String mon = convertDateTimeToString(startOfWeek.add(const Duration(days: 1)));
    String tue = convertDateTimeToString(startOfWeek.add(const Duration(days: 2)));
    String wed = convertDateTimeToString(startOfWeek.add(const Duration(days: 3)));
    String thu = convertDateTimeToString(startOfWeek.add(const Duration(days: 4)));
    String fri = convertDateTimeToString(startOfWeek.add(const Duration(days: 5)));
    String sat = convertDateTimeToString(startOfWeek.add(const Duration(days: 6)));

    return Consumer<ExpenseData>(
      builder: (context, value, child) {
        double maxY = 100000;
        if (Provider.of<ExpenseData>(context, listen: false).getTotalAmountThisWeek().toDouble() > 100000) {
          maxY = maxY * 10;
        }
        return SizedBox(
          height: 230,
          child: MyBarGraph(
            maxY: maxY,
            sunAmount: value.calculateDailyExpenseSummary()[sun] ?? 0,
            monAmount: value.calculateDailyExpenseSummary()[mon] ?? 0,
            tueAmount: value.calculateDailyExpenseSummary()[tue] ?? 0,
            wedAmount: value.calculateDailyExpenseSummary()[wed] ?? 0,
            thuAmount: value.calculateDailyExpenseSummary()[thu] ?? 0,
            friAmount: value.calculateDailyExpenseSummary()[fri] ?? 0,
            satAmount: value.calculateDailyExpenseSummary()[sat] ?? 0,
          ),
        );
      },
    );
  }
}
