import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

typedef SurveyCompletedCallBack = void Function(int reward);

class TheoremReachServices {
  late int rewardValue;

  int extractReward(String inputUrl) {
    final uri = Uri.parse(inputUrl);
    final rewardAmount = uri.queryParameters['reward_amount_in_app_currency'];
    return int.tryParse(rewardAmount.toString()) ?? 0;
  }
}

class TheoremReach {
  final String userId;
  final String apiKey;

  TheoremReach({required this.userId, required this.apiKey});

  Future<bool> isSurveyAvailable() async {
    final userIpAddress = await _getUserIpAddress();
    final surveyStatusMap = await _getSurveysStatus(userIpAddress);

    return surveyStatusMap['surveys_available'] ?? false;
  }

  void showSurveys(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => Surveys(
        apiKey: apiKey,
        userId: userId,
      ),
    ));
  }

  Future<String> _getUserIpAddress() async {
    final ipApi = Uri.parse('https://api.ipify.org?format=json');
    final userApiResponse = await http.get(ipApi);
    final userIpMap = json.decode(userApiResponse.body);
    return userIpMap['ip'];
  }

  int onSurveyCompleted(String inputUrl) {
    final theoremReachServices = TheoremReachServices();
    return theoremReachServices.extractReward(inputUrl);
  }

  String initialUrl() {
    return 'https://theoremreach.com/respondent_entry/direct?api_key=$apiKey&user_id=$userId';
  }

  Future<Map<String, dynamic>> _getSurveysStatus(String userIpAddress) async {
    final dataUri = Uri.parse(
        'https://api.theoremreach.com/api/publishers/v1/user_details?api_key=$apiKey&user_id=$userId&ip=$userIpAddress');
    final response = await http.get(dataUri);
    return json.decode(response.body);
  }
}

class Surveys extends StatelessWidget {
  final String userId;
  final String apiKey;

  const Surveys({Key? key, required this.userId, required this.apiKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theoremReach = TheoremReach(userId: userId, apiKey: apiKey);
    return Scaffold(
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl:
            'https://theoremreach.com/respondent_entry/direct?api_key=$apiKey&user_id=$userId',
        navigationDelegate: (navigation) {
          log(navigation.url);
          if (navigation.url.contains('reward_amount_in_app_currency')) {
            final reward = theoremReach.onSurveyCompleted(navigation.url);

            log(reward.toString());
            // Call a callback or update UI with the reward value
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
