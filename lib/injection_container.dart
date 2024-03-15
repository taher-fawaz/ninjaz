import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ninjaz_application/core/config/app_env.dart';
import 'package:ninjaz_application/core/network/api_config_rest.dart';
import 'package:ninjaz_application/core/network/ninjaz_rest.dart';
import 'package:ninjaz_application/features/posts/data/datasources/posts_local_datasource.dart';
import 'package:ninjaz_application/features/posts/data/datasources/posts_remote_datasource.dart';
import 'package:ninjaz_application/features/posts/data/models/realm.dart';
import 'package:ninjaz_application/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:ninjaz_application/features/posts/domain/repositories/posts_repository.dart';
import 'package:ninjaz_application/features/posts/domain/usecases/posts_usecase.dart';
import 'package:realm/realm.dart';

import 'core/blocs/bloc_config/bloc_providers.dart';

final GetIt getIt = GetIt.instance;

Widget setupDependencies({required Widget child}) => listOfBlocProviders(child);

Widget setupDependenciesMainScreen({required Widget child}) =>
    listOfBlocProvidersForMainScreen(child);

class DependencyInjectionInit {
  static final DependencyInjectionInit _singleton = DependencyInjectionInit._();

  factory DependencyInjectionInit() => _singleton;

  DependencyInjectionInit._();

  /// Register the Basic Singleton
  Future<void> registerSingletons() async {
    getIt.registerLazySingleton(() => appEnv);
    final realm = Realm(
      Configuration.local(
        [PostRealm.schema, OwnerRealm.schema],
        schemaVersion: 2,
      ),
    );
    getIt.registerLazySingleton(() => realm);

    /// register Dio Package
    getIt.registerLazySingleton(() => Dio());

    getIt.registerLazySingleton(() => Dio(), instanceName: "apiConfig");

    getIt.registerLazySingleton(() => Dio(), instanceName: "ninjazDio");

    final apiConfig =
        ApiConfigRest(getIt.call(instanceName: "apiConfig"), enableLog: true);

    final ninjazRest = NinjazRest(getIt.call(instanceName: "ninjazDio"), appEnv,
        enableLog: true);

    getIt.registerLazySingleton(() => apiConfig);
    getIt.registerLazySingleton(() => ninjazRest);

    getIt.registerLazySingleton(() => Connectivity());

    final getPostsUseCase = _initGetPostsUseCase(ninjazRest, realm);
    getIt.registerLazySingleton(() => getPostsUseCase);
  }
}

GetPostsUseCase _initGetPostsUseCase(NinjazRest ninjazRest, Realm local) {
  IPostsRemoteDataSource postDataSource;
  IPostsRepository postRepository;

  IPostsLocalDataSource postsLocalDataSource;

  postDataSource = PostsRemoteDataSourceImpl(ninjazRest);
  postsLocalDataSource = PostsLocalDataSourceImpl(local);

  // init repositories
  postRepository = PostsRepositoryImpl(
      remoteDataSource: postDataSource, localDataSource: postsLocalDataSource);
  // use cases
  return GetPostsUseCase(postRepository);
}
