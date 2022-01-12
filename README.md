# CPX Research SDK Flutter

#### Monetize your product with fun surveys.

We will make it easy for you: Simply implement our solution and be ready to start monetizing your product immediately!
Let users earn your virtual currency by simply participating in exciting and well paid online surveys!

This SDK is owned by [MakeOpinion GmbH](http://www.makeopinion.com).

[Learn more.](https://www.cpx-research.com/main/en/)

# Table of Contents

- [Prerequisites](#prerequisites)
- [Preview](#preview)
- [Installation](#installation)
- [Usage](#usage)
- [Logging](#logging)
- [Changelog](cpx_research_sdk_flutter/CHANGELOG.md)

# Prerequisites
- Android SDK 19 (KitKat) or newer
- iOS Target 9 or newer

# Preview
<p align="center">
  <img width="326" alt="CPXAndroid" src="https://user-images.githubusercontent.com/47904329/135334926-debde7ab-4783-431c-9cac-47e7a21f916e.png"><img width="337" alt="CPXiOS" src="https://user-images.githubusercontent.com/47904329/135334938-7aba4142-5e25-4759-8a96-7ecf6492e3d9.png">
</p>

# Installation

1. Add the package to the dependencies in your pubspec.yaml file.
``` yaml
dependencies:
  cpx_research_sdk_flutter:
    git: 
      url: https://github.com/MakeOpinionGmbH/cpx-research-SDK-Flutter.git
      path: cpx_research_sdk_flutter
```

2. Now import the package in your dart files and use it like any other Flutter package.
``` dart
import 'package:cpx_research_sdk_flutter/cpx.dart';
```

# Usage

## Getting Started (Easy)
Simply add the CPXResearch Widget in a Stack Widget anywhere in your app.

### Only Specific Views
To display the CPXResearch Widget only in specific views, add it inside those views in a Stack Widget (example in Demo App class SecondRoute).
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
      body: Stack(
        children: [
          Center(
            child: Text(
              'This is a Details Screen',
            ),
          ),
          // Easy CPX
          CPXResearch(
            config: new CPXConfig(
                appID: "<Your app id>",
                userID: "<Your external user id>",
                sidebarWidget: new CPXStyle())),
        ],
      ),
  );
}
```

### Entire App Overlay
For an entire app overlay add it to your MaterialApp Widgets builder (example in Demo App class MyApp).
```dart
@override
Widget build(BuildContext context) {
  return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'CPX Flutter Demo'),
      // add following code:
      builder: (context, child) {
        return Material(
          child: Stack(
            children: [
              child,
              // Easy CPX
              CPXResearch(
                  config: new CPXConfig(
                      appID: "<Your app id>",
                      userID: "<Your external user id>",
                      sidebarWidget: new CPXStyle())),
            ],
          ),
        );
      });
}
```

## Getting Started (Advanced)
Customize every CPX Widget as it fits your needs
```dart

CPXStyle cornerstyle = new CPXStyle(
  position: WidgetPosition.CornerTopRight,
  width: 100,
  height: 100,
  text: "click here",
  textSize: 10,
  textColor: Colors.white,
  backgroundColor: Colors.orange,
  roundedCorners: 100,
);

CPXStyle sidebarstyle = new CPXStyle(
  position: WidgetPosition.SideLeft,
  width: 50,
  height: 200,
  singleSurvey: true,                         // Add this line, if the webview should show a single survey
  text: "New Survey available",
  textSize: 10,
  textColor: Colors.white,
  backgroundColor: Colors.orange,
  roundedCorners: 100,
);

CPXStyle notificationstyle = new CPXStyle(
  position: WidgetPosition.ScreenCenterBottom,
  width: 200,
  height: 100,
  text: "New Survey\nParticipate now!",
  textSize: 10,
  textColor: Colors.white,
  backgroundColor: Colors.orange,
  roundedCorners: 20,
);

CPXConfig cpxConfig = new CPXConfig(
    appID: "<Your app id>",
    userID: "<Your external user id>",
    cornerWidget: cornerstyle,                // Add this line, to add the corner widget to the view
    sidebarWidget: sidebarstyle,              // Add this line, to add the sidebar widget to the view
    notificationWidget: notificationstyle);   // Add this line, to add the notification widget to the view

@override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'CPX Flutter Demo'),
        // add following code:
        builder: (context, child) {
          return Material(
            child: Stack(
              children: [
                child, 
                // Advanced CPX
                CPXResearch(config: config)
              ],
            ),
          );
        });
  }

```

## Getting Started (Expert)
Add the CPXResearch Widget with an easy config, but leave the styles empty.
Now handle the CPXResearch Response with the listeners below and use your own Widgets to display the surveys.
```dart
Widget build(BuildContext context) {
  CPXConfig cpxConfig = new CPXConfig(
      appID: "<Your app id>",
      userID: "<Your external user id>");

  return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'CPX Flutter Demo'),
      // add following code:
      builder: (context, child) {
        return Material(
          child: Stack(
            children: [
              child, 
              // Expert CPX
              CPXResearch(config: cpxConfig)
            ],
          ),
        );
      });
}
```

## CPX Survey Cards
First add the CPXResearch Widget with an easy config as in Getting Started (Expert) and leave the styles empty again.
Now add the CPXSurveyCards Widget within in the Material App to display the Cards.
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Flutter SDK Demo App'),
        CPXSurveyCards(),
      ],
    ),
  );
}
```

## Additional functionality of the SDK

### Add surveys listener
```dart
CPXData.cpxData.surveys.addListener(() {
  // YOUR CODE - access surveys via CPXData.cpxData.surveys
});
```

### Add transaction listener
```dart
CPXData.cpxData.transactions.addListener(() {
  // YOUR CODE - access transactions via CPXData.cpxData.transactions
});
```

### Add browser state listener
```dart
Controller.controller.areCPXWidgetsDisplayed.addListener(() {
  // YOUR CODE - access browser state via Controller.controller.areCPXWidgetsDisplayed
});
```

### Fetch all available surveys and transactions for the user
Add surveys and transactions listeners as shown before, to access the response
```dart
fetchCPXSurveysAndTransactions();
```

### Mark a transaction as paid
Add surveys and transactions listeners as shown before, to access the response
```dart
markTransactionAsPaid("<transactionID>", "<messageID>");
```

### Open WebView
Open the WebView (optionally with specific a survey ID)
```dart
showBrowser("surveyID");
```

# Logging
## Add the CPXLogger
The SDK provides a Logger.
```dart
@override
void initState() {
  CPXLogger.enableLogger(true);   // Enable the Logger
  CPXLogger.log("message");       // Use the Logger functionality
  CPXLogger.getLogs;              // Get all SDK logs from memory as list
  super.initState();
}
```

# Android
To allow haptic feedback from the package you probably have to add the following code in the AndroidManifest.xml
``` xml
<uses-permission android:name="android.permission.VIBRATE" />
```
