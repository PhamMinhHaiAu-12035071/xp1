// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LocaleConfiguration _$LocaleConfigurationFromJson(Map<String, dynamic> json) =>
    _LocaleConfiguration(
      languageCode: json['languageCode'] as String,
      source: $enumDecode(_$LocaleSourceEnumMap, json['source']),
      countryCode: json['countryCode'] as String?,
    );

Map<String, dynamic> _$LocaleConfigurationToJson(
  _LocaleConfiguration instance,
) => <String, dynamic>{
  'languageCode': instance.languageCode,
  'source': _$LocaleSourceEnumMap[instance.source]!,
  'countryCode': instance.countryCode,
};

const _$LocaleSourceEnumMap = {
  LocaleSource.userSelected: 'userSelected',
  LocaleSource.systemDetected: 'systemDetected',
  LocaleSource.defaultFallback: 'defaultFallback',
};
