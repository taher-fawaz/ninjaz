import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ninjaz_application/core/resources/routes_manager.dart';

import '../../core/navigation/custom_navigation.dart';
import '../../core/resources/color_manager.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

int selectedTab = 0;

class _MainScreenState extends State<MainScreen> {
  final GlobalKey _bottomNavigationKey = GlobalKey();

  late List<Widget> appPageTab;

  @override
  void initState() {
    super.initState();

    CustomNavigator.navigatorKeysBottomNav = [
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
    ];
    selectedTab = 0;

    appPageTab = [
      Navigator(
          key: CustomNavigator.navigatorKeysBottomNav[0],
          initialRoute: Routes.postsRoute,
          onGenerateRoute: CustomNavigator.generateHomeRoute
          //generateHomeRoute,
          ),
      Navigator(
          key: CustomNavigator.navigatorKeysBottomNav[1],
          initialRoute: Routes.tab1Route,
          onGenerateRoute: CustomNavigator.generateHomeRoute
          //generateHomeRoute,
          ),
      Navigator(
          key: CustomNavigator.navigatorKeysBottomNav[2],
          initialRoute: Routes.tab2Route,
          onGenerateRoute: CustomNavigator.generateHomeRoute
          //generateHomeRoute,
          ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Widget svgIcon(String text) {
      return Padding(
        padding: EdgeInsets.only(bottom: 7.0.h),
        child: SvgPicture.asset(
          text,
          width: 24,
          height: 22,
        ),
      );
    }

    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          CustomNavigator.popInSubNavigator();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(selectedTab == 0
              ? "Posts"
              : selectedTab == 1
                  ? "Tab 1"
                  : "Tab 2"),
        ),
        body: IndexedStack(index: selectedTab, children: appPageTab),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          child: BottomNavigationBar(
            key: _bottomNavigationKey,
            unselectedFontSize: 12,
            selectedFontSize: 14,
            unselectedItemColor: ColorManager.black,
            unselectedIconTheme: const IconThemeData(size: 22),
            unselectedLabelStyle: TextStyle(color: ColorManager.grey1),
            fixedColor: ColorManager.darkPrimary,
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                // backgroundColor: Colors.black,
                backgroundColor: ColorManager.secondryLight,
                icon: FaIcon(FontAwesomeIcons.houseUser,
                    color: ColorManager.grey),
                activeIcon: const FaIcon(FontAwesomeIcons.houseUser),
                label: "Posts",
              ),
              BottomNavigationBarItem(
                icon:
                    Icon(Icons.book_outlined, color: ColorManager.darkGreyText),
                activeIcon: const FaIcon(FontAwesomeIcons.tablet),
                label: "Tab 1",
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.addressBook,
                    color: ColorManager.darkGreyText),
                activeIcon: const FaIcon(FontAwesomeIcons.user),
                label: "Tab 2",
              ),
            ],
            currentIndex: selectedTab,
            onTap: (value) {
              if (value == selectedTab) {
                CustomNavigator.popInSubNavigator();
              } else {
                setState(() {
                  selectedTab = value;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
