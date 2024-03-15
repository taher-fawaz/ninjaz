import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ninjaz_application/injection_container.dart';

import 'core/blocs/app_bloc/app_bloc.dart';
import 'core/blocs/bloc_config/bloc_observer.dart';
import 'core/navigation/custom_navigation.dart';
import 'core/resources/routes_manager.dart';
import 'core/resources/theme_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await (Connectivity().checkConnectivity());
  await DependencyInjectionInit().registerSingletons();
  Bloc.observer = AppBlocObserver();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return setupDependencies(
      child: ScreenUtilInit(
        splitScreenMode: true,
        designSize: const Size(414, 896),
        builder: (BuildContext context, Widget? child) => Listener(
          onPointerDown: (_) async {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              await Future.delayed(const Duration(milliseconds: 50));
              currentFocus.focusedChild?.unfocus();
            }
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ninjaz App',
            theme: getApplicationTheme(),
            navigatorKey: CustomNavigator.navigatorState,
            onGenerateRoute: CustomNavigator.onCreateRoute,
            navigatorObservers: [CustomNavigator.routeObserver],
            builder: (_, c) =>
                LoaderOverlay(useDefaultLoading: false, child: _AppBuilder(c)),
          ),
        ),
      ),
    );
  }
}

class _AppBuilder extends StatefulWidget {
  final Widget? child;

  const _AppBuilder(this.child);

  @override
  State<_AppBuilder> createState() => _AppBuilderState();
}

class _AppBuilderState extends State<_AppBuilder> {
  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }
}
