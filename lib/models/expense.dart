class Expense {
  double amount;
  String name;
  int? index;

  Expense(this.amount, this.name, {this.index});
}

extension ExpenseListExtensions on List<Expense> {
  double totalAmount() => fold(0, (val, expense) => val += expense.amount);
}
