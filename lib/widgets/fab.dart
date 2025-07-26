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

    final nameFocused = provider.nameFocus.hasFocus;

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
              context.read<BudgetProvider>().updateState();
            }
          },
          child: Icon(Icons.delete),
        ),

        FloatingActionButton(
          heroTag: 2,
          onPressed: () async {
            final String? tag = await showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    String? tag;

                    return Dialog(
                      child: TextField(
                        autofocus: true,
                        onChanged: (value) {
                          if (value.isEmpty) tag = null;
                          tag = value;
                        },
                      ),
                    );
                  },
                );
              },
            );

            if (tag != null) {
              selectedItem!.tag = tag;
            }
            if (context.mounted) {
              context.read<BudgetProvider>().clearSelection();
              context.read<BudgetProvider>().updateState();
            }
          },
          child: Icon(Icons.sell),
        ),

        FloatingActionButton(
          onPressed: () async {
            if (nameFocused) {
              provider.amountFocus.requestFocus();
              return;
            }

            DatabaseHelper.updateSelectedItem(context);
          },
          child: Icon(nameFocused ? Icons.arrow_forward : Icons.done),
        ),
      ],
    );
  }
}
