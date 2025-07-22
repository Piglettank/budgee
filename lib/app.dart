import 'barrel.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadApp(context),
      builder: (context, asyncSnapshot) {
        if (!asyncSnapshot.hasData) {
          // loading screen
          return const Center(child: CircularProgressIndicator());
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          restorationScopeId: 'app',

          // Theme
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),

          // Routing
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<dynamic>(
              settings: routeSettings,
              builder: (BuildContext context) {
                final name = routeSettings.name?.split('?').first;
                switch (name) {
                  case AddExpenseView.routeName:
                    return const AddExpenseView();
                  default:
                    return const HomeView();
                }
              },
            );
          },
        );
      },
    );
  }

  Future<bool> loadApp(BuildContext context) async {
    final futures = [Database.init()];

    await Future.wait(futures);

    return true;
  }
}
