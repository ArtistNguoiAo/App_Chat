import 'package:app_chat/core/utils/color_utils.dart';
import 'package:app_chat/core/utils/media_utils.dart';
import 'package:app_chat/core/utils/text_style_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(context),
          ],
        ),
      )
    );
  }

  Widget _header(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          Container(
              height: 150,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              width: double.infinity,
              color: ColorUtils.primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Welcome to ChitChat world!",
                          style: TextStyleUtils.bold(
                            fontSize: 20,
                            color: ColorUtils.backgroundColor,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {

                        },
                        child: FaIcon(
                          FontAwesomeIcons.bell,
                          color: ColorUtils.backgroundColor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "I'm virtual assistant CC_Bot. How can I help you?",
                    style: TextStyleUtils.normal(
                      fontSize: 16,
                      color: ColorUtils.backgroundColor,
                    ),
                  ),
                ],
              )
          ),
          Positioned(
            top: 100,
            left: 16,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {

              },
              child: Container(
                height: 100,
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width - 32,
                decoration: BoxDecoration(
                  color: ColorUtils.backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: ColorUtils.borderColor.withAlpha((0.5 * 255).round()),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(MediaUtils.imgBackground),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello,',
                            style: TextStyleUtils.normal(
                              fontSize: 16,
                              color: ColorUtils.textColor,
                            ),
                          ),
                          Text(
                            'Lê Quốc Trung',
                            style: TextStyleUtils.bold(
                              fontSize: 20,
                              color: ColorUtils.textColor,
                            ),
                          ),
                          Text(
                            'Have a good day!',
                            style: TextStyleUtils.normal(
                              fontSize: 16,
                              color: ColorUtils.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    FaIcon(
                      FontAwesomeIcons.feather,
                      color: ColorUtils.textColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
