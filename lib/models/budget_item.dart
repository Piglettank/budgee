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
    return BudgetItem(0, '', type);
  }

  bool get isExpense => type.toLowerCase() == BudgetTypes.expense;
  bool get isIncome => type.toLowerCase() == BudgetTypes.income;

  bool get isValid {
    return (amount >= 0 || name.isNotEmpty) && type.isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    return {'amount': amount, 'name': name, 'type': type};
  }

  factory BudgetItem.fromJson(Map<String, dynamic> json) {
    return BudgetItem(json['amount'], json['name'], json['type']);
  }
}

extension BudgetItemListExtensions on List<BudgetItem> {
  List<BudgetItem> expenses() {
    return where((item) => item.isExpense).toList();
  }

  List<BudgetItem> incomes() {
    return where((item) => item.isIncome).toList();
  }

  double totalAmount() {
    final income = incomes().fold(0.0, (val, item) => val += item.amount);
    final expense = expenses().fold(0.0, (val, item) => val += item.amount);

    return income - expense;
  }
}
