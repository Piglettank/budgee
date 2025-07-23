import 'package:budgee/barrel.dart';

class EnterInfoTile extends StatefulWidget {
  const EnterInfoTile({super.key});

  @override
  State<EnterInfoTile> createState() => _EnterInfoTileState();
}

class _EnterInfoTileState extends State<EnterInfoTile> {
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  late FocusNode nameFocus;
  late FocusNode amountFocus;

  @override
  void initState() {
    super.initState();
    final provider = context.read<BudgetProvider>();
    final item = provider.selectedItem;
    nameFocus = provider.nameFocus;
    amountFocus = provider.amountFocus;
    nameController.text = item!.name;
    if (item.amount > 0) {
      amountController.text = item.amount.round().toInt().toString();
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
                context.read<BudgetProvider>().selectedItem!.name = value;
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
                context.read<BudgetProvider>().selectedItem!.amount = amount;
              },
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Cost'),
              onSubmitted: (_) async {
                await Database.saveItem(
                  context.read<BudgetProvider>().selectedItem!,
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
