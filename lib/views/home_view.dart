import 'package:budgee/barrel.dart';

enum AppState {
  normal,
  chooseAction,
  enterInfo;

  bool get isNormal => this == normal;
  bool get isChooseAction => this == chooseAction;
  bool get isEnterIncome => this == enterInfo;
}

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
    items = Database.getAllItems();
    items.sort((a, b) => b.amount.compareTo(a.amount));

    incomes = items.incomes();
    expenses = items.expenses();

    final provider = context.watch<BudgetProvider>();
    selectedItem = provider.selectedItem;
    state = provider.state;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Budget boi'),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => provider.clearSelection(),
            child: ListView(
              padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
              children: <Widget>[
                ..._overview(),

                SizedBox(height: 20),
                ..._incomes(),

                SizedBox(height: 20),
                ..._expenses(),
              ],
            ),
          ),
          _overlay(),
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
      child: GestureDetector(
        onTap: () {
          context.read<BudgetProvider>().state = AppState.normal;
        },
        child: Center(
          child: AnimatedOpacity(
            opacity: state == AppState.chooseAction ? 1 : 0.1,
            duration: Duration(milliseconds: 200),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(color: Colors.black54),
            ),
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
            context.read<BudgetProvider>().setSelectedItem(item);
            context.read<BudgetProvider>().state = AppState.normal;
          }
        },
      ),
    );
  }

  List<Widget> _overview() {
    return [
      Text('Overview', style: Theme.of(context).textTheme.headlineSmall),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Incomes', style: Theme.of(context).textTheme.bodyLarge),
          Text(
            incomes.totalAmount().roundedString(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Expenses', style: Theme.of(context).textTheme.bodyLarge),
          Text(
            expenses.totalAmount().roundedString(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
      Divider(color: Colors.black12),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Leftover', style: Theme.of(context).textTheme.bodyLarge),
          Text(
            items.totalAmount().roundedString(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    ];
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
      Text('Expenses', style: Theme.of(context).textTheme.headlineSmall),
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
      Text('Incomes', style: Theme.of(context).textTheme.headlineSmall),
      ...incomeItems,
    ];
  }
}
