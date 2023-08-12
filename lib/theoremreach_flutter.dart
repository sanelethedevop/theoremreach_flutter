import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

// Passes the  reward when the survey has been completed
typedef SurveyCompletedCallBack = void Function(int reward);

//TheoemReach services , this is used to handle reward related functionalitys
class TheoremReachServices {
  late int rewardValue;

  /// return [int] which os the value of the reward, it is only called when the survey has been completed
  int extractReward(String inputUrl) {
    final uri = Uri.parse(inputUrl);
    final rewardAmount = uri.queryParameters['reward_amount_in_app_currency'];
    return int.tryParse(rewardAmount.toString()) ?? 0;
  }
}

// Handle all theoremReach core functions

class TheoremReach {
  /// requires [userId] and [apiKey] to track the user and assign rewards accordingly
  final String userId;
  final String apiKey;

  TheoremReach({required this.userId, required this.apiKey});

  /// Checks if surveys are available , it return a [bool] which can be used based on the return value
  Future<bool> isSurveyAvailable() async {
    final userIpAddress = await _getUserIpAddress();
    final surveyStatusMap = await _getSurveysStatus(userIpAddress);

    return surveyStatusMap['surveys_available'] ?? false;
  }

// Open a new screen on with the webView to display survey from appwrite
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
    // Get the map of the survey status
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
