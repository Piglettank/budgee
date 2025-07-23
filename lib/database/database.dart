import 'package:budgee/barrel.dart';

class Database {
  static late SharedPreferences sharedPreferences;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static const String itemIndexKey = 'budget_item_index';
  static int get nextItemIndex => sharedPreferences.getInt(itemIndexKey) ?? 0;

  static String nameKey(int index) => 'budget_item_${index}_name';
  static String amountKey(int index) => 'budget_item_${index}_amount';
  static String typeKey(int index) => 'budget_item_${index}_type';

  static Future<BudgetItem> addEmptyItem({String? type}) async {
    int index = nextItemIndex;
    final item = BudgetItem.empty(type ?? BudgetTypes.expense);
    item.index = index;

    await saveItem(item);

    await sharedPreferences.setInt(itemIndexKey, index + 1);
    return item;
  }

  static Future<void> saveItem(BudgetItem item) async {
    if (item.index == null) return;
    int index = item.index!;

    await sharedPreferences.setString(nameKey(index), item.name);
    await sharedPreferences.setDouble(amountKey(index), item.amount);
    await sharedPreferences.setString(typeKey(index), item.type);
  }

  static Future<void> removeItem(BudgetItem item) async {
    if (item.index == null) return;

    final index = item.index!;

    await sharedPreferences.remove(nameKey(index));
    await sharedPreferences.remove(amountKey(index));
    await sharedPreferences.remove(typeKey(index));
  }

  static List<BudgetItem> getAllItems() {
    final items = <BudgetItem>[];

    for (int i = 0; i < nextItemIndex; i++) {
      final item = getIndexedItem(i);
      if (item != null) {
        items.add(item);
      }
    }

    return items;
  }

  static BudgetItem? getIndexedItem(int index) {
    final double? amount = sharedPreferences.getDouble(amountKey(index));
    final String? name = sharedPreferences.getString(nameKey(index));
    final String? type = sharedPreferences.getString(typeKey(index));

    if (amount == null || name == null || type == null) return null;

    return BudgetItem(amount, name, type, index: index);
  }
}
