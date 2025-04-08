import 'package:flutter/material.dart';

class ListMessageScreen extends StatelessWidget {
  const ListMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Message Screen'),
      ),
      body: const Center(
        child: Text('Welcome to the List Message Screen!'),
      ),
    );
  }
}
