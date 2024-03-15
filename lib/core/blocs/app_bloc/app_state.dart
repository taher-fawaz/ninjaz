part of 'app_bloc.dart';

@immutable
abstract class AppState {}

class AppInitial extends AppState {}

class LoadingState extends AppState {}

class FailedState extends AppState {
  final String message;
  FailedState(this.message);
}

class NotFoundState extends AppState {}

class NoInternetConnectionState extends AppState {}

class ServerExceptionState extends AppState {}

class UnAuthorizationExceptionState extends AppState {}

class BadRequestExceptionState extends AppState {}

class UpdateAppStatus extends AppState {
  final AppStatus appStatus;
  UpdateAppStatus(this.appStatus);
}

enum AppStatus { success, serverError, noInternet }
