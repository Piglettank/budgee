import 'package:budgee/barrel.dart';

class BudgetProvider extends ChangeNotifier {
  Expense? _selectedExpense;
  Income? _selectedIncome;
  AppState _state = AppState.normal;

  Income? get selectedIncome => _selectedIncome;
  set selectedIncome(Income? income) {
    _selectedIncome = income;
    _selectedExpense = null;
    notifyListeners();
  }

  Expense? get selectedExpense => _selectedExpense;
  set selectedExpense(Expense? expense) {
    _selectedExpense = expense;
    _selectedIncome = null;
    notifyListeners();
  }

  AppState get state {
    if (_selectedExpense != null) {
      return AppState.enterExpense;
    }
    if (_selectedIncome != null) {
      return AppState.enterIncome;
    }

    return _state;
  }

  set state(AppState state) {
    _state = state;
    notifyListeners();
  }
}
