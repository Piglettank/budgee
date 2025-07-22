import 'package:budgee/barrel.dart';

class Database {
  static late SharedPreferences sharedPreferences;

  static const String expenseIndexKey = 'expense_index';
  static const String expenseBaseName = 'expense_name_';
  static const String expenseBaseValue = 'expense_value_';

  static int? get expenseIndex => sharedPreferences.getInt(expenseIndexKey);

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> addExpense(Expense expense) async {
    int index = expenseIndex ?? 0;
    final String nameKey = '$expenseBaseName$index';
    final String valueKey = '$expenseBaseValue$index';

    await sharedPreferences.setString(nameKey, expense.name);
    await sharedPreferences.setDouble(valueKey, expense.amount);

    index++;
    await sharedPreferences.setInt(expenseIndexKey, index);
  }

  static Future<void> removeExpense(Expense expense) async {
    if (expense.index == null) return;

    final index = expense.index;
    final String nameKey = '$expenseBaseName$index';
    final String valueKey = '$expenseBaseValue$index';

    await sharedPreferences.remove(nameKey);
    await sharedPreferences.remove(valueKey);
  }

  static List<Expense> getAllExpenses() {
    if (expenseIndex == null) return [];

    final expenses = <Expense>[];

    for (int i = 0; i < expenseIndex!; i++) {
      final expense = getIndexedExpense(i);
      if (expense != null) {
        expenses.add(expense);
      }
    }

    return expenses;
  }

  static Expense? getIndexedExpense(int index) {
    final String nameKey = '$expenseBaseName$index';
    final String valueKey = '$expenseBaseValue$index';

    final double? amount = sharedPreferences.getDouble(valueKey);
    final String? name = sharedPreferences.getString(nameKey);

    if (amount == null || name == null) return null;

    return Expense(amount, name, index: index);
  }
}
