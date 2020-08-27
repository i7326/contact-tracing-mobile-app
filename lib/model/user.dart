import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid;
  const User({this.uid});

  @override
  List<Object> get props => [uid];

    static User fromJson(dynamic json) {
    return User(
      uid: json['uid'],
    );
  }

  @override
  String toString() => 'User { uid: $uid }';
}