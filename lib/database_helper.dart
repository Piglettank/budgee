import 'package:budgee/barrel.dart';

class DatabaseHelper {
  static Future<void> updateSelectedItem(BuildContext context) async {
    final provider = context.read<BudgetProvider>();
    final item = provider.selectedItem;

    if (item == null) return;

    if (item.isValid) {
      await Database.saveItem(item);
    } else {
      await Database.removeItem(item);
    }

    if (context.mounted) {
      context.read<BudgetProvider>().clearSelection();
      context.read<BudgetProvider>().updateState();
    }
  }
}
