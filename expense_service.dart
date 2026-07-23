import 'package:firebase_database/firebase_database.dart';
import '../models/expense_model.dart';

class ExpenseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref().child(
    "expenses",
  );

  Future<void> addExpense(Expense expense) async {
    await _db.child(expense.id).set(expense.toMap());
  }

  Future<void> deleteExpense(String id) async {
    await _db.child(id).remove();
  }

  Future<void> updateExpense(Expense expense) async {
    await _db.child(expense.id).update(expense.toMap());
  }

  Stream<List<Expense>> getExpenses() {
    return _db.onValue.map((event) {
      final data = event.snapshot.value;

      if (data == null) {
        return <Expense>[];
      }

      final Map<dynamic, dynamic> expenseMap = Map<dynamic, dynamic>.from(
        data as Map,
      );

      return expenseMap.entries.map((entry) {
        return Expense.fromMap(Map<dynamic, dynamic>.from(entry.value));
      }).toList();
    });
  }
}
