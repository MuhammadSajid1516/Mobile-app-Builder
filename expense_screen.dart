import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../services/expense_service.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final ExpenseService expenseService = ExpenseService();

  final expenseNameController = TextEditingController();
  final categoryController = TextEditingController();
  final amountController = TextEditingController();

  String expenseDate = "";

  Future<void> selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2050),
    );

    if (pickedDate != null) {
      setState(() {
        expenseDate =
            "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
      });
    }
  }

  Future<void> addExpense() async {
    final expense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      expenseName: expenseNameController.text,
      category: categoryController.text,
      amount: amountController.text,
      expenseDate: expenseDate,
    );

    await expenseService.addExpense(expense);

    expenseNameController.clear();
    categoryController.clear();
    amountController.clear();

    if (!mounted) return;

    Navigator.pop(context);
  }

  void showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Expense"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: expenseNameController,
                  decoration: const InputDecoration(labelText: "Expense Name"),
                ),

                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: "Category"),
                ),

                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Amount"),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: selectDate,
                  child: Text(
                    expenseDate.isEmpty ? "Select Date" : expenseDate,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(onPressed: addExpense, child: const Text("Save")),
          ],
        );
      },
    );
  }

  void showEditExpenseDialog(Expense expense) {
    expenseNameController.text = expense.expenseName;
    categoryController.text = expense.category;
    amountController.text = expense.amount;
    expenseDate = expense.expenseDate;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Expense"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: expenseNameController,
                  decoration: const InputDecoration(labelText: "Expense Name"),
                ),

                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: "Category"),
                ),

                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Amount"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {
                await expenseService.updateExpense(
                  Expense(
                    id: expense.id,
                    expenseName: expenseNameController.text,
                    category: categoryController.text,
                    amount: amountController.text,
                    expenseDate: expenseDate,
                  ),
                );

                if (!mounted) return;

                Navigator.pop(context);
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FC),

      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          "Expense Management",
          style: TextStyle(color: Colors.white),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: showAddExpenseDialog,
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<List<Expense>>(
        stream: expenseService.getExpenses(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final expenses = snapshot.data!;

          if (expenses.isEmpty) {
            return const Center(
              child: Text(
                "No Expense Added Yet",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.money, color: Colors.white),
                  ),

                  title: Text(expense.expenseName),

                  subtitle: Text(
                    "Category: ${expense.category}\n"
                    "Amount: Rs ${expense.amount}\n"
                    "Date: ${expense.expenseDate}",
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          showEditExpenseDialog(expense);
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await expenseService.deleteExpense(expense.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
