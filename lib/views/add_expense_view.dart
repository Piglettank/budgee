import 'package:budgee/barrel.dart';

class AddExpenseView extends StatefulWidget {
  const AddExpenseView({super.key});

  static const routeName = '/addExpense';
  static Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.symmetric(horizontal: 0),
        child: AddExpenseView(),
      ),
    );
  }

  @override
  State<AddExpenseView> createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<AddExpenseView> {
  late PageController pageController;
  final costFocus = FocusNode();
  String name = '';
  double amount = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,

      children: [
        page(
          children: [
            Text('Name of expense'),
            TextField(
              autofocus: true,
              textInputAction: TextInputAction.next,
              onChanged: (value) => name = value,
              onSubmitted: (_) => nextPage(),
            ),
            SizedBox(height: 20),
            FilledButton(
              onPressed: nextPage,
              style: Theme.of(context).filledButtonTheme.style,
              child: Text('Next'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        ),
        page(
          children: [
            Text('Cost of expense'),
            TextField(
              keyboardType: TextInputType.number,
              focusNode: costFocus,
              onChanged: (value) => amount = double.tryParse(value) ?? 0,
              onSubmitted: (_) => complete(),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: complete, child: Text('Done')),
          ],
        ),
      ],
    );
  }

  Widget page({required List<Widget> children}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(48, 48, 48, 24),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  void nextPage() async {
    await pageController.nextPage(
      duration: Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
    costFocus.requestFocus();
  }

  Future<void> complete() async {
    await Database.addExpense(Expense(amount, name));
    await Database.addIncome(Income(amount, name));
    if (mounted) {
      Navigator.pop(context);
    }
  }
}
