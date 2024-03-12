const String am = "am";

const String d = "d";

const String D = "D";
const String sD = "sD";
const String dd = "dd";
// ignore: constant_identifier_names
const String DD = "DD";
const String escape = "\\";
const String H = "H";
const String h = "h";
const String hh = "hh";
// ignore: constant_identifier_names
const String HH = "HH";
const String m = "m";
const String M = "M";
// ignore: constant_identifier_names
const String MM = "MM";
const String mm = "mm";
const String n = "n";
const String nn = "nn";
const String S = "S";
const String s = "s";
const String ss = "ss";
// ignore: constant_identifier_names
const String SSS = "SSS";
const String u = "u";
const String uuu = "uuu";
const String W = "W";
const String w = "w";
// ignore: constant_identifier_names
const String WW = "WW";
const String yy = "yy";
const String yyyy = "yyyy";
const String z = "z";
const String Z = "Z";

int dayInYear(DateTime date) =>
    date.difference(DateTime(date.year, 1, 1)).inDays;

String doFormat(DateTime date, List<String> formatters,
    {DateLocale locale = const SimplifiedChineseDateLocale()}) {
  final sb = StringBuffer();
  for (var formatter in formatters) {
    switch (formatter) {
      case yyyy:
        sb.write(_digits(date.year, 4));
        break;
      case yy:
        sb.write(_digits(date.year % 100, 2));
        break;
      case mm:
        sb.write(_digits(date.month, 2));
        break;
      case m:
        sb.write(date.month);
        break;
      case MM:
        sb.write(locale.monthsLong[date.month - 1]);
        break;
      case M:
        sb.write(locale.monthsShort[date.month - 1]);
        break;
      case dd:
        sb.write(_digits(date.day, 2));
        break;
      case d:
        sb.write(date.day);
        break;
      case w:
        sb.write((date.day + 7) ~/ 7);
        break;
      case W:
        sb.write((dayInYear(date) + 7) ~/ 7);
        break;
      case WW:
        sb.write(_digits((dayInYear(date) + 7) ~/ 7, 2));
        break;
      case DD:
        sb.write(locale.daysLong[date.weekday - 1]);
        break;
      case D:
        sb.write(locale.daysShort[date.weekday - 1]);
        break;
      case sD:
        sb.write(locale.daysSuperShort[date.weekday - 1]);
        break;
      case HH:
        sb.write(_digits(date.hour, 2));
        break;
      case H:
        sb.write(date.hour);
        break;
      case hh:
        int hour = date.hour % 12;
        if (hour == 0) hour = 12;
        sb.write(_digits(hour, 2));
        break;
      case h:
        int hour = date.hour % 12;
        if (hour == 0) hour = 12;
        sb.write(hour);
        break;
      case am:
        sb.write(date.hour < 12 ? locale.am : locale.pm);
      case nn:
        sb.write(_digits(date.minute, 2));
      case n:
        sb.write(date.minute);
      case ss:
        sb.write(_digits(date.second, 2));
      case s:
        sb.write(date.second);
      case SSS:
        sb.write(_digits(date.millisecond, 3));
      case S:
        sb.write(date.millisecond);
      case uuu:
        sb.write(_digits(date.microsecond, 3));
      case u:
        sb.write(date.microsecond);
      case z:
        if (date.timeZoneOffset.inMinutes == 0) {
          sb.write("Z");
        } else {
          if (date.timeZoneOffset.isNegative) {
            sb.write("-");
            sb.write(_digits((-date.timeZoneOffset.inHours) % 24, 2));
            sb.write(_digits((-date.timeZoneOffset.inMinutes) % 60, 2));
          } else {
            sb.write("+");
            sb.write(_digits(date.timeZoneOffset.inHours % 24, 2));
            sb.write(_digits(date.timeZoneOffset.inMinutes % 60, 2));
          }
        }
        break;
      case Z:
        sb.write(date.timeZoneName);
        break;
      default:
        if (formatter.startsWith(escape)) {
          formatter = formatter.substring(1);
        }
        sb.write(formatter);
        break;
    }
  }
  return sb.toString();
}

String _digits(int value, int len) {
  String ret = "$value";
  if (ret.length < len) {
    ret = "0" * (len - ret.length) + ret;
  }
  return ret;
}

abstract class DateLocale {
  String get am;

  List<String> get daysSuperShort;

  List<String> get daysLong;

  List<String> get daysShort;

  List<String> get monthsLong;

  List<String> get monthsShort;

  String get pm;
}

class EnglishDateLocale implements DateLocale {
  @override
  final List<String> monthsShort = const [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  @override
  final List<String> monthsLong = const [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  @override
  final List<String> daysShort = const [
    "Mon",
    "Tue",
    "Wed",
    "Thur",
    "Fri",
    "Sat",
    "Sun"
  ];

  @override
  final List<String> daysLong = const [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  const EnglishDateLocale();

  @override
  String get am => "AM";

  @override
  String get pm => "PM";

  @override
  final List<String> daysSuperShort = const [
    "Mon",
    "Tue",
    "Wed",
    "Thur",
    "Fri",
    "Sat",
    "Sun"
  ];
}

class SimplifiedChineseDateLocale implements DateLocale {
  @override
  final List<String> monthsShort = const [
    "1月",
    "2月",
    "3月",
    "4月",
    "5月",
    "6月",
    "7月",
    "8月",
    "9月",
    "10月",
    "11月",
    "12月"
  ];

  @override
  final List<String> monthsLong = const [
    "一月",
    "二月",
    "三月",
    "四月",
    "五月",
    "六月",
    "七月",
    "八月",
    "九月",
    "十月",
    "十一月",
    "十二月"
  ];

  @override
  final List<String> daysShort = const [
    "周一",
    "周二",
    "周三",
    "周四",
    "周五",
    "周六",
    "周日"
  ];

  @override
  final List<String> daysLong = const [
    "星期一",
    "星期二",
    "星期三",
    "星期四",
    "星期五",
    "星期六",
    "星期日"
  ];

  const SimplifiedChineseDateLocale();

  @override
  String get am => "上午";

  @override
  String get pm => "下午";

  @override
  final List<String> daysSuperShort = const ["一", "二", "三", "四", "五", "六", "日"];
}

extension DateFormatter on DateTime {
  String format(List<String> formatters,
      {DateLocale locale = const SimplifiedChineseDateLocale()}) {
    return doFormat(this, formatters, locale: locale);
  }
}

extension SecondsSinceEpoch on num {
  DateTime get toSecondsSinceEpochUTC => DateTime.fromMillisecondsSinceEpoch(
        (this as int) * 1000,
        isUtc: true,
      );

  DateTime get toSecondsSinceEpoch => DateTime.fromMillisecondsSinceEpoch(
        (this as int) * 1000,
        isUtc: false,
      );
}
