/*
 * cpx_network_service.dart
 * CPX Research
 *
 * Created by Dennis Kossmann on 11.7.2021.
 * Copyright © 2021. All rights reserved.
 */

import 'dart:convert';

import 'package:cpx_research_sdk_flutter/cpx_controller.dart';
import 'package:cpx_research_sdk_flutter/enumerations/cpx_widget_type.dart';
import 'package:cpx_research_sdk_flutter/utils/cpx_logger.dart';
import 'package:cpx_research_sdk_flutter/model/cpx_response.dart';
import 'package:http/http.dart' as http;

import '../cpx_data.dart';
import '../model/cpx_style.dart';

final String BASE_URL = "offers.cpx-research.com";
final String API_URL = "jsscriptv1-live.cpx-research.com";
final String IMAGE_URL = "dyn-image.cpx-research.com";

class CPXNetworkService {
  // TODO: Update package version here as well
  // The package_info_plus package just shows the app version not the package version and adding the pubspec.yaml to the assets is a security issue for flutter web.
  final String version = "1.0.1";

  CPXController controller = CPXController.controller;
  CPXData cpxData = CPXData.cpxData;

  String _homeEndpoint = "/index.php"; // HTML Page
  String _surveyEndpoint = "/api/get-surveys.php"; // Survey API
  String _imageEndpoint = "/image"; // Image API

  /// [_defaultRequestParameter] provides the default parameter for every request: appID, userID, sdk, sdkVersion
  Map<String, dynamic> get _defaultRequestParameter => {
        'app_id': controller.config.appID,
        'ext_user_id': controller.config.userID,
        'sdk': 'flutter',
        'sdkVersion': version,
      };

  /// [getCPXImage] provides the image url for the widgets
  Uri getCPXImage({
    required CPXWidgetType type,
    required String position,
    required CPXStyle style,
  }) {
    String backgroundColor =
        ".${style.backgroundColor.value.toRadixString(16).substring(2)}";
    String textColor =
        ".${style.textColor.value.toRadixString(16).substring(2)}";
    Map<String, dynamic> params = _defaultRequestParameter;
    params['type'] = type.key;
    params['width'] = style.width.toString();
    params['height'] = style.height.toString();
    params['emptycolor'] = "transparent";
    params['backgroundcolor'] = backgroundColor;
    params['corner'] = style.roundedCorners.toString();
    params['position'] = position;
    params['text'] = style.text;
    params['textcolor'] = textColor;
    params['textsize'] =
        (type == CPXWidgetType.corner ? style.textSize : style.textSize / 10)
            .toString();
    return Uri.https(IMAGE_URL, _imageEndpoint, params);
  }

  /// [getHomeURL] provides the home url for the webview
  Uri getHomeURL() {
    Map<String, dynamic> params = _defaultRequestParameter;
    if (controller.isSingleSurveyDisplayed) {
      params['survey_id'] =
          controller.singleSurveyID ?? cpxData.surveys.value![0].id;
    }
    return Uri.https(BASE_URL, _homeEndpoint, params);
  }

  /// [getHelpURL] provides the help url for the webview
  Uri getHelpURL() {
    Map<String, dynamic> params = _defaultRequestParameter;
    params['site'] = "help";
    return Uri.https(BASE_URL, _homeEndpoint, params);
  }

  /// [onWebViewError] is sending the [errorCode], [errorDescription] and [errorDomain] to the CPX API, if the browser throws an error
  void onWebViewError(
      String errorCode, String errorDescription, String errorDomain) async {
    Map<String, dynamic> params = _defaultRequestParameter;
    params['webViewErrorCode'] = errorCode;
    params['webViewErrorDescription'] = errorDescription;
    params['webViewErrorDomain'] = errorDomain;
    Uri url = Uri.https(BASE_URL, _homeEndpoint, params);
    await http.post(url).then((response) {
      if (response.statusCode == 200) {
        CPXLogger.log("WebView Error was send");
      } else {
        CPXLogger.log("API error ${response.statusCode}");
      }
    }).onError((error, stackTrace) => CPXLogger.log(
        "An error occurred while logging the browser error: $error"));
  }

  /// [setTransactionPaid] marks the transaction with the provided [transactionID] as paid
  void setTransactionPaid(String transactionID, String messageID) async {
    Map<String, dynamic> params = _defaultRequestParameter;
    params['transaction_set_paid'] = "true";
    params['transactionId'] = transactionID;
    params['messageId'] = messageID;
    Uri url = Uri.https(API_URL, _surveyEndpoint, params);
    CPXLogger.log("Mark transaction $transactionID as paid with url: $url");
    await http.post(url).then((response) {
      if (response.statusCode == 200) {
        CPXLogger.log("Transaction $transactionID marked as paid");
        fetchSurveysAndTransactions();
      } else {
        CPXLogger.log("API error ${response.statusCode}");
      }
    }).onError((error, stackTrace) =>
        CPXLogger.log("'Set transaction paid' API call failed: $error"));
  }

  /// [fetchSurveysAndTransactions] requests surveys and transactions from the api
  void fetchSurveysAndTransactions() async {
    Uri url = Uri.https(API_URL, _surveyEndpoint, _defaultRequestParameter);
    CPXLogger.log("Fetch surveys from api with url: $url");
    await http.post(url).then(
      (response) {
        if (response.statusCode == 200) {
          CPXLogger.log("Request successful");
          Map results = json.decode(response.body);
          CPXResponse cpxResponse =
              CPXResponse.fromJson(results as Map<String, dynamic>);

          /// Check if surveys are available
          if (cpxResponse.surveys != null && cpxResponse.surveys!.isNotEmpty) {
            CPXLogger.log(
                "Surveys and transactions fetched successfully from api");
            if (cpxData.surveys.value.toString() !=
                cpxResponse.surveys.toString()) {
              cpxData.surveys.value = cpxResponse.surveys;
              CPXLogger.log(
                  "${cpxResponse.surveys!.length} new surveys are available");
            } else {
              CPXLogger.log(
                  "0 new surveys are available, ${cpxData.surveys.value!.length} old surveys are available");
            }

            /// Check if transactions are available
            if (cpxResponse.transactions != null &&
                cpxResponse.transactions!.isNotEmpty) {
              if (cpxData.transactions.value.toString() !=
                  cpxResponse.transactions.toString()) {
                cpxData.transactions.value = cpxResponse.transactions;
                CPXLogger.log(
                    "${cpxResponse.transactions!.length} new transactions are available");
              } else {
                CPXLogger.log(
                    "0 new transactions are available, ${cpxData.transactions.value!.length} old transactions are available");
              }
            }

            /// Check if text is available
            if (cpxResponse.text != null) {
              if (cpxData.text.value.toString() !=
                  cpxResponse.text.toString()) {
                cpxData.text.value = cpxResponse.text;
                CPXLogger.log('New text ist available');
              } else {
                CPXLogger.log('Only the old text is available');
              }
            }
            controller.showCPXLayer();
          } else {
            CPXLogger.log("No surveys available");
            controller.hideCPXLayer();
            if (cpxResponse.error_code != null) {
              CPXLogger.log("API error message: ${cpxResponse.error_message}");
            }
          }
        } else {
          CPXLogger.log("API error ${response.statusCode}");
        }
      },
    ).onError(
        (error, stackTrace) => CPXLogger.log("Survey API call failed: $error"));
  }
}
