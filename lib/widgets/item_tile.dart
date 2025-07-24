import 'package:budgee/barrel.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemTile extends StatelessWidget {
  final BudgetItem item;
  const ItemTile(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          if (item.isIncome)
            Icon(Icons.arrow_back, size: 20, color: App.gentleGreen)
          else
            Icon(Icons.arrow_forward, size: 20, color: App.gentleRed),
          SizedBox(width: 2),
          Expanded(
            child: InkWell(
              onTap: () {
                context.read<BudgetProvider>().setSelectedItem(item);
              },
              child: Text(
                item.name,
                style: GoogleFonts.shantellSans(fontSize: 16),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                context.read<BudgetProvider>().setSelectedItem(
                  item,
                  focusCost: true,
                );
              },
              child: Text(
                '${item.amount.round().toInt()}',
                textAlign: TextAlign.end,
                style: GoogleFonts.robotoMono(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
