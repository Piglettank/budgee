import 'package:budgee/barrel.dart';

class Summary extends StatelessWidget {
  const Summary({super.key});

  @override
  Widget build(BuildContext context) {
    final BudgetProvider provider = context.watch();
    final items = provider.items;
    final expenses = items.expenses();
    final incomes = items.incomes();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withAlpha(30),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),

          child: Column(
            children: [
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
    );
  }
}
