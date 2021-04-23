part of 'animate_countdown_text.dart';

///
///@author shaw
///@date 2021/4/12
///@desc format of DateTime
///
class DurationFormat {
  const DurationFormat(
      {this.year,
      this.yearSuffix = "Year",
      this.month,
      this.monthSuffix = "Mon",
      this.day,
      this.daySuffix = "Day",
      this.hour,
      this.hourSuffix = ":",
      this.minute,
      this.minuteSuffix = ":",
      this.second,
      this.secondSuffix});

  final String? year;
  final String? yearSuffix;
  final String? month;
  final String? monthSuffix;
  final String? day;
  final String? daySuffix;
  final String? hour;
  final String? hourSuffix;
  final String? minute;
  final String? minuteSuffix;
  final String? second;
  final String? secondSuffix;

  bool get showYear => this.year?.isNotEmpty ?? false;

  bool get showYearSuffix => this.yearSuffix?.isNotEmpty ?? false;

  bool get showMonth => this.month?.isNotEmpty ?? false;

  bool get showMonthSuffix => this.monthSuffix?.isNotEmpty ?? false;

  bool get showDay => this.day?.isNotEmpty ?? false;

  bool get showDaySuffix => this.daySuffix?.isNotEmpty ?? false;

  bool get showHour => this.hour?.isNotEmpty ?? false;

  bool get showHourSuffix => this.hourSuffix?.isNotEmpty ?? false;

  bool get showMinute => this.minute?.isNotEmpty ?? false;

  bool get showMinuteSuffix => this.minuteSuffix?.isNotEmpty ?? false;

  bool get showSecond => this.second?.isNotEmpty ?? false;

  bool get showSecondSuffix => this.secondSuffix?.isNotEmpty ?? false;

  @override
  String toString() {
    return "${year ?? ''}${yearSuffix ?? ''}${month ?? ''}${monthSuffix ?? ''}${day ?? ''}${daySuffix ?? ''}${hour ?? ''}${hourSuffix ?? ''}${minute ?? ''}${minuteSuffix ?? ''}${second ?? ''}${secondSuffix ?? ''}";
  }

  bool sameFormatWith(DurationFormat? another) {
    if (another == null) return false;
    return this.showYear == another.showYear &&
        this.showYearSuffix == another.showYearSuffix &&
        this.showMonth == another.showMonth &&
        this.showMonthSuffix == another.showMonthSuffix &&
        this.showDay == another.showDay &&
        this.showDaySuffix == another.showDaySuffix &&
        this.showHour == another.showHour &&
        this.showHourSuffix == another.showHourSuffix &&
        this.showMinute == another.showMinute &&
        this.showMinuteSuffix == another.showMinuteSuffix &&
        this.showSecond == another.showSecond &&
        this.showSecondSuffix == another.showSecondSuffix;
  }
}
