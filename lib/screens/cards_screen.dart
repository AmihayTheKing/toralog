import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zman_limud_demo/providers/learn_times_provider.dart';
import 'package:zman_limud_demo/widgets/learn_time_card.dart';
import 'package:zman_limud_demo/main.dart';

class CardsScreen extends ConsumerWidget {
  const CardsScreen({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: appState.loadLearnTimesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final learnTimes = ref.watch(learnTimesProvider);
        if (learnTimes.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'עדיין לא הוספת זמנים שבם למדת, ניתן להוסיף זמנים חדשים על ידי לחיצה על הכפתור + בפינה הימנית למטה',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.only(bottom: 90, top: 10),
          itemCount: learnTimes.length,
          itemBuilder: (context, index) {
            final learnTime = learnTimes[index];
            return Dismissible(
              key: ValueKey(learnTime.id),
              child: LearnTimeCard(
                editButtonFunction: appState.openEditMenu,
                learnTime: learnTime,
              ),
              onDismissed: (direction) {
                ref
                    .read(learnTimesProvider.notifier)
                    .removeLearnTime(learnTime);
              },
            );
          },
        );
      },
    );
  }
}
