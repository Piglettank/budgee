import 'package:budgee/barrel.dart';

class AddIncomeTile extends StatefulWidget {
  const AddIncomeTile({super.key});

  @override
  State<AddIncomeTile> createState() => _AddIncomeTileState();
}

class _AddIncomeTileState extends State<AddIncomeTile> {
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final income = context.read<BudgetProvider>().selectedIncome;
    nameController.text = income!.name;
    if (income.amount > 0) {
      amountController.text = income.amount.round().toInt().toString();
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
                context.read<BudgetProvider>().selectedIncome!.name = value;
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
                context.read<BudgetProvider>().selectedIncome!.amount = amount;
              },
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Cost'),
              onSubmitted: (_) async {
                await Database.saveIncome(
                  context.read<BudgetProvider>().selectedIncome!,
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
