import 'package:equatable/equatable.dart';

class Flag extends Equatable {
  final int timestamp;
  final String type;
  const Flag({this.timestamp, this.type});

  @override
  List<Object> get props => [type, timestamp];

  static Flag fromJson(dynamic json) {
    return Flag(
      timestamp: json['timestamp'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() => {'timestamp': timestamp, 'type': type};

  @override
  String toString() => 'Flag { type: $type }';
}
