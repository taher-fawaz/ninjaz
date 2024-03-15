part of 'app_bloc.dart';

@immutable
abstract class AppEvent {}

class InitApp extends AppEvent {}

class UpdateAppEvent extends AppEvent {
  final AppStatus? appStatus;
  UpdateAppEvent({
    this.appStatus,
  });
}
