import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:app_chat/core/router/app_router.gr.dart';
import 'package:app_chat/core/utils/text_style_utils.dart';
import 'package:app_chat/screen/home_screen/home_screen.dart';
import 'package:app_chat/screen/list_message_screen/list_message_screen.dart';
import 'package:app_chat/screen/profile_screen/profile_screen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@RoutePage()
class OverViewScreen extends StatefulWidget {
  const OverViewScreen({super.key});

  @override
  State<OverViewScreen> createState() => _OverViewScreenState();
}

class _OverViewScreenState extends State<OverViewScreen> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
      routes: const [
        HomeRoute(),
        ProfileRoute(),
      ],
      physics: const NeverScrollableScrollPhysics(),
      builder: (context, child, animation) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              AutoRouter.of(context).push(
                ListMessageRoute(),
              );
            },
            backgroundColor: context.theme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              FontAwesomeIcons.facebookMessenger,
              color: context.theme.backgroundColor,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar.builder(
            itemCount: 2,
            notchMargin: 8,
            backgroundColor: context.theme.backgroundColor,
            tabBuilder: (index, isSelected) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Icon(
                      index == 0 ? FontAwesomeIcons.house : FontAwesomeIcons.userLarge,
                      color: _currentIndex == index ? context.theme.primaryColor : context.theme.textColor,
                      size: 18,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      index == 0 ? context.language.home : context.language.profile,
                      style: TextStyleUtils.normal(
                        color: _currentIndex == index ? context.theme.primaryColor : context.theme.textColor,
                        fontSize: 12,
                        context: context,
                      ),
                    ),
                  ],
                ),
              );
            },
            activeIndex: _currentIndex,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.softEdge,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              tabsRouter.setActiveIndex(index);
            },
          ),
        );
      },
    );
  }
}
