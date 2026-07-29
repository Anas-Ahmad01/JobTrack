import 'package:flutter/material.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find Jobs')),
      body: const Center(
        child: Text(
          'Jobs Screen',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}