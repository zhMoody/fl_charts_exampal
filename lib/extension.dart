import "dart:math";
import "dart:ui";
import "package:flutter/foundation.dart";

extension PhoneNumber on String {
  String get mask {
    final RegExp countryCodeRegex = RegExp(r"^\+(?<code>\d{1,2})");
    final RegExpMatch? countryCodeMatch = countryCodeRegex.firstMatch(this);
    final String? countryCode = countryCodeMatch?.namedGroup("code");

    late RegExp phonePartsRegex;
    if (countryCode == "86") {
      phonePartsRegex = RegExp(r"^\+(86)(\d{3})(\d{4})(\d{4})$");
    } else {
      return this;
    }

    final RegExpMatch phonePartsMatch = phonePartsRegex.firstMatch(this)!;

    final String maskedPart = "*" *
        (phonePartsMatch.group(2)!.length + phonePartsMatch.group(3)!.length);

    return "${phonePartsMatch.group(2)} $maskedPart ${phonePartsMatch.group(4)}";
  }

  bool get isValid => RegExp(r"^\+(86)(\d{3})(\d{4})(\d{4})$").hasMatch(this);

  bool get isNumber => RegExp(r"^(?:20|1?\d(\.\d+)?|0\.\d+)$").hasMatch(this);
}

extension CamelCase on String {
  String get convertToCamelCase {
    List<String> words = split("_");
    String result = "";
    for (int i = 0; i < words.length; i++) {
      String word = words[i];
      if (i == 0) {
        result += word;
      } else {
        result += word[0].toUpperCase() + word.substring(1);
      }
    }
    return result;
  }
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapi<T>(T Function(E, int) toElement) {
    var i = 0;
    return map((e) => toElement(e, i++));
  }

  void forEachI<T>(T Function(E, int) toElement) {
    var i = 0;
    forEach((e) => toElement(e, i++));
  }
}

extension DistanceTo on Offset {
  double distanceTo(Offset p2) {
    final dx_ = p2.dx - dx;
    final dy_ = p2.dy - dy;
    return sqrt(dx_ * dx_ + dy_ * dy_);
  }
}

extension DashLine on Canvas {
  void drawDashLine(
    Offset p1,
    Offset p2,
    Paint paint, {
    List<double> dashed = const [3.0, 4.0],
  }) {
    final path = Path();
    final [dashWidth, dashSpace] = dashed;

    if (p2.dy >= p1.dy && p2.dx >= p1.dx) {
      final double deltaX = p2.dx - p1.dx;
      final double deltaY = p2.dy - p1.dy;
      final double distance = sqrt(deltaX * deltaX + deltaY * deltaY);

      final double cosTheta = deltaX / distance;
      final double sinTheta = deltaY / distance;

      var currentDistance = 0.0;
      while (currentDistance < distance) {
        path.moveTo(p1.dx + cosTheta * currentDistance,
            p1.dy + sinTheta * currentDistance);
        final double nextDistance = currentDistance + dashWidth;
        if (nextDistance <= distance) {
          path.lineTo(
              p1.dx + cosTheta * nextDistance, p1.dy + sinTheta * nextDistance);
        } else {
          path.lineTo(p2.dx, p2.dy);
        }
        currentDistance += dashWidth + dashSpace;
      }
    } else if (p2.dy >= p1.dy && p2.dx < p1.dx) {
      var currentX = p1.dx;
      while (currentX > p2.dx) {
        path.moveTo(currentX, p1.dy);
        path.lineTo(currentX - dashWidth, p1.dy);
        currentX -= dashWidth + dashSpace;
      }
    } else if (p2.dy < p1.dy && p2.dx >= p1.dx) {
      var currentY = p1.dy;
      while (currentY > p2.dy) {
        path.moveTo(p1.dx, currentY);
        path.lineTo(p1.dx, currentY - dashWidth);
        currentY -= dashWidth + dashSpace;
      }
    } else {
      var currentX = p1.dx;
      var currentY = p1.dy;
      while (currentY > p2.dy && currentX > p2.dx) {
        path.moveTo(currentX, currentY);
        path.lineTo(currentX - dashWidth, currentY - dashWidth);
        currentX -= dashWidth + dashSpace;
        currentY -= dashWidth + dashSpace;
      }
    }

    drawPath(path, paint);
  }
}

extension BigEndian on List<int> {
  int get hex {
    var ret = 0;
    var shift = 0;
    for (var i = length - 1; i >= 0; --i) {
      ret += this[i] << shift;
      shift += 8;
    }

    return ret;
  }

  int get voltageHex {
    var ret = 0;
    var shift = 0;
    for (var i = length - 1; i >= 0; --i) {
      if (this[0] == 0xFF) {
        return 0;
      }
      ret += this[i] << shift;
      shift += 8;
    }

    return ret;
  }
}

extension Binary on int {
  List<int> get bin {
    final bytes = ByteData(4)..setInt32(0, this, Endian.big);
    return [
      bytes.getUint8(0),
      bytes.getUint8(1),
      bytes.getUint8(2),
      bytes.getUint8(3),
    ];
  }
}

extension Range on Random {
  double range(double max, double min) => min + nextDouble() * (max - min);
}

extension CurrentDay on DateTime {
  DateTime get currentDay => DateTime(year, month, day);
}

bool areDatesEqual(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}
