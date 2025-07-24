import 'package:budgee/barrel.dart';
import 'package:google_fonts/google_fonts.dart';

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

    setState(() {
      state = AppState.chooseAction;
    });

    final provider = context.watch<BudgetProvider>();
    selectedItem = provider.selectedItem;
    state = provider.state;

    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => provider.clearSelection(),
            child: ListView(
              children: <Widget>[
                _header(),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      ..._incomes(),

                      SizedBox(height: 20),
                      ..._expenses(),
                    ],
                  ),
                ),
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

  Widget _header() {
    return Container(
      // decoration: BoxDecoration(
      //   color: Theme.of(context).colorScheme.surfaceContainerLow,
      // ),
      padding: EdgeInsets.fromLTRB(12, 36, 12, 0),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Budget Boy',
            style: GoogleFonts.dynaPuff(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(height: 8),

          _faintBox(
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              children: [
                // Stack(
                //   children: [
                //     Container(
                //       width: double.infinity,
                //       height: 28,
                //       decoration: BoxDecoration(
                //         color: const Color.fromARGB(255, 115, 159, 86),

                //         borderRadius: BorderRadius.circular(100),
                //       ),
                //     ),
                //     Positioned.fill(
                //       child: FractionallySizedBox(
                //         widthFactor: 0.12,
                //         heightFactor: 1,
                //         alignment: Alignment.centerRight,
                //         child: Container(
                //           decoration: BoxDecoration(
                //             color: const Color.fromARGB(255, 199, 126, 73),
                //             borderRadius: BorderRadius.horizontal(
                //               right: Radius.circular(100),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

                // // easy variant
                // LinearProgressIndicator(
                //   backgroundColor: Colors.blue,
                //   color: Colors.green,
                //   value: 0.6,
                //   borderRadius: BorderRadius.circular(100),
                //   minHeight: 16,
                //   trackGap: 20,
                // ),
                // SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Incomes',
                      style: GoogleFonts.shantellSans(
                        fontSize: 18,
                        color: App.gentleGreen,
                      ),
                    ),
                    Text(
                      incomes.totalAmount().roundedString(),
                      style: GoogleFonts.robotoMono(fontSize: 16),
                    ),
                  ],
                ),

                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Expenses',
                      style: GoogleFonts.shantellSans(
                        fontSize: 18,
                        color: App.gentleRed,
                      ),
                    ),
                    Text(
                      expenses.totalAmount().roundedString(),
                      style: GoogleFonts.robotoMono(fontSize: 16),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 120,
                    child: Divider(color: Colors.black12),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Leftover',
                      style: GoogleFonts.shantellSans(fontSize: 16),
                    ),
                    Text(
                      items.totalAmount().roundedString(),
                      style: GoogleFonts.robotoMono(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _faintBox({required Color color, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),

      child: child,
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
}
