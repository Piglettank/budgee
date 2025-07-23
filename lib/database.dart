import 'package:budgee/barrel.dart';

class Database {
  static late SharedPreferences sharedPreferences;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static const String itemIndexKey = 'budget_item_index';
  static int get nextItemIndex => sharedPreferences.getInt(itemIndexKey) ?? 0;

  static String itemStorageKey(int index) => 'budget_item_$index';

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
    String encodedItem = jsonEncode(item.toJson());

    await sharedPreferences.setString(itemStorageKey(index), encodedItem);
  }

  static Future<void> removeItem(BudgetItem item) async {
    if (item.index == null) return;

    final index = item.index!;

    await sharedPreferences.remove(itemStorageKey(index));
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
    final String? storedJson = sharedPreferences.getString(
      itemStorageKey(index),
    );
    if (storedJson == null) return null;

    final decodedItem = jsonDecode(storedJson) as Map<String, dynamic>;
    final item = BudgetItem.fromJson(decodedItem);
    item.index = index;
    return item;
  }
}
