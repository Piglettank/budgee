class Income {
  double amount;
  String name;
  int? index;

  Income(this.amount, this.name, {this.index});
}

extension IncomeListExtensions on List<Income> {
  double totalAmount() => fold(0, (val, expense) => val += expense.amount);
}
