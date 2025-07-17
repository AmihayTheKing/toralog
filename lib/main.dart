import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zman_limud_demo/providers/learn_times_provider.dart';
import 'package:zman_limud_demo/screens/settings_screen.dart';
import 'package:zman_limud_demo/themes/dark_theme.dart';
import 'package:zman_limud_demo/widgets/add_menu.dart';
import 'package:zman_limud_demo/widgets/edit_menu.dart';
import 'package:zman_limud_demo/screens/charts_screen.dart';
import 'package:zman_limud_demo/models/learn_time.dart';
import 'package:zman_limud_demo/screens/cards_screen.dart';
import 'package:zman_limud_demo/themes/light_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then(
    (fn) => runApp(
      ProviderScope(
        child: MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          debugShowCheckedModeBanner: false,
          home: App(),
        ),
      ),
    ),
  );
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => AppState();
}

class AppState extends ConsumerState<App> {
  int _currentScreenIndex = 0;
  late Future loadLearnTimesFuture;

  // Load learn times from database when app starts

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingsScreen(),
      ),
    );
  }

  void openEditMenu(LearnTime learnTime) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => EditMenu(
        learnTime: learnTime,
      ),
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loadLearnTimesFuture =
        ref.read(learnTimesProvider.notifier).loadLearnTimes();
    return Scaffold(
      appBar: AppBar(
        title: const Text('זמן לימוד'),
        centerTitle: true,
        leadingWidth: 100,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          textDirection: TextDirection.rtl,
          children: [
            IconButton(
              icon: Icon(
                Icons.settings_rounded,
                color: Theme.of(context).appBarTheme.iconTheme?.color,
              ),
              onPressed: _openSettings,
            ),
          ],
        ),
      ),
      body: _currentScreenIndex == 0
          ? CardsScreen(appState: this)
          : ChartsScreen(
              appState: this,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<LearnTime>(
            context: context,
            builder: (ctx) => AddMenu(),
            isScrollControlled: true,
            useSafeArea: true,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.table_rows_rounded),
            label: 'כרטיסיות',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'גרפים',
          ),
        ],
        currentIndex: _currentScreenIndex,
        onTap: (index) => setState(() {
          _currentScreenIndex = index;
        }),
      ),
    );
  }
}
