import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:app_chat/core/utils/text_style_utils.dart';
import 'package:app_chat/core/widget/base_loading.dart';
import 'package:app_chat/screen/notify_screen/cubit/notify_cubit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@RoutePage()
class NotifyScreen extends StatelessWidget {
  const NotifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.language.notify,
          style: TextStyleUtils.bold(
            fontSize: 20,
            color: context.theme.backgroundColor,
            context: context,
          ),
        ),
        leading: InkWell(
          onTap: () {
            AutoRouter.of(context).maybePop();
          },
          child: Icon(
            FontAwesomeIcons.chevronLeft,
            color: context.theme.backgroundColor,
            size: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: context.theme.primaryColor,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) => NotifyCubit()..getListNotify(),
        child: BlocConsumer<NotifyCubit, NotifyState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is NotifyLoading) {
              return const BaseLoading();
            }
            if (state is NotifyLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: context.theme.backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: context.theme.borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.language.notifyAcceptFriend + state.listUser[index].fullName,
                            style: TextStyleUtils.normal(
                              context: context,
                              fontSize: 16,
                              color: context.theme.textColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(child: Container()),
                              InkWell(
                                onTap: () {
                                  context.read<NotifyCubit>().acceptRequest(state.listUser[index], true);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: context.theme.primaryColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    context.language.accept,
                                    style: TextStyleUtils.normal(
                                      context: context,
                                      fontSize: 16,
                                      color: context.theme.backgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  context.read<NotifyCubit>().acceptRequest(state.listUser[index], false);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: context.theme.redColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    context.language.cancel,
                                    style: TextStyleUtils.normal(
                                      context: context,
                                      fontSize: 16,
                                      color: context.theme.backgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: state.listUser.length,
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
