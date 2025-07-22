import 'package:budgee/barrel.dart';

class Database {
  static late SharedPreferences sharedPreferences;

  static const String expenseIndexKey = 'expense_index';
  static const String expenseBaseName = 'expense_name_';
  static const String expenseBaseValue = 'expense_value_';

  static const String incomeIndexKey = 'income_index';
  static const String incomeBaseName = 'income_name_';
  static const String incomeBaseValue = 'income_value_';

  static int? get expenseIndex => sharedPreferences.getInt(expenseIndexKey);
  static int? get incomeIndex => sharedPreferences.getInt(incomeIndexKey);

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

  static Future<void> addIncome(Income income) async {
    int index = incomeIndex ?? 0;
    final String nameKey = '$incomeBaseName$index';
    final String valueKey = '$incomeBaseValue$index';

    await sharedPreferences.setString(nameKey, income.name);
    await sharedPreferences.setDouble(valueKey, income.amount);

    index++;
    await sharedPreferences.setInt(incomeIndexKey, index);
  }

  static Future<void> removeExpense(Expense expense) async {
    if (expense.index == null) return;

    final index = expense.index;
    final String nameKey = '$expenseBaseName$index';
    final String valueKey = '$expenseBaseValue$index';

    await sharedPreferences.remove(nameKey);
    await sharedPreferences.remove(valueKey);
  }

  static Future<void> removeIncome(Income income) async {
    if (income.index == null) return;

    final index = income.index;
    final String nameKey = '$incomeBaseName$index';
    final String valueKey = '$incomeBaseValue$index';

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

  static List<Income> getAllIncomes() {
    if (incomeIndex == null) return [];

    final incomes = <Income>[];

    for (int i = 0; i < expenseIndex!; i++) {
      final income = getIndexedIncome(i);
      if (income != null) {
        incomes.add(income);
      }
    }

    return incomes;
  }

  static Expense? getIndexedExpense(int index) {
    final String nameKey = '$expenseBaseName$index';
    final String valueKey = '$expenseBaseValue$index';

    final double? amount = sharedPreferences.getDouble(valueKey);
    final String? name = sharedPreferences.getString(nameKey);

    if (amount == null || name == null) return null;

    return Expense(amount, name, index: index);
  }

  static Income? getIndexedIncome(int index) {
    final String nameKey = '$incomeBaseName$index';
    final String valueKey = '$incomeBaseValue$index';

    final double? amount = sharedPreferences.getDouble(valueKey);
    final String? name = sharedPreferences.getString(nameKey);

    if (amount == null || name == null) return null;

    return Income(amount, name, index: index);
  }
}
