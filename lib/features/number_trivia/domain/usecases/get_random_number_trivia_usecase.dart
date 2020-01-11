import 'package:dartz/dartz.dart';
import 'package:flutter_number_trivia/core/error/failures.dart';
import 'package:flutter_number_trivia/core/usecases/usecase.dart';
import 'package:flutter_number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:flutter_number_trivia/features/number_trivia/domain/repositories/number_trivia_repository_contract.dart';

class GetRandomNumberTriviaUsecase implements Usecase<NumberTriviaEntity, NoParams> {
  final NumberTriviaRepositoryContract repository;

  GetRandomNumberTriviaUsecase(this.repository);

  @override
  Future<Either<Failure, NumberTriviaEntity>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}
