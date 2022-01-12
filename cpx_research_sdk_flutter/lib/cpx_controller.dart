import 'package:cpx_research_sdk_flutter/widgets/browser_view.dart';
import 'package:cpx_research_sdk_flutter/utils/cpx_logger.dart';
import 'package:cpx_research_sdk_flutter/utils/network_service.dart';
import 'package:flutter/material.dart';

import 'model/cpx_config.dart';

class Controller {
  static final Controller controller = Controller();
  ValueNotifier<bool> areCPXWidgetsDisplayed = ValueNotifier(true);
  ValueNotifier<bool> isCPXResearchLayerDisplayed = ValueNotifier(false);
  ValueNotifier<bool> isCPXNotificationDisplayed = ValueNotifier(true);

  CPXConfig config;
  BrowserTab activeTab;
  bool isSingleSurveyDisplayed;
  String singleSurveyID;

  /// [showWidgets] displays the banner widgets and hides the webview widget
  void showWidgets() {
    areCPXWidgetsDisplayed.value = true;
    CPXLogger.log("Show CPX Widgets");
    NetworkService().fetchSurveysAndTransactions();
  }

  /// [showBrowser] displays the webview widget and hides the banner widgets
  void showBrowser({BrowserTab currentTab = BrowserTab.home, bool singleSurvey = false, String surveyID}) {
    areCPXWidgetsDisplayed.value = false;
    CPXLogger.log("Show CPX Browser");
    activeTab = currentTab;
    isSingleSurveyDisplayed = singleSurvey;
    singleSurveyID = surveyID;
  }

  void showNotification() {
    isCPXNotificationDisplayed.value = true;
    CPXLogger.log("Show CPX Notification after new fetch");
  }

  void hideNotification() {
    isCPXNotificationDisplayed.value = false;
    CPXLogger.log("Hide CPX Notification after closing it");
  }

  /// [showCPXLayer] displays the entire cpx overlay if surveys are available
  void showCPXLayer() {
    isCPXResearchLayerDisplayed.value = true;
    CPXLogger.log("Show CPX Research Layer");
  }

  /// [hideCPXLayer] hides the entire cpx overlay if surveys aren't available
  void hideCPXLayer() {
    isCPXResearchLayerDisplayed.value = false;
    CPXLogger.log("Hide CPX Research Layer");
  }
}
