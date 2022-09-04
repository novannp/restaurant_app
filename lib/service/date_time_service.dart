import 'package:intl/intl.dart';

class DateTimeService {
  static DateTime format() {
    final now = DateTime.now();
    final dateFormat = DateFormat('d/M/y');
    const timeSpecific = '11:00:00';
    final completeFormat = DateFormat('d/M/y H:m:s');

    final todayDate = dateFormat.format(now);
    final todayDateAndTime = '$todayDate $timeSpecific';
    var resultToday = completeFormat.parseStrict(todayDateAndTime);

    // Besok
    var formatted = resultToday.add(const Duration(days: 1));
    final tomorrowDate = dateFormat.format(formatted);
    final tomorrowDateAndTime = '$tomorrowDate $timeSpecific';
    var resultTomorrow = completeFormat.parseStrict(tomorrowDateAndTime);

    return now.isAfter(resultToday) ? resultTomorrow : resultToday;
  }
}
