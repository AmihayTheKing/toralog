import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:zman_limud_demo/data/learn_times.dart';
import 'package:zman_limud_demo/models/learn_times_bucket.dart';
import 'package:zman_limud_demo/themes/dark_theme.dart';
import 'package:zman_limud_demo/util/dummy_data.dart';
import 'package:zman_limud_demo/util/general_util.dart';
import 'package:zman_limud_demo/widgets/add_menu.dart';
import 'package:zman_limud_demo/widgets/edit_menu.dart';
import 'package:zman_limud_demo/widgets/screens/charts_screen.dart';
import 'package:zman_limud_demo/models/learn_time.dart';
import 'package:zman_limud_demo/widgets/screens/cards_screen.dart';
import 'package:zman_limud_demo/themes/light_theme.dart';
import 'package:zman_limud_demo/util/category.dart';

void main() {
  runApp(
    MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      home: App(),
    ),
  );
}

class App extends StatefulWidget {
  App({super.key});

  List<LearnTime> learnTimes = [...dummyLearnTimes];
  Map<Category, LearnTimesBucket> categoryBuckets = Map.fromIterable(
      Category.values,
      value: (category) => LearnTimesBucket(countedThing: category));

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  int _currentScreenIndex = 0;
  DateType dateType = DateType.jewish;

  @override
  void initState() {
    super.initState();
    _loadLearnTimes();
  }

  // Load learn times from database when app starts
  Future<void> _loadLearnTimes() async {
    try {
      final savedLearnTimes = await LearnTimeDatabase().readAllLearnTimes();
      setState(() {
        widget.learnTimes = savedLearnTimes;
        // Rebuild category and date buckets
        widget.categoryBuckets = Map.fromIterable(
          Category.values,
          value: (category) => LearnTimesBucket(countedThing: category),
        );

        for (var element in widget.learnTimes) {
          widget.categoryBuckets[element.category]?.addLearnTime(element);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading learn times: $e');
      }
      // Optionally show an error to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load learn times')),
      );
    }
  }

  void openEditMenu(LearnTime learnTime) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => EditMenu(
        appState: this,
        learnTime: learnTime,
      ),
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
    );
  }

  void removeLearnTime(LearnTime learnTime) async {
    final int index = widget.learnTimes.indexOf(learnTime);

    try {
      // Delete from database
      await LearnTimeDatabase().delete(learnTime);

      setState(() {
        widget.learnTimes.remove(learnTime);
        widget.categoryBuckets[learnTime.category]?.removeLearnTime(learnTime);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 4),
          content: Text('הלימוד ${learnTime.title} נמחק בהצלחה'),
          action: SnackBarAction(
            label: 'ביטול',
            onPressed: () async {
              // Revert deletion by reinserting into database and local state
              await LearnTimeDatabase().create(learnTime);
              setState(
                () {
                  if (index > widget.learnTimes.length) {
                    widget.learnTimes.add(learnTime);
                  } else {
                    widget.learnTimes.insert(index, learnTime);
                  }
                  widget.categoryBuckets[learnTime.category]
                      ?.addLearnTime(learnTime);

                  // Reinsert into date buckets
                },
              );
            },
          ),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error removing learn time: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete learn time')),
      );
    }
  }

  void addLearnTime(LearnTime learnTime) async {
    try {
      await LearnTimeDatabase().create(learnTime);

      setState(() {
        widget.learnTimes.add(learnTime);
        widget.learnTimes.sort((a, b) => b.date.compareTo(a.date));
        widget.categoryBuckets[learnTime.category]?.addLearnTime(learnTime);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error adding learn time: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save learn time')),
      );
    }
  }

  void updateLearnTime(LearnTime learnTime) async {
    try {
      await LearnTimeDatabase().update(learnTime);

      setState(() {
        widget.learnTimes[widget.learnTimes.indexOf(learnTime)] = learnTime;
        widget.categoryBuckets[learnTime.category]?.updateLearnTime(learnTime);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error updating learn time: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update learn time')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: const Text('זמן לימוד'),
        ),
        leadingWidth: 100,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          textDirection: TextDirection.rtl,
          children: [
            InkWell(
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
              onTap: () {
                setState(() {
                  dateType = dateType == DateType.gregorian
                      ? DateType.jewish
                      : DateType.gregorian;
                });
              },
              child: dateType == DateType.gregorian
                  ? Stack(
                      alignment: Alignment.lerp(
                              Alignment.center, Alignment.bottomCenter, 0.5) ??
                          Alignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 30,
                        ),
                        Text(
                          'א',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      alignment: Alignment.lerp(
                              Alignment.center, Alignment.bottomCenter, 0.8) ??
                          Alignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 30,
                        ),
                        Text(
                          '1',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
            ),
            IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).appBarTheme.iconTheme?.color,
              ),
              onPressed: null,
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
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (ctx) => AddMenu(appState: this),
          isScrollControlled: true,
          useSafeArea: true,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
        ),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_day_rounded),
            label: 'זמני לימוד',
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
