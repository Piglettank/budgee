import 'package:budgee/barrel.dart';

class Fab extends StatelessWidget {
  const Fab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BudgetProvider>();
    final state = provider.state;
    final selectedItem = provider.selectedItem;

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

    final amountFocused = provider.amountFocus.hasFocus;

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        FloatingActionButton(
          heroTag: 1,
          onPressed: () async {
            await Database.removeItem(selectedItem!);
            if (context.mounted) {
              context.read<BudgetProvider>().clearSelection();
            }
          },
          child: Icon(Icons.delete),
        ),
        FloatingActionButton(
          onPressed: () async {
            if (!amountFocused) {
              provider.amountFocus.requestFocus();
              return;
            } else {
              await Database.saveItem(selectedItem!);
              if (context.mounted) {
                context.read<BudgetProvider>().clearSelection();
              }
            }
          },
          child: Icon(!amountFocused ? Icons.arrow_forward : Icons.done),
        ),
      ],
    );
  }
}
