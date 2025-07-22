import 'package:budgee/barrel.dart';

enum AppState {
  normal,
  chooseAction,
  enterExpense,
  enterIncome;

  bool get isNormal => this == normal;
  bool get isChooseAction => this == chooseAction;
  bool get isEnterExpense => this == enterExpense;
  bool get isEnterIncome => this == enterIncome;
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Expense> expenses = [];
  List<Income> incomes = [];
  AppState state = AppState.normal;
  Expense? selectedExpense;
  Income? selectedIncome;

  @override
  Widget build(BuildContext context) {
    expenses = Database.getAllExpenses();
    expenses.sort((a, b) => b.amount.compareTo(a.amount));

    incomes = Database.getAllIncomes();
    incomes.sort((a, b) => b.amount.compareTo(a.amount));

    final provider = context.watch<BudgetProvider>();
    selectedExpense = provider.selectedExpense;
    selectedIncome = provider.selectedIncome;
    state = provider.state;

    print(state);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Budget boi'),
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
            children: <Widget>[
              ..._overview(),

              SizedBox(height: 20),
              ..._incomes(),

              SizedBox(height: 20),
              ..._expenses(),
            ],
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
          final expense = await Database.addEmptyExpense();
          if (mounted) {
            context.read<BudgetProvider>().selectedExpense = expense;
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
          final income = await Database.addEmptyIncome();
          if (mounted) {
            context.read<BudgetProvider>().selectedIncome = income;
            context.read<BudgetProvider>().state = AppState.normal;
          }
        },
      ),
    );
  }

  List<Widget> _overview() {
    return [
      Text('Overview', style: Theme.of(context).textTheme.labelLarge),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Incomes'),
          Text(incomes.totalAmount().round().toInt().toString()),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Expenses'),
          Text(expenses.totalAmount().round().toInt().toString()),
        ],
      ),
      Divider(color: Colors.black12),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Leftover'),
          Text(
            (incomes.totalAmount() - expenses.totalAmount())
                .round()
                .toInt()
                .toString(),
          ),
        ],
      ),
    ];
  }

  List<Widget> _expenses() {
    final expenseItems = <Widget>[];
    for (final expense in expenses) {
      final selected = expense.index == selectedExpense?.index;
      if (selected) {
        expenseItems.add(AddExpenseTile());
      } else {
        expenseItems.add(ExpenseItem(expense));
      }
    }

    return [
      Text('Expenses', style: Theme.of(context).textTheme.labelLarge),
      ...expenseItems,
    ];
  }

  List<Widget> _incomes() {
    final incomeItems = <Widget>[];
    for (final income in incomes) {
      final selected = income.index == selectedIncome?.index;
      if (selected) {
        incomeItems.add(AddIncomeTile());
      } else {
        incomeItems.add(IncomeItem(income));
      }
    }

    return [
      Text('Incomes', style: Theme.of(context).textTheme.labelLarge),
      ...incomeItems,
    ];
  }
}
