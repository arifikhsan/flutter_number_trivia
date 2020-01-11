import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_number_trivia/core/network/network_info.dart';
import 'package:flutter_number_trivia/core/util/input_converter.dart';
import 'package:flutter_number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia_usecase.dart';
import 'package:flutter_number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:flutter_number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'features/number_trivia/domain/repositories/number_trivia_repository_contract.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  // bloc
  serviceLocator.registerFactory(
    () => NumberTriviaBloc(
      concrete: serviceLocator(),
      random: serviceLocator(),
      inputConverter: serviceLocator(),
    ),
  );

  // Use cases
  serviceLocator
      .registerLazySingleton(() => GetConcreteNumberTriviaUsecase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetRandomNumberTriviaUsecase(serviceLocator()));

  // Repository
  serviceLocator.registerLazySingleton<NumberTriviaRepositoryContract>(
    () => NumberTriviaRepositoryImpl(
      localDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
      remoteDataSource: serviceLocator(),
    ),
  );

  // Data sources
  serviceLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImplementation(client: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImplementation(sharedPreferences: serviceLocator()),
  );

  //! Core
  serviceLocator.registerLazySingleton(() => InputConverter());
  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(serviceLocator()),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => DataConnectionChecker());
}
