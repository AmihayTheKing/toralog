import 'package:zman_limud_demo/models/learn_time.dart';

class LearnTimesBucket {
  LearnTimesBucket({
    required this.countedThing,
  });

  LearnTimesBucket.fromList(
      {required List<LearnTime> allLearnTimes,
      required this.countedThing,
      required bool Function(LearnTime) filter})
      : learnTimes = allLearnTimes.where(filter).toList();

  final dynamic countedThing;
  List<LearnTime> learnTimes = [];

  double get amount {
    double sum = 0;

    for (var learnTime in learnTimes) {
      sum += learnTime.hours;
    }
    return sum;
  }

  void addLearnTime(LearnTime learnTime) {
    learnTimes.add(learnTime);
  }

  void removeLearnTime(LearnTime learnTime) {
    learnTimes.remove(learnTime);
  }

  void updateLearnTime(LearnTime newLearnTime) {
    for (var learnTime in learnTimes) {
      if (learnTime.id == newLearnTime.id) {
        learnTime = newLearnTime;
      }
    }
  }
}
