import 'package:budgee/barrel.dart';

class BudgetProvider extends ChangeNotifier {
  BudgetItem? _selectedItem;
  AppState _state = AppState.normal;
  bool focusCost = false;

  final nameFocus = FocusNode();
  final amountFocus = FocusNode();

  BudgetProvider() {
    _init();
  }

  // TODO(pig): Not the cleanest solution
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

  BudgetItem? get selectedItem => _selectedItem;
  void setSelectedItem(BudgetItem? item, {bool focusCost = false}) {
    _selectedItem = item;
    this.focusCost = focusCost;
    notifyListeners();
  }

  void clearSelection() {
    _selectedItem = null;
    focusCost = false;
    notifyListeners();
  }

  AppState get state {
    if (_selectedItem != null) {
      return AppState.enterInfo;
    }

    return _state;
  }

  set state(AppState state) {
    _state = state;
    notifyListeners();
  }
}
