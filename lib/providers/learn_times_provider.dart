import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/learn_times_data_base.dart';
import '../models/learn_time.dart';

class LearnTimesNotifier extends StateNotifier<List<LearnTime>> {
  LearnTimesNotifier() : super([]);

  Future<void> loadLearnTimes() async {
    state = await LearnTimeDatabase().readAllLearnTimes();
  }

  void _sortLearnTimes() {
    state = List.of(state)
      ..sort(
        (a, b) => b.date.compareTo(a.date),
      );
  }

  Future<void> addLearnTime(LearnTime learnTime) async {
    await LearnTimeDatabase().create(learnTime);
    state = List.of(state)..add(learnTime);
    _sortLearnTimes();
  }

  Future<void> removeLearnTime(LearnTime learnTime) async {
    await LearnTimeDatabase().delete(learnTime);
    state = List.of(state)..remove(learnTime);
    _sortLearnTimes();
  }

  Future<void> updateLearnTime(LearnTime learnTime) async {
    await LearnTimeDatabase().update(learnTime);
    state = List.of(state)
      ..removeWhere((item) => item.id == learnTime.id)
      ..add(learnTime);
    _sortLearnTimes();
  }

  void clearLearnTimes() {
    state = [];
    try {
      LearnTimeDatabase().resetDatabase();
    } catch (e) {
      if (kDebugMode) {
        print("Error clearing learn times: $e");
      }
    }
  }
}

final learnTimesProvider =
    StateNotifierProvider<LearnTimesNotifier, List<LearnTime>>(
  (ref) => LearnTimesNotifier(),
);
