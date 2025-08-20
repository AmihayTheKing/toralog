import 'package:zman_limud_demo/models/learn_time.dart';
import 'package:zman_limud_demo/util/general_util.dart';

class LearnTimesBucket<T> {
  LearnTimesBucket({
    required this.whatIsCounted,
  });

  LearnTimesBucket.fromList(
      {required List<LearnTime> allLearnTimes,
      required this.whatIsCounted,
      required bool Function(LearnTime) filter})
      : learnTimes = allLearnTimes.where(filter).toList();

  final T whatIsCounted;
  List<LearnTime> learnTimes = [];

  double get amount {
    double sum = 0;

    for (var learnTime in learnTimes) {
      sum += learnTime.hours;
    }
    return sum;
  }

  String get formattedAmount => amount == 0
      ? 'אפס, כמוך'
      : amount < 1
          ? '${doublesFormat.format((amount * 60) % 60)} דקות'
          : amount.toInt() == amount
              ? '${doublesFormat.format(amount.floor())} שעות'
              : '${doublesFormat.format(amount.floor())} שעות ו ${doublesFormat.format((amount * 60) % 60)} דקות';

  void addLearnTime(LearnTime learnTime) {
    learnTimes.add(learnTime);
  }

  void removeLearnTime(LearnTime learnTime) {
    learnTimes.remove(learnTime);
  }

  void updateLearnTime(LearnTime newLearnTime) {
    for (var learnTime in learnTimes) {
      if (learnTime.id == newLearnTime.id) {
        learnTimes[learnTimes.indexOf(learnTime)] = newLearnTime;
      }
    }
  }
}
