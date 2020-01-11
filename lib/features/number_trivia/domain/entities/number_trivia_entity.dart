import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class NumberTriviaEntity extends Equatable {
  final String text;
  final int number;

  NumberTriviaEntity({
    @required this.text,
    @required this.number,
  }) : super([text, number]);
}
