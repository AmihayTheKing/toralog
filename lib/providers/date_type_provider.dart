import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DateType { jewish, gregorian }

const String dateTypeKey = 'dateType';

class DateTypeNotifier extends StateNotifier<DateType> {
  DateTypeNotifier() : super(DateType.jewish) {
    _getDateTypeFromMemory();
  }

  void _getDateTypeFromMemory() {
    SharedPreferences.getInstance().then(
      (value) {
        if (value.getString(dateTypeKey) == null) {
          state = DateType.jewish;
        } else {
          state = DateType.values.firstWhere(
            (element) => element.name == value.getString(dateTypeKey),
          );
        }
      },
    );
  }

  void _setDateTypeToMemory(DateType type) {
    SharedPreferences.getInstance()
        .then((value) => value.setString(dateTypeKey, type.name));
  }

  void setDateType(DateType type) {
    state = type;
    _setDateTypeToMemory(state);
  }

  void toggle() {
    state = state == DateType.gregorian ? DateType.jewish : DateType.gregorian;
    _setDateTypeToMemory(state);
  }
}

final dateTypeProvider = StateNotifierProvider<DateTypeNotifier, DateType>(
  (_) => DateTypeNotifier(),
);
