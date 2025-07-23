import 'package:budgee/barrel.dart';

class IncomeItem extends StatelessWidget {
  final Income income;
  const IncomeItem(this.income, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<BudgetProvider>().setSelectedIncome(income);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0),
        child: Row(
          children: [
            Icon(Icons.arrow_back, size: 16, color: Colors.green),
            Expanded(
              child: Text(
                income.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Text(
              '${income.amount.round().toInt()}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
