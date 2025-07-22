import 'package:budgee/barrel.dart';

class AddExpenseView extends StatefulWidget {
  const AddExpenseView({super.key});

  static const routeName = '/addExpense';
  static void go(BuildContext context) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  State<AddExpenseView> createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<AddExpenseView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ListView(children: [TextField(autofocus: true)]));
  }
}
