import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:app_chat/core/router/app_router.gr.dart';
import 'package:app_chat/core/utils/text_style_utils.dart';
import 'package:app_chat/core/widget/base_text_field.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class ListMessageScreen extends StatelessWidget {
  ListMessageScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [_searchBar(context), const SizedBox(height: 16), Expanded(child: _listMessage(context))],
      ),
    ));
  }

  Widget _searchBar(BuildContext context) {
    return BaseTextField(
      controller: searchController,
      prefixIcon: const Icon(Icons.search),
      hintText: 'Search',
    );
  }

  Widget _listMessage(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          context.router.push(const MessageRoute());
        },
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.theme.borderColor,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  children: [
                    Text(
                      'User Name',
                      style: TextStyleUtils.bold(
                        fontSize: 16,
                        color: context.theme.textColor,
                        context: context,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Last message',
                      style: TextStyleUtils.normal(
                        fontSize: 14,
                        color: context.theme.textColor,
                        context: context,
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
      separatorBuilder: (context, index) => const Divider(),
      itemCount: 20,
    );
  }
}
