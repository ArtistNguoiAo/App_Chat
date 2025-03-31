import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/widget/base_text_field.dart';

@RoutePage()
class OverViewScreen extends StatefulWidget {
  const OverViewScreen({super.key});

  @override
  State<OverViewScreen> createState() => _OverViewScreenState();
}

class _OverViewScreenState extends State<OverViewScreen> {
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Over View'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BaseTextField(
                controller: _nameController,
                hintText: 'Name',
                labelText: 'Name',
                prefixIcon: const Icon(Icons.person),
                suffixIcon: const Icon(Icons.clear),
                obscureText: true
              ),
            ],
          ),
        ),
      ),
    );
  }
}
