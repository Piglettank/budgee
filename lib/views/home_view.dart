import 'package:budgee/barrel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _chooseActionMode = false;

  @override
  Widget build(BuildContext context) {
    final expenses = Database.getAllExpenses();
    expenses.sort((a, b) => b.amount.compareTo(a.amount));

    final incomes = Database.getAllIncomes();
    incomes.sort((a, b) => b.amount.compareTo(a.amount));

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

              SizedBox(height: 20),
              Text('Expenses', style: Theme.of(context).textTheme.labelLarge),
              for (final expense in expenses)
                ExpenseItem(expense, onTap: () => _removeExpense(expense)),
            ],
          ),
          _overlay(),
        ],
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        children: [
          _addIncomeButton(),
          _addExpenseButton(),
          FloatingActionButton(
            onPressed: _toggleMode,
            tooltip: 'Increment',
            child: AnimatedRotation(
              turns: _chooseActionMode ? 0.25 : 0,
              duration: Duration(milliseconds: 200),
              child: _chooseActionMode
                  ? const Icon(Icons.close)
                  : const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleMode() async {
    setState(() {
      _chooseActionMode = !_chooseActionMode;
    });
  }

  Future<void> _removeExpense(Expense expense) async {
    await Database.removeExpense(expense);
    if (context.mounted) {
      setState(() {});
    }
  }

  Widget _overlay() {
    return Visibility(
      visible: _chooseActionMode,
      maintainState: true,
      maintainAnimation: true,
      child: GestureDetector(
        onTap: () => setState(() => _chooseActionMode = false),
        child: Center(
          child: AnimatedOpacity(
            opacity: _chooseActionMode ? 1 : 0.1,
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
      visible: _chooseActionMode,
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
          await AddExpenseView.show(context);
          setState(() {
            _chooseActionMode = false;
          });
        },
      ),
    );
  }

  Widget _addIncomeButton() {
    return Visibility(
      visible: _chooseActionMode,
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
          await AddExpenseView.show(context);
          setState(() {
            _chooseActionMode = false;
          });
        },
      ),
    );
  }
}
