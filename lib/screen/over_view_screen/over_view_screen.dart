import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:app_chat/core/utils/color_utils.dart';
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
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeScreen(),
          ProfileScreen(),
          ListMessageScreen(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _currentIndex = 2;
          });
        },
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(
          FontAwesomeIcons.facebookMessenger,
          color: _currentIndex == 2
              ? ColorUtils.primaryColor
              : ColorUtils.textColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: 2,
        notchMargin: 8,
        tabBuilder: (index, isSelected) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Icon(
                  index == 0
                      ? FontAwesomeIcons.house
                      : FontAwesomeIcons.userLarge,
                  color: _currentIndex == index
                      ? ColorUtils.primaryColor
                      : ColorUtils.textColor,
                  size: 18,
                ),
                const SizedBox(height: 4),
                Text(
                  index == 0 ? 'Home' : 'Profile',
                  style: TextStyleUtils.normal(
                    color: _currentIndex == index
                        ? ColorUtils.primaryColor
                        : ColorUtils.textColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
        activeIndex: _currentIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
