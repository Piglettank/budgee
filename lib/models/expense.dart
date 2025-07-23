class Expense {
  double amount;
  String name;
  int? index;

  Expense(this.amount, this.name, {this.index});
}

extension ExpenseListExtensions on List<Expense> {
  double totalAmount() => fold(0, (val, expense) => val += expense.amount);
}

abstract class BudgetTypes {
  static const String expense = 'expense';
  static const String income = 'income';
}

class BudgetItem {
  double amount;
  String name;
  int? index;
  String type;

  BudgetItem(this.amount, this.name, this.type, {this.index});

  factory BudgetItem.empty(String type) {
    return BudgetItem(0, 'name', type);
  }

  bool get isExpense => type.toLowerCase() == BudgetTypes.expense;
  bool get isIncome => type.toLowerCase() == BudgetTypes.income;

  bool get isValid {
    return (amount >= 0 || name.isNotEmpty) && type.isNotEmpty;
  }
}
