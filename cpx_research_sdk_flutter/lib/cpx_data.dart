
import 'package:flutter/material.dart';

import 'cpx_controller.dart';
import 'model/cpx_response.dart';
import 'utils/network_service.dart';

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
