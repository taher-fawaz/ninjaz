import 'package:ninjaz_application/features/posts/presentation/bloc/posts_bloc.dart';

import '../../../injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_bloc/app_bloc.dart';

MultiBlocProvider listOfBlocProviders(Widget child) {
  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => AppBloc()),
    ],
    child: child,
  );
}

MultiBlocProvider listOfBlocProvidersForMainScreen(Widget child) {
  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => PostsBloc(getIt())),
    ],
    child: child,
  );
}
