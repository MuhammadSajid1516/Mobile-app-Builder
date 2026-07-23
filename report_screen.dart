import 'package:flutter/material.dart';

import '../services/firebase_service.dart';
import '../services/expense_service.dart';
import '../services/sales_service.dart';

import '../models/pond_model.dart';
import '../models/expense_model.dart';
import '../models/sales_model.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final FirebaseService firebaseService = FirebaseService();
  final ExpenseService expenseService = ExpenseService();
  final SalesService salesService = SalesService();

  void generateReport(
    BuildContext context,
    int ponds,
    int fish,
    double totalExpense,
    double totalSales,
    double netProfit,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Fish Farm Report"),
        content: Text(
          "Total Ponds: $ponds\n\n"
          "Total Fish: $fish\n\n"
          "Total Expenses: Rs ${totalExpense.toStringAsFixed(0)}\n\n"
          "Total Sales: Rs ${totalSales.toStringAsFixed(0)}\n\n"
          "${netProfit >= 0 ? "Net Profit" : "Net Loss"}: Rs ${netProfit.abs().toStringAsFixed(0)}",
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FC),
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Reports", style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<List<Pond>>(
        stream: firebaseService.getPonds(),
        builder: (context, pondSnapshot) {
          final ponds = pondSnapshot.data ?? [];

          int totalFish = 0;

          for (var pond in ponds) {
            totalFish += int.tryParse(pond.fishQuantity) ?? 0;
          }

          return StreamBuilder<List<Expense>>(
            stream: expenseService.getExpenses(),
            builder: (context, expenseSnapshot) {
              final expenses = expenseSnapshot.data ?? [];

              double totalExpense = 0;

              for (var expense in expenses) {
                totalExpense += double.tryParse(expense.amount) ?? 0;
              }

              return StreamBuilder<List<Sale>>(
                stream: salesService.getSales(),
                builder: (context, salesSnapshot) {
                  final sales = salesSnapshot.data ?? [];

                  double totalSales = 0;

                  for (var sale in sales) {
                    totalSales += double.tryParse(sale.price) ?? 0;
                  }

                  double netProfit = totalSales - totalExpense;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Column(
                            children: [
                              Icon(
                                Icons.bar_chart,
                                color: Colors.white,
                                size: 60,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Fish Farm Report",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.water,
                              color: Colors.blue,
                            ),
                            title: const Text("Total Ponds"),
                            trailing: Text(ponds.length.toString()),
                          ),
                        ),

                        Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.set_meal,
                              color: Colors.green,
                            ),
                            title: const Text("Total Fish"),
                            trailing: Text(totalFish.toString()),
                          ),
                        ),

                        Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.money_off,
                              color: Colors.red,
                            ),
                            title: const Text("Total Expenses"),
                            trailing: Text(
                              "Rs ${totalExpense.toStringAsFixed(0)}",
                            ),
                          ),
                        ),

                        Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.shopping_cart,
                              color: Colors.purple,
                            ),
                            title: const Text("Total Sales"),
                            trailing: Text(
                              "Rs ${totalSales.toStringAsFixed(0)}",
                            ),
                          ),
                        ),

                        Card(
                          color: netProfit >= 0
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          child: ListTile(
                            leading: Icon(
                              netProfit >= 0
                                  ? Icons.trending_up
                                  : Icons.trending_down,
                              color: netProfit >= 0 ? Colors.green : Colors.red,
                            ),
                            title: Text(
                              netProfit >= 0 ? "Net Profit" : "Net Loss",
                            ),
                            trailing: Text(
                              "Rs ${netProfit.abs().toStringAsFixed(0)}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: netProfit >= 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.picture_as_pdf),
                            label: const Text("Generate Report"),
                            onPressed: () {
                              generateReport(
                                context,
                                ponds.length,
                                totalFish,
                                totalExpense,
                                totalSales,
                                netProfit,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
