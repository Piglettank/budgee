import 'package:budgee/barrel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<BudgetItem> items = [];
  List<BudgetItem> incomes = [];
  List<BudgetItem> expenses = [];
  BudgetItem? selectedItem;
  AppState state = AppState.normal;

  @override
  Widget build(BuildContext context) {
    items = context.read<BudgetProvider>().items;
    incomes = items.incomes();
    expenses = items.expenses();

    final provider = context.watch<BudgetProvider>();
    selectedItem = provider.selectedItem;
    state = provider.state;

    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              DatabaseHelper.updateSelectedItem(context);
              context.read<BudgetProvider>().state = AppState.normal;
            },
            child: ListView(
              padding: EdgeInsets.fromLTRB(12, 56, 12, 0),
              children: <Widget>[
                Text(
                  'Budget Boy',
                  style: GoogleFonts.dynaPuff(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: 8),
                Summary(),

                SizedBox(height: 20),
                ..._incomes(),

                SizedBox(height: 20),
                ..._expenses(),
              ],
            ),
          ),
          _overlay(),
          _tagList(),
        ],
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        children: [_addIncomeButton(), _addExpenseButton(), Fab()],
      ),
    );
  }

  Widget _overlay() {
    return Visibility(
      visible: state == AppState.chooseAction,
      maintainState: true,
      maintainAnimation: true,
      child: Center(
        child: AnimatedOpacity(
          opacity: state == AppState.chooseAction ? 1 : 0.1,
          duration: Duration(milliseconds: 100),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(color: Colors.black54),
          ),
        ),
      ),
    );
  }

  Widget _addExpenseButton() {
    return Visibility(
      visible: state == AppState.chooseAction,
      child: ElevatedButton(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_forward, color: Colors.redAccent),
              SizedBox(width: 8),
              Text('Add expense'),
            ],
          ),
        ),
        onPressed: () async {
          final item = await Database.addEmptyItem(type: BudgetTypes.expense);
          if (mounted) {
            context.read<BudgetProvider>().updateState();
            context.read<BudgetProvider>().setSelectedItem(item);
            context.read<BudgetProvider>().state = AppState.normal;
          }
        },
      ),
    );
  }

  Widget _addIncomeButton() {
    return Visibility(
      visible: state == AppState.chooseAction,
      child: ElevatedButton(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back, color: Colors.green),
              SizedBox(width: 8),
              Text('Add income'),
            ],
          ),
        ),
        onPressed: () async {
          final item = await Database.addEmptyItem(type: BudgetTypes.income);
          if (mounted) {
            context.read<BudgetProvider>().updateState();
            context.read<BudgetProvider>().setSelectedItem(item);
            context.read<BudgetProvider>().state = AppState.normal;
          }
        },
      ),
    );
  }

  List<Widget> _expenses() {
    final expenseItems = <Widget>[];
    for (final expense in expenses) {
      final selected = expense.index == selectedItem?.index;
      if (selected) {
        expenseItems.add(EnterInfoTile());
      } else {
        expenseItems.add(ItemTile(expense));
      }
    }

    return [
      Text(
        'EXPENSES',
        style: GoogleFonts.dynaPuff(
          fontSize: 18,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      ...expenseItems,
    ];
  }

  List<Widget> _incomes() {
    final incomeItems = <Widget>[];
    for (final income in incomes) {
      final selected = income.index == selectedItem?.index;
      if (selected) {
        incomeItems.add(EnterInfoTile());
      } else {
        incomeItems.add(ItemTile(income));
      }
    }

    return [
      Text(
        'INCOMES',
        style: GoogleFonts.dynaPuff(
          fontSize: 18,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      ...incomeItems,
    ];
  }

  Widget _tagList() {
    final tags = context.read<BudgetProvider>().tags;

    return Positioned(
      bottom: 88,
      right: 80,
      child: Material(
        clipBehavior: Clip.hardEdge,
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: Container(
          constraints: BoxConstraints(maxHeight: 200, maxWidth: 240),
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              for (final tag in tags) Text(tag),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  child: Text(
                    '+ Add tag ',
                    style: GoogleFonts.shantellSans(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
