import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FlagStatus extends Equatable {
  final Color color;
  final String text;
  const FlagStatus({this.color, this.text});

  @override
  List<Object> get props => [color, text];

    static FlagStatus fromJson(dynamic json) {
    return FlagStatus(
      color: json['color'],
      text: json['text'],
    );
  }

  @override
  String toString() => 'Flag { status: $text }';
}