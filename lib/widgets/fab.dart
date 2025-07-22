import 'package:budgee/barrel.dart';

class Fab extends StatelessWidget {
  const Fab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BudgetProvider>();
    final state = provider.state;
    final selectedExpense = provider.selectedExpense;
    final selectedIncome = provider.selectedIncome;

    if (state.isNormal || state.isChooseAction) {
      return FloatingActionButton(
        onPressed: () {
          if (state.isChooseAction) {
            context.read<BudgetProvider>().state = AppState.normal;
          }
          if (state.isNormal) {
            context.read<BudgetProvider>().state = AppState.chooseAction;
          }
        },
        child: AnimatedRotation(
          turns: state == AppState.chooseAction ? 0.25 : 0,
          duration: Duration(milliseconds: 200),
          child: Icon(state.isNormal ? Icons.add : Icons.close),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        FloatingActionButton(
          heroTag: 1,
          onPressed: () async {
            if (state.isEnterExpense) {
              await Database.removeExpense(selectedExpense!);
            } else {
              await Database.removeIncome(selectedIncome!);
            }
            if (context.mounted) {
              context.read<BudgetProvider>().selectedExpense = null;
              context.read<BudgetProvider>().selectedIncome = null;
            }
          },
          child: Icon(Icons.delete),
        ),
        FloatingActionButton(
          onPressed: () async {
            if (state.isEnterExpense) {
              await Database.saveExpense(selectedExpense!);
            } else {
              await Database.saveIncome(selectedIncome!);
            }
            if (context.mounted) {
              context.read<BudgetProvider>().selectedExpense = null;
              context.read<BudgetProvider>().selectedIncome = null;
            }
          },
          child: AnimatedRotation(
            turns: state == AppState.chooseAction ? 0.25 : 0,
            duration: Duration(milliseconds: 200),
            child: Icon(Icons.done),
          ),
        ),
      ],
    );
  }
}
