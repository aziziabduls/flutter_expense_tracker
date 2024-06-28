import 'package:expanse_tracker_app/component/expense_summary.dart';
import 'package:expanse_tracker_app/data/expense_data.dart';
import 'package:expanse_tracker_app/helper/utils.dart';
import 'package:expanse_tracker_app/models/expense_item.dart';
import 'package:expanse_tracker_app/component/expense_tile.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  final inputDecorName = InputDecoration(
    hintText: 'Name',
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.4),
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.blue,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.red,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.red,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.4),
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
  );

  final inputDecorAmount = InputDecoration(
    hintText: 'Amount',
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.4),
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.blue,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.red,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.red,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.4),
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
  );

  void addNewExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add new expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newExpenseNameController,
              decoration: inputDecorName,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newExpenseAmountController,
              decoration: inputDecorAmount,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (newExpenseAmountController.text.isNotEmpty && newExpenseNameController.text.isNotEmpty) {
                save();
              }
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: cancel,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void save() {
    ExpenseItem newExpenseItem = ExpenseItem(
      name: newExpenseNameController.text,
      amount: newExpenseAmountController.text,
      dateTime: DateTime.now(),
    );
    Provider.of<ExpenseData>(context, listen: false).addNewExpanse(newExpenseItem);
    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newExpenseAmountController.clear();
    newExpenseNameController.clear();
  }

  @override
  void initState() {
    Provider.of<ExpenseData>(context, listen: false).prepareData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.black,
            toolbarHeight: 80,
            title: const Text(
              'Expense Tracker',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: value.getAllExpenseList().isEmpty
              ? SizedBox(
                  height: MediaQuery.sizeOf(context).height,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No Expanse This Week',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Add some expanse click + button below',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.idCurrencyFormatter(
                              Provider.of<ExpenseData>(context, listen: false)
                                  .getTotalAmountThisWeek()
                                  .toDouble(),
                            ).toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            Utils.getFormattedWeekRange(),
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ExpenseSummary(startOfWeek: value.startOfWeekDate()),
                    const SizedBox(height: 50),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: value.getAllExpenseList().length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // edit
                              debugPrint('edit');
                            },
                            child: Slidable(
                              key: ValueKey(index),
                              endActionPane: ActionPane(
                                extentRatio: 0.2,
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    backgroundColor: Colors.red,
                                    onPressed: (context) {
                                      Provider.of<ExpenseData>(context, listen: false).removeNewExpanse(
                                        value.overallExpenseList[index],
                                      );
                                    },
                                    icon: Icons.delete,
                                    foregroundColor: Colors.white,
                                  ),
                                ],
                              ),
                              child: ExpenseTile(
                                name: value.getAllExpenseList()[index].name,
                                amount: value.getAllExpenseList()[index].amount,
                                dateTime: value.getAllExpenseList()[index].dateTime,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: addNewExpenseDialog,
            backgroundColor: Colors.black,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
