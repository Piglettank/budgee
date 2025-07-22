import 'package:budgee/barrel.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;
  final VoidCallback onTap;
  const ExpenseItem(this.expense, {required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(Icons.arrow_forward, size: 16, color: Colors.redAccent),
          Expanded(child: Text(expense.name)),
          Text('${expense.amount.round().toInt()}'),
        ],
      ),
    );
  }
}
