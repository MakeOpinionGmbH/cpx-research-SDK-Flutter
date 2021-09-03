import 'package:json_annotation/json_annotation.dart';

part 'cpx_response.g.dart';

/// [CPXResponse] contains the response model for surveys and transactions
@JsonSerializable(explicitToJson: true)
class CPXResponse {
  List<Survey> surveys;
  List<Transaction> transactions;
  String status;
  @JsonKey(name: 'count_available_surveys')
  int countAvailableSurveys;
  @JsonKey(name: 'count_returned_surveys')
  int countReturnedSurveys;
  CPXResponse(this.surveys, this.transactions, this.status, this.countAvailableSurveys, this.countReturnedSurveys);

  factory CPXResponse.fromJson(Map<String, dynamic> json) => _$CPXResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CPXResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Survey {
  String id;
  int loi;
  String payout;
  @JsonKey(name: 'conversion_rate')
  String conversionRate;
  @JsonKey(name: 'score')
  String score;
  @JsonKey(name: 'quality_score')
  String qualityScore;
  @JsonKey(name: 'statistics_rating_count')
  int statisticsRatingCount;
  @JsonKey(name: 'statistics_rating_avg')
  int statisticsRatingAvg;
  String type;
  int top;
  int details;

  Survey(
      this.id, this.loi, this.payout, this.conversionRate, this.score, this.qualityScore, this.statisticsRatingCount, this.statisticsRatingAvg, this.type, this.top, this.details);

  factory Survey.fromJson(Map<String, dynamic> json) => _$SurveyFromJson(json);

  Map<String, dynamic> toJson() => _$SurveyToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Transaction {
  @JsonKey(name: 'trans_id')
  String transactionID;
  @JsonKey(name: 'message_id')
  String messageID;
  String type;
  @JsonKey(name: 'verdienst_publisher')
  String verdienstPublisher;
  @JsonKey(name: 'verdienst_user_local_money')
  String verdienstUserLocalMoney;
  @JsonKey(name: 'subid_1')
  String subId1;
  @JsonKey(name: 'subid_2')
  String subId2;
  @JsonKey(name: 'datetime')
  String dateTime;
  String status;
  @JsonKey(name: 'survey_id')
  String surveyId;
  @JsonKey(name: 'ip')
  String ip;
  String loi;
  @JsonKey(name: 'is_paid_to_user')
  String isPaidToUser;
  @JsonKey(name: 'is_paid_to_user_datetime')
  String isPaidToUserDateTime;
  @JsonKey(name: 'is_paid_to_user_type')
  String isPaidToUserType;

  Transaction(this.transactionID, this.messageID, this.type, this.verdienstPublisher, this.verdienstUserLocalMoney, this.subId1, this.subId2, this.dateTime, this.status,
      this.surveyId, this.ip, this.loi, this.isPaidToUser, this.isPaidToUserDateTime, this.isPaidToUserType);

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
