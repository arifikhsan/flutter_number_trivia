import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_number_trivia/core/error/exceptions.dart';
import 'package:flutter_number_trivia/core/error/failures.dart';
import 'package:flutter_number_trivia/core/network/network_info.dart';
import 'package:flutter_number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:flutter_number_trivia/features/number_trivia/domain/repositories/number_trivia_repository_contract.dart';

typedef Future<NumberTriviaEntity> _ConcreteOrRandomChooser();

class NumberTriviaRepositoryImplementation
    implements NumberTriviaRepositoryContract {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfoContract networkInfo;

  NumberTriviaRepositoryImplementation({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTriviaEntity>> getConcreteNumberTrivia(
    int number,
  ) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTriviaEntity>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTriviaEntity>> _getTrivia(
      _ConcreteOrRandomChooser getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
