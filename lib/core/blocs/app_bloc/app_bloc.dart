import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injection_container.dart';
import '../../common/widgets/no_internet_pop_message.dart';
import '../../config/app_env.dart';
import '../../navigation/custom_navigation.dart';
import '../../network/api_url.dart';
import '../../resources/routes_manager.dart';

// import 'package:tawqi3i_packages/tawqi3i_packages.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  AppBloc() : super(AppInitial()) {
    /// Init App Functions
    on<InitApp>((event, emit) async {
      try {
        const appEnv = AppEnvironment.staging;
        await getIt.reset(dispose: true);
        await DependencyInjectionInit().registerSingletons();
        String baseUrl = (appEnv == AppEnvironment.production
                ? ApiURLs.baseUrl
                : ApiURLs.baseUrl)
            .replaceAll("https://", '')
            .replaceAll("http://", '');

        CustomNavigator.push(Routes.mainRoute, clean: true);
      } on Exception catch (_) {
        checkInternet();
      }
    });

    add(InitApp());

    on<UpdateAppEvent>((event, emit) async {
      emit(UpdateAppStatus(event.appStatus!));
    });
  }

  void checkInternet() {
    BuildContext? noInternetContext;
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
      developer.log("result: $result");

      if (result == ConnectivityResult.none) {
        if (noInternetContext == null) {
          showDialog(
              useSafeArea: false,
              context: currentContext!,
              builder: (context) {
                noInternetContext = context;
                return const NoInternetPopMessage();
              },
              barrierDismissible: false);
        }
      } else {
        if (Navigator.of(currentContext!).canPop()) {
          try {
            Navigator.of(currentContext!).pop();
            noInternetContext = null;
          } catch (_) {}
        }
      }
    });
  }
}
