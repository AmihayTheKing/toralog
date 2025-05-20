// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:zman_limud_demo/widgets/learn_time_card.dart';
import 'package:zman_limud_demo/main.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key, required this.appState});

  final AppState appState;

  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.appState.widget.learnTimes.isEmpty) {
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
      itemBuilder: (context, indx) => Dismissible(
        key: ValueKey(widget.appState.widget.learnTimes[indx]),
        child: LearnTimeCard(
          editFunction: widget.appState.openEditMenu,
          learnTime: widget.appState.widget.learnTimes[indx],
          dateType: widget.appState.dateType,
        ),
        onDismissed: (direction) => widget.appState
            .removeLearnTime(widget.appState.widget.learnTimes[indx]),
      ),
      itemCount: widget.appState.widget.learnTimes.length,
    );
  }
}
