import 'package:equatable/equatable.dart';

class Contact extends Equatable {
  final String id;
  final String location;
  final int timestamp;
  final String type;
  const Contact({this.id, this.location, this.timestamp, this.type});

  @override
  List<Object> get props => [id, location, timestamp, type];

  static Contact fromJson(dynamic json) {
    return Contact(
      id: json['id'],
      location: json['location'],
      timestamp: json['timestamp'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() =>
      {'timestamp': timestamp, 'type': type, 'id': id, 'location': location};

  @override
  String toString() => 'Contact { id: $id }';
}
