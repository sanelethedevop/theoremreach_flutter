
# theoremreach_flutter

A Flutter package that enables seamless integration of TheoremReach surveys into your Flutter applications.

## Introduction

`theoremreach_flutter` is a Flutter package that simplifies the process of integrating TheoremReach surveys into your Flutter applications. The package provides a straightforward way to check for available surveys, display them within a WebView, and retrieve survey rewards.

## Features

- Check if surveys are available for the user.
- Launch surveys in a WebView for a seamless user experience.
- Retrieve survey rewards upon completion.

## Installation

To use this package, add `theoremreach_flutter` as a dependency in your `pubspec.yaml` file.
```yaml
dependencies:
  theoremreach_flutter: ^1.0.2 
```


## Usage
After instalalion you can then import the dependecy on your project

```dart
 import 'package:theoremreach_flutter/theoremreach_flutter.dart';
```
init theoremReach plugin
```dart
  final TheoremReach theoremReach =
      TheoremReach(userId: 'YouUserId', apiKey: 'YouApiKey');
```
show surveys with the following snipet

```dart
theoremReach.showSurveys(context);
```
