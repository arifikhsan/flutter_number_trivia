import 'package:dartz/dartz.dart';
import 'package:flutter_number_trivia/features/core/error/failures.dart';

abstract class Usecase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
