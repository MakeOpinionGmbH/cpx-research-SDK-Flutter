// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cpx_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CPXResponse _$CPXResponseFromJson(Map<String, dynamic> json) {
  return CPXResponse(
    (json['surveys'] as List)
        ?.map((e) =>
            e == null ? null : Survey.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['transactions'] as List)
        ?.map((e) =>
            e == null ? null : Transaction.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['text'] == null
        ? null
        : CPXText.fromJson(json['text'] as Map<String, dynamic>),
    json['status'] as String,
    json['error_code'] as String,
    json['error_message'] as String,
    json['count_available_surveys'] as int,
    json['count_returned_surveys'] as int,
  );
}

Map<String, dynamic> _$CPXResponseToJson(CPXResponse instance) =>
    <String, dynamic>{
      'surveys': instance.surveys?.map((e) => e?.toJson())?.toList(),
      'transactions': instance.transactions?.map((e) => e?.toJson())?.toList(),
      'text': instance.text?.toJson(),
      'status': instance.status,
      'error_code': instance.error_code,
      'error_message': instance.error_message,
      'count_available_surveys': instance.countAvailableSurveys,
      'count_returned_surveys': instance.countReturnedSurveys,
    };

Survey _$SurveyFromJson(Map<String, dynamic> json) {
  return Survey(
    json['id'] as String,
    json['loi'] as int,
    json['payout'] as String,
    json['payout_original'] as String,
    json['conversion_rate'] as String,
    json['score'] as String,
    json['quality_score'] as String,
    json['statistics_rating_count'] as int,
    json['statistics_rating_avg'] as int,
    json['type'] as String,
    json['top'] as int,
    json['details'] as int,
  );
}

Map<String, dynamic> _$SurveyToJson(Survey instance) => <String, dynamic>{
      'id': instance.id,
      'loi': instance.loi,
      'payout': instance.payout,
      'payout_original': instance.payoutOriginal,
      'conversion_rate': instance.conversionRate,
      'score': instance.score,
      'quality_score': instance.qualityScore,
      'statistics_rating_count': instance.statisticsRatingCount,
      'statistics_rating_avg': instance.statisticsRatingAvg,
      'type': instance.type,
      'top': instance.top,
      'details': instance.details,
    };

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return Transaction(
    json['trans_id'] as String,
    json['message_id'] as String,
    json['type'] as String,
    json['verdienst_publisher'] as String,
    json['verdienst_user_local_money'] as String,
    json['subid_1'] as String,
    json['subid_2'] as String,
    json['datetime'] as String,
    json['status'] as String,
    json['survey_id'] as String,
    json['ip'] as String,
    json['loi'] as String,
    json['is_paid_to_user'] as String,
    json['is_paid_to_user_datetime'] as String,
    json['is_paid_to_user_type'] as String,
  );
}

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'trans_id': instance.transactionID,
      'message_id': instance.messageID,
      'type': instance.type,
      'verdienst_publisher': instance.verdienstPublisher,
      'verdienst_user_local_money': instance.verdienstUserLocalMoney,
      'subid_1': instance.subId1,
      'subid_2': instance.subId2,
      'datetime': instance.dateTime,
      'status': instance.status,
      'survey_id': instance.surveyId,
      'ip': instance.ip,
      'loi': instance.loi,
      'is_paid_to_user': instance.isPaidToUser,
      'is_paid_to_user_datetime': instance.isPaidToUserDateTime,
      'is_paid_to_user_type': instance.isPaidToUserType,
    };

CPXText _$CPXTextFromJson(Map<String, dynamic> json) {
  return CPXText(
    json['currency_name_plural'] as String,
    json['currency_name_singular'] as String,
    json['shortcurt_min'] as String,
  );
}

Map<String, dynamic> _$CPXTextToJson(CPXText instance) => <String, dynamic>{
      'currency_name_plural': instance.currency_name_plural,
      'currency_name_singular': instance.currency_name_singular,
      'shortcurt_min': instance.shortcurt_min,
    };
