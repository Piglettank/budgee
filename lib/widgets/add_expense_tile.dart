import 'package:budgee/barrel.dart';

class AddExpenseTile extends StatefulWidget {
  const AddExpenseTile({super.key});

  @override
  State<AddExpenseTile> createState() => _AddExpenseTileState();
}

class _AddExpenseTileState extends State<AddExpenseTile> {
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  late FocusNode nameFocus;
  late FocusNode amountFocus;

  @override
  void initState() {
    super.initState();
    final provider = context.read<BudgetProvider>();
    final expense = provider.selectedExpense;
    nameFocus = provider.nameFocus;
    amountFocus = provider.amountFocus;
    nameController.text = expense!.name;
    if (expense.amount > 0) {
      amountController.text = expense.amount.round().toInt().toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final focusCost = context.watch<BudgetProvider>().focusCost;

    return Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      padding: EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: nameController,
              autofocus: !focusCost,
              focusNode: nameFocus,
              onChanged: (value) {
                context.read<BudgetProvider>().selectedExpense!.name = value;
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(hintText: 'Name'),
            ),
          ),
          Expanded(
            child: TextField(
              controller: amountController,
              textAlign: TextAlign.end,
              focusNode: amountFocus,
              autofocus: focusCost,
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
                  context.read<BudgetProvider>().clearSelection();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
