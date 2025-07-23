import 'barrel.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BudgetProvider()),
      ],
      child: FutureBuilder(
        future: loadApp(context),
        builder: (context, asyncSnapshot) {
          if (!asyncSnapshot.hasData) {
            // loading screen
            return const Center(child: CircularProgressIndicator());
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            restorationScopeId: 'app',
            theme: theme(),

            // Routing
            onGenerateRoute: (RouteSettings routeSettings) {
              return MaterialPageRoute<dynamic>(
                settings: routeSettings,
                builder: (BuildContext context) {
                  final name = routeSettings.name?.split('?').first;
                  switch (name) {
                    default:
                      return const HomeView();
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<bool> loadApp(BuildContext context) async {
    final futures = [Database.init()];

    await Future.wait(futures);

    return true;
  }

  ThemeData theme() {
    final baseTheme = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
    );

    return baseTheme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: baseTheme.textTheme.bodyMedium!.copyWith(
          color: Colors.black38,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: baseTheme.primaryColor),
        ),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        border: InputBorder.none,
      ),
    );
  }
}
