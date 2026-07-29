import 'package:flutter/material.dart';

class SavedJobsScreen extends StatelessWidget {
  const SavedJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Jobs')),
      body: const Center(
        child: Text(
          'Saved Jobs Screen ',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}