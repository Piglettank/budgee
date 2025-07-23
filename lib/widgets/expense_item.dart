import 'package:budgee/barrel.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;
  const ExpenseItem(this.expense, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        children: [
          Icon(Icons.arrow_forward, size: 16, color: Colors.redAccent),
          Expanded(
            child: InkWell(
              onTap: () {
                context.read<BudgetProvider>().setSelectedExpense(expense);
              },
              child: Text(
                expense.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                context.read<BudgetProvider>().setSelectedExpense(
                  expense,
                  focusCost: true,
                );
              },
              child: Text(
                '${expense.amount.round().toInt()}',
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
