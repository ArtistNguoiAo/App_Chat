import 'package:app_chat/core/widget/base_loading.dart';
import 'package:app_chat/screen/notify_screen/cubit/notify_cubit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class NotifyScreen extends StatelessWidget {
  const NotifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notify',
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              return ListView.separated(
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Text(
                        state.listUser[index].fullName,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          context.read<NotifyCubit>().acceptRequest(state.listUser[index], true);
                        },
                        child: const Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          context.read<NotifyCubit>().acceptRequest(state.listUser[index], false);
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: state.listUser.length,
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
