import 'package:expanse_tracker_app/helper/utils.dart';
import 'package:flutter/material.dart';

class ExpenseTile extends StatelessWidget {
  final String name;
  final String amount;
  final DateTime dateTime;

  const ExpenseTile({
    super.key,
    required this.name,
    required this.amount,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      title: Text(name),
      subtitle: Text('${dateTime.day}/${dateTime.month}/${dateTime.year}'),
      trailing: Text(
        Utils.idCurrencyFormatter(double.parse(amount)),
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}
