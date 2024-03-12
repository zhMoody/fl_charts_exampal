import 'package:flutter_example/charts/serialize.dart';
import 'package:flutter_example/formmter.dart';

class Device extends Serialize {
  final int _id;
  final String name;
  final DateTime? createdAt;

  Device({
    required int id,
    required this.name,
    this.createdAt,
  }) : _id = id;

  @override
  int get id => _id;

  @override
  Map<String, dynamic> asMap() {
    final Map<String, dynamic> map = {
      "name": name,
    };
    if (createdAt != null) {
      map["created_at"] = createdAt;
    }
    return map;
  }

  @override
  String toString() {
    return "{ id: $id, name: $name, createdAt: ${createdAt?.format([
          yyyy,
          ".",
          mm,
          ".",
          dd,
          " ",
          HH,
          ":",
          nn,
          ":",
          ss,
        ])} }";
  }

  static Device from(Map<String, dynamic> maps) {
    return Device(
      id: (maps["id"] as int?) ?? -1,
      name: (maps["name"] as String?) ?? "",
      createdAt: (maps["created_at"] as int? ?? 0).toSecondsSinceEpoch,
    );
  }
}

class DeviceRecord extends Serialize {
  final int _id;

  /// 序号
  final int seqNum;

  final String rawSeqNum;

  /// 血糖值对应电压
  final int voltage;

  final String rawVoltage;

  final DateTime? createdAt;

  final DateTime calculatedAt;

  DeviceRecord({
    required int id,
    required this.seqNum,
    required this.voltage,
    required this.rawSeqNum,
    required this.rawVoltage,
    required this.calculatedAt,
    this.createdAt,
  }) : _id = id;

  @override
  int get id => _id;

  bool get isOk => _id > 0 && seqNum > 0 && voltage > 0;

  @override
  Map<String, dynamic> asMap() {
    final Map<String, dynamic> map = {
      "seq_num": seqNum,
      "voltage": voltage,
      "raw_seq_num": rawSeqNum,
      "raw_voltage": rawVoltage,
      "calculated_at": calculatedAt.millisecondsSinceEpoch ~/ 1000,
    };
    if (createdAt != null) {
      map["created_at"] = (createdAt?.millisecondsSinceEpoch ?? 0) ~/ 1000;
    }
    return map;
  }

  @override
  String toString() {
    return "{ id: $id, seqNum: $seqNum, voltage: $voltage, rawSeqNum: $rawSeqNum, rawVoltage: $rawVoltage, calculatedAt: ${calculatedAt.format([
          yyyy,
          ".",
          mm,
          ".",
          dd,
          " ",
          HH,
          ":",
          nn,
          ":",
          ss,
        ])} }";
  }

  static DeviceRecord from(Map<String, dynamic> maps) {
    return DeviceRecord(
      id: (maps["id"] as int?) ?? -1,
      seqNum: (maps["seq_num"] as int?) ?? -1,
      voltage: (maps["voltage"] as int?) ?? -1,
      rawSeqNum: (maps["raw_seq_num"] as String?) ?? "",
      rawVoltage: (maps["raw_voltage"] as String?) ?? "",
      createdAt: (maps["created_at"] as int? ?? 0).toSecondsSinceEpoch,
      calculatedAt: (maps["calculated_at"] as int? ?? 0).toSecondsSinceEpoch,
    );
  }
}
