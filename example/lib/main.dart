import 'package:flutter/material.dart';
import 'package:theoremreach_flutter/theoremreach_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TheoremReach Flutter Example',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final TheoremReach theoremReach =
      TheoremReach(userId: 'YouUserId', apiKey: 'YouApiKey');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('TheoremReach Flutter Example'),
        ),
        body: Center(
          child: ElevatedButton(
              onPressed: () {
                theoremReach.showSurveys(context);
              },
              child: const Text('Show Surveys')),
        ));
  }
}
