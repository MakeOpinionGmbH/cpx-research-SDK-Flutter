import 'package:cpx_research_sdk_flutter/cpx.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

CPXStyle cornerstyle = new CPXStyle(
  position: WidgetPosition.CornerTopRight,
  width: 100,
  height: 100,
  text: "click here",
  textSize: 12,
  textColor: Colors.white,
  backgroundColor: Colors.orange,
  roundedCorners: 100,
);

CPXStyle sidebarstyle = new CPXStyle(
  position: WidgetPosition.SideLeft,
  width: 50,
  height: 200,
  singleSurvey: true,
  text: "New Survey available",
  textSize: 12,
  textColor: Colors.white,
  backgroundColor: Colors.orange,
  roundedCorners: 100,
);

CPXStyle notificationstyle = new CPXStyle(
  position: WidgetPosition.ScreenCenterBottom,
  width: 200,
  height: 100,
  text: "New Survey\nParticipate now!",
  textSize: 12,
  textColor: Colors.white,
  backgroundColor: Colors.orange,
  roundedCorners: 20,
);

CPXConfig config = new CPXConfig(
  appID: "5878",
  userID: "flutterTempUser",
  accentColor: Color(0xffFFAF20),
  cornerWidget: cornerstyle,
  sidebarWidget: sidebarstyle,
  notificationWidget: notificationstyle,
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'CPX Flutter Demo'),
      builder: (context, child) {
        return Material(
          child: Stack(
            children: [
              child!,
              // Advanced CPX
              CPXResearch(config: config)
            ],
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CPXData cpxData = CPXData.cpxData;

  /// [onSurveyUpdate] is called when the surveys update
  void onSurveyUpdate() {
    // YOUR CODE
  }

  /// [onTransactionUpdate] is called when the transactions update
  void onTransactionUpdate() {
    // YOUR CODE
  }

  /// [onBrowserVisibilityChanged] is called when the browser closes or opens
  void onBrowserVisibilityChanged() {
    // YOUR CODE
    Controller.controller.areCPXWidgetsDisplayed.value ? print("Browser closed") : print("Browser opened");
  }

  /// Initialize all CPX components like logging and change listeners
  void initCPX() {
    CPXLogger.enableLogger(true);
    CPXLogger.log("I am a test log from CPX");
    CPXLogger.getLogs;
    cpxData.surveys.addListener(onSurveyUpdate);
    cpxData.transactions.addListener(onTransactionUpdate);
    Controller.controller.areCPXWidgetsDisplayed.addListener(onBrowserVisibilityChanged);
  }

  @override
  void initState() {
    initCPX();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Flutter SDK Demo App',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            Text('Version 0.4.3'),
            SizedBox(height: 20),
            CPXSurveyCards(noSurveysWidget: Text('I show up, if there are no surveys available'),),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondRoute()),
                );
              },
              child: Text("Next Page"),
            ),
            ElevatedButton(
              onPressed: () => fetchCPXSurveysAndTransactions(),
              child: Text("Fetch Surveys and Transactions"),
            ),
            ElevatedButton(
              onPressed: () => markTransactionAsPaid("1", "2"),
              child: Text("Mark Transaction as Paid"),
            ),
            ElevatedButton(
              onPressed: () => showCpxLayer(),
              child: Text("Show CPX Layer"),
            ),
            ElevatedButton(
              onPressed: () => hideCpxLayer(),
              child: Text("Hide CPX Layer"),
            ),
            ElevatedButton(
              onPressed: () => showBrowser(),
              child: Text("Show Webview"),
            ),
            ElevatedButton(
              onPressed: () => showBrowser(cpxData.surveys.value![0].id),
              child: Text("Show Single Survey Webview"),
            ),
            SizedBox(height: 60),
          ],
          ),
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Stack(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Go back!'),
            ),
          ),
          CPXResearch(
            config: CPXConfig(
              appID: "1",
              userID: "userid",
              sidebarWidget: CPXStyle(),
            ),
          ),
        ],
      ),
    );
  }
}
