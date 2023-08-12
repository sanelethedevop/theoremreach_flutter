import 'package:flutter/material.dart';
import 'package:theoremreach_flutter/theoremreach_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'TheoremReach Flutter Example',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('TheoremReach Flutter Example'),
        ),
        body: const Surveys(
            userId: 'hdhgds', apiKey: '60c79ecd2bf59b7f18eb1c9255da'));
  }
}
