/*
 * cpx_data.dart
 * CPX Research
 *
 * Created by Dennis Kossmann on 7.7.2021.
 * Copyright © 2021. All rights reserved.
 */

import 'package:cpx_research_sdk_flutter/cpx.dart';
import 'package:cpx_research_sdk_flutter/widgets/cpx_browser_view.dart';
import 'package:flutter/material.dart';

import 'model/cpx_response.dart';
import 'utils/cpx_network_service.dart';

/// The class [CPXData] provides a ValueNotifier for surveys and transactions
class CPXData {
  static final CPXData cpxData = CPXData();
  ValueNotifier<List<Survey>?> surveys = ValueNotifier([]);
  ValueNotifier<List<Transaction>?> transactions = ValueNotifier([]);
  ValueNotifier<CPXText?> text = ValueNotifier(null);
}

/// The function [showCpxLayer] shows the CPX Layer
void showCpxLayer() => CPXController.controller.showCPXLayer();

/// The function [hideCpxLayer] hides the CPX Layer
void hideCpxLayer() => CPXController.controller.hideCPXLayer();

/// The function [showCPXBrowserOverlay] shows the CPX Browser
///
/// To open the CPX Browser with a specific survey, provide the optional [surveyID].
void showCPXBrowserOverlay([String? surveyID]) => surveyID != null
    ? CPXController.controller
        .showBrowser(singleSurvey: true, surveyID: surveyID)
    : CPXController.controller.showBrowser();

void showCPXBrowserDialog({
  required BuildContext context,
  required CPXConfig config,
  String? surveyID,
}) {
  CPXController.controller.config = config;
  CPXNetworkService().fetchSurveysAndTransactions();

  showDialog(
    context: context,
    builder: (context) => SizedBox.expand(
      child: CPXBrowserView(
        CPXBrowserTab.home,
        onClose: () => Navigator.pop(context),
      ),
    ),
  );
}

/// The function [fetchCPXSurveysAndTransactions] provides surveys and transactions via the survey and transaction listeners
void fetchCPXSurveysAndTransactions() =>
    CPXNetworkService().fetchSurveysAndTransactions();

/// The function [markTransactionAsPaid] sends an api request and marks transactions as paid
void markTransactionAsPaid(String transactionID, String messageID) =>
    CPXNetworkService().setTransactionPaid(transactionID, messageID);
