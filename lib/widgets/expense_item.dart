import 'package:budgee/barrel.dart';

class ItemTile extends StatelessWidget {
  final BudgetItem item;
  const ItemTile(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        children: [
          if (item.isIncome)
            Icon(Icons.arrow_back, size: 16, color: Colors.green)
          else
            Icon(Icons.arrow_forward, size: 16, color: Colors.redAccent),
          Expanded(
            child: InkWell(
              onTap: () {
                context.read<BudgetProvider>().setSelectedItem(item);
              },
              child: Text(
                item.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                context.read<BudgetProvider>().setSelectedItem(
                  item,
                  focusCost: true,
                );
              },
              child: Text(
                '${item.amount.round().toInt()}',
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
