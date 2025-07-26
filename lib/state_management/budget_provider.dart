import 'package:budgee/barrel.dart';

class BudgetProvider extends ChangeNotifier {
  BudgetItem? _selectedItem;
  AppState _state = AppState.normal;
  bool focusCost = false;

  final nameFocus = FocusNode();
  final amountFocus = FocusNode();

  List<BudgetItem> items = [];
  List<String> tags = [];

  bool showingTagList = true;

  BudgetProvider() {
    _init();
  }

  // TODO(pig): Not the cleanest solution
  void _init() {
    nameFocus.addListener(notifyListeners);
  }

  void updateState() {
    items = Database.getAllItems();
    tags = Database.getAllTags();
    items.sort((a, b) => b.amount.compareTo(a.amount));

    notifyListeners();
  }

  BudgetItem? get selectedItem => _selectedItem;
  void setSelectedItem(BudgetItem? item, {bool focusCost = false}) {
    _selectedItem = item;
    this.focusCost = focusCost;
    notifyListeners();
  }

  void showTagList() {
    showingTagList = true;
    notifyListeners();
  }

  void hideTagList() {
    showingTagList = false;
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
