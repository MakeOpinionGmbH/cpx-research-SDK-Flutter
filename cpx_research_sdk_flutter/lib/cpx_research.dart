import 'dart:async';

import 'package:cpx_research_sdk_flutter/browser_view.dart';
import 'package:cpx_research_sdk_flutter/cpx_controller.dart';
import 'package:cpx_research_sdk_flutter/cpx_logger.dart';
import 'package:cpx_research_sdk_flutter/model/cpx_response.dart';
import 'package:cpx_research_sdk_flutter/network_service.dart';
import 'package:cpx_research_sdk_flutter/widgets_overlay.dart';
import 'package:flutter/material.dart';

class CPXResearch extends StatefulWidget {
  final CPXConfig config;

  CPXResearch({@required this.config});

  @override
  _CPXResearchState createState() => _CPXResearchState();
}

class _CPXResearchState extends State<CPXResearch> with WidgetsBindingObserver {
  Timer _timer;

  /// The function [_startTimer] starts the automatic survey check every 120 seconds
  void _startTimer() {
    _timer = Timer.periodic(
      Duration(seconds: 120),
      (Timer t) => {
        NetworkService().fetchSurveysAndTransactions(),
        Controller.controller.showNotification(),
      },
    );
    CPXLogger.log("Timer for automatic survey check started");
    NetworkService().fetchSurveysAndTransactions();
  }

  /// The function [_stopTimer] stops the automatic survey check
  void _stopTimer() {
    _timer?.cancel();
    CPXLogger.log("Timer for automatic survey check stopped");
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Controller.controller.config = widget.config;
    _startTimer();
  }

  /// The function [didChangeAppLifecycleState] listens to app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _startTimer();
        break;
      case AppLifecycleState.inactive:
        _stopTimer();
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _stopTimer();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: Controller.controller.isCPXResearchLayerDisplayed,
      builder: (context, isCPXResearchLayerDisplayed, _) {
        if (isCPXResearchLayerDisplayed) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ValueListenableBuilder<bool>(
              valueListenable: Controller.controller.areCPXWidgetsDisplayed,
              builder: (context, areCPXWidgetsDisplayed, _) {
                if (areCPXWidgetsDisplayed) {
                  return WidgetsOverlay(
                      widget.config.cornerWidget,
                      widget.config.sidebarWidget,
                      widget.config.notificationWidget);
                } else {
                  return BrowserView(Controller.controller.activeTab);
                }
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

/// With [CPXConfig] you can config the survey Widgets.
///
/// The [appID] is your app id
///
/// The [userID] is your external user id
///
/// The [singleSurvey] defines whether the webview is showing all or only a single survey
///
/// The [cornerWidget] defines the style of the corner widget. If you don't want to display the widget leave it out.
///
/// The [sidebarWidget] defines the style of the corner widget. If you don't want to display the widget leave it out.
///
/// The [notificationWidget] defines the style of the corner widget. If you don't want to display the widget leave it out.
///
class CPXConfig {
  final String appID;
  final String userID;
  final Color accentColor;
  final CPXStyle cornerWidget;
  final CPXStyle sidebarWidget;
  final CPXStyle notificationWidget;

  CPXConfig({
    @required this.appID,
    @required this.userID,
    this.accentColor,
    this.cornerWidget,
    this.sidebarWidget,
    this.notificationWidget,
  });
}

/// With [CPXStyle] you can style the Survey Widgets.
///
/// The [position] defines where the widget is displayed.
///
/// The [text] is shown on the widget
///
/// You can adjust the [textSize], if the default is too small or big
///
/// The [backgroundColor] defines the background color of the widget
///
/// The [roundedCorners] defines the border radius of the widget
///
class CPXStyle {
  final double width;
  final double height;
  final WidgetPosition position;
  final bool singleSurvey;
  final String text;
  final double textSize;
  final Color textColor;
  final Color backgroundColor;
  final double roundedCorners;

  CPXStyle({
    this.width = 50,
    this.height = 200,
    this.position = WidgetPosition.SideRight,
    this.singleSurvey = false,
    this.text = "Survey",
    this.textSize = 10,
    this.textColor = Colors.white,
    this.backgroundColor = const Color(0xffFFAF20),
    this.roundedCorners = 10,
  });
}

/// The [WidgetPosition] enum defines the Position of the widgets
/// The notification widget is always horizontally centered at the top or bottom
/// The sidebar widget can be displayed left or right
/// The corner widget can be displayed left or right and at the top or bottom
enum WidgetPosition {
  SideLeft,
  SideRight,
  CornerTopLeft,
  CornerTopRight,
  CornerBottomRight,
  CornerBottomLeft,
  ScreenCenterTop,
  ScreenCenterBottom
}

/// The class [CPXData] provides a ValueNotifier for surveys and transactions
class CPXData {
  static final CPXData cpxData = CPXData();
  ValueNotifier<List<Survey>> surveys = ValueNotifier([]);
  ValueNotifier<List<Transaction>> transactions = ValueNotifier([]);
  ValueNotifier<CPXText> text = ValueNotifier(null);

  void setSurveys(List<Survey> surveys) {
    this.surveys.value = surveys;
  }

  void setTransactions(List<Transaction> transactions) {
    this.transactions.value = transactions;
  }

  void setText(CPXText text) {
    this.text.value = text;
  }
}

/// The function [showCpxLayer] shows the CPX Layer
void showCpxLayer() {
  Controller.controller.showCPXLayer();
}

/// The function [hideCpxLayer] hides the CPX Layer
void hideCpxLayer() {
  Controller.controller.hideCPXLayer();
}

/// The function [showBrowser] shows the CPX Browser
///
/// To open the CPX Browser with a specific survey, provide the optional [surveyID].
///
void showBrowser([String surveyID]) {
  surveyID != null ? Controller.controller.showBrowser(singleSurvey: true, surveyID: surveyID) : Controller.controller.showBrowser();
}

/// The function [fetchCPXSurveysAndTransactions] provides surveys and transactions via the survey and transaction listeners
void fetchCPXSurveysAndTransactions() {
  NetworkService().fetchSurveysAndTransactions();
}

/// The function [markTransactionAsPaid] sends an api request and marks transactions as paid
void markTransactionAsPaid(String transactionID, String messageID) {
  NetworkService().setTransactionPaid(transactionID, messageID);
}
