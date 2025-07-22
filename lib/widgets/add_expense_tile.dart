import 'package:budgee/barrel.dart';

class AddExpenseTile extends StatefulWidget {
  const AddExpenseTile({super.key});

  @override
  State<AddExpenseTile> createState() => _AddExpenseTileState();
}

class _AddExpenseTileState extends State<AddExpenseTile> {
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final expense = context.read<BudgetProvider>().selectedExpense;
    nameController.text = expense!.name;
    if (expense.amount > 0) {
      amountController.text = expense.amount.round().toInt().toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      padding: EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: nameController,
              autofocus: true,
              onChanged: (value) {
                context.read<BudgetProvider>().selectedExpense!.name = value;
              },
              style: Theme.of(context).textTheme.bodyMedium,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(hintText: 'Name'),
            ),
          ),
          Expanded(
            child: TextField(
              controller: amountController,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.end,
              onChanged: (value) {
                final amount = double.tryParse(value) ?? 0;
                context.read<BudgetProvider>().selectedExpense!.amount = amount;
              },
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Cost'),
              onSubmitted: (_) async {
                await Database.saveExpense(
                  context.read<BudgetProvider>().selectedExpense!,
                );
                if (context.mounted) {
                  context.read<BudgetProvider>().selectedExpense = null;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
