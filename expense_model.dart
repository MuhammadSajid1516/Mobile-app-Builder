class Expense {
  String id;
  String expenseName;
  String category;
  String amount;
  String expenseDate;

  Expense({
    required this.id,
    required this.expenseName,
    required this.category,
    required this.amount,
    required this.expenseDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expenseName': expenseName,
      'category': category,
      'amount': amount,
      'expenseDate': expenseDate,
    };
  }

  factory Expense.fromMap(Map<dynamic, dynamic> map) {
    return Expense(
      id: map['id'] ?? '',
      expenseName: map['expenseName'] ?? '',
      category: map['category'] ?? '',
      amount: map['amount'] ?? '',
      expenseDate: map['expenseDate'] ?? '',
    );
  }
}
