import 'package:app_chat/core/ext_context/ext_context.dart';
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
              color: context.theme.primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.language.welcomeApp,
                          style: TextStyleUtils.bold(
                            fontSize: 20,
                            color: context.theme.backgroundColor,
                            context: context,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {

                        },
                        child: FaIcon(
                          FontAwesomeIcons.bell,
                          color: context.theme.backgroundColor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    context.language.introduceBot,
                    style: TextStyleUtils.normal(
                      fontSize: 16,
                      color: context.theme.backgroundColor,
                      context: context,
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
                  color: context.theme.backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: context.theme.borderColor.withAlpha((0.5 * 255).round()),
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
                            '${context.language.hello},',
                            style: TextStyleUtils.normal(
                              fontSize: 16,
                              color: context.theme.textColor,
                              context: context,
                            ),
                          ),
                          Text(
                            'Lê Quốc Trung',
                            style: TextStyleUtils.bold(
                              fontSize: 20,
                              color: context.theme.textColor,
                              context: context,
                            ),
                          ),
                          Text(
                            '${context.language.haveAGoodDay}!',
                            style: TextStyleUtils.normal(
                              fontSize: 16,
                              color: context.theme.textColor,
                              context: context,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    FaIcon(
                      FontAwesomeIcons.feather,
                      color: context.theme.textColor,
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
