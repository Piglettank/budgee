class BudgetItem {
  double amount;
  String name;
  int? index;
  String type;
  String? tag;

  BudgetItem(this.amount, this.name, this.type, {this.index, this.tag});

  factory BudgetItem.empty(String type) {
    return BudgetItem(0, '', type, tag: 'wow');
  }

  bool get isExpense => type.toLowerCase() == BudgetTypes.expense;
  bool get isIncome => type.toLowerCase() == BudgetTypes.income;
  bool get unTagged => tag == null || tag!.isEmpty;

  bool get isValid {
    return (amount > 0 || name.isNotEmpty) && type.isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    return {'amount': amount, 'name': name, 'type': type, 'tag': tag};
  }

  factory BudgetItem.fromJson(Map<String, dynamic> json) {
    return BudgetItem(
      json['amount'],
      json['name'],
      json['type'],
      tag: json['tag'],
    );
  }
}

extension BudgetItemListExtensions on List<BudgetItem> {
  List<BudgetItem> expenses() {
    return where((item) => item.isExpense).toList();
  }

  Map<String, List<BudgetItem>> expensesByTag() {
    final map = <String, List<BudgetItem>>{};
    for (final expense in this) {
      final key = expense.tag ?? '';
      map[key] ??= [];
      map[key]!.add(expense);
    }
    return map;
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

abstract class BudgetTypes {
  static const String expense = 'expense';
  static const String income = 'income';
}
