import 'package:budgee/barrel.dart';

class BudgetProvider extends ChangeNotifier {
  Expense? _selectedExpense;
  Income? _selectedIncome;
  AppState _state = AppState.normal;
  bool focusCost = false;

  final nameFocus = FocusNode();
  final amountFocus = FocusNode();

  BudgetProvider() {
    _init();
  }

  void _init() {
    nameFocus.addListener(() {
      if (nameFocus.hasFocus) {
        notifyListeners();
      }
    });
    amountFocus.addListener(() {
      if (amountFocus.hasFocus) {
        notifyListeners();
      }
    });
  }

  Income? get selectedIncome => _selectedIncome;
  void setSelectedIncome(Income? income, {bool focusCost = false}) {
    _selectedIncome = income;
    _selectedExpense = null;
    this.focusCost = focusCost;
    notifyListeners();
  }

  Expense? get selectedExpense => _selectedExpense;
  void setSelectedExpense(Expense? expense, {bool focusCost = false}) {
    _selectedExpense = expense;
    _selectedIncome = null;
    this.focusCost = focusCost;
    notifyListeners();
  }

  void clearSelection() {
    _selectedExpense = null;
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
