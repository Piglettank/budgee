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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('budgee'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              children: <Widget>[
                for (final expense in expenses)
                  InkWell(
                    onTap: () => _removeExpense(expense),
                    child: Row(
                      children: [Text(expense.name), Text('${expense.amount}')],
                    ),
                  ),
              ],
            ),
          ),
          Visibility(
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
          ),
        ],
      ),
      floatingActionButton: Column(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: _chooseActionMode,
            child: FloatingActionButton(
              heroTag: 1,
              child: Icon(Icons.ad_units),
              onPressed: () {
                setState(() {
                  _chooseActionMode = false;
                  AddExpenseView.go(context);
                });
              },
            ),
          ),
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
}
