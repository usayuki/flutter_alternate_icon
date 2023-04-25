// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pubspec.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pubspec _$PubspecFromJson(Map json) => $checkedCreate(
      'Pubspec',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['flutter_alternate_icon', 'flutter'],
        );
        final val = Pubspec(
          flutterAlternateIcon: $checkedConvert('flutter_alternate_icon',
              (v) => FlutterAlternateIcon.fromJson(v as Map)),
          flutter:
              $checkedConvert('flutter', (v) => Flutter.fromJson(v as Map)),
        );
        return val;
      },
      fieldKeyMap: const {'flutterAlternateIcon': 'flutter_alternate_icon'},
    );

Flutter _$FlutterFromJson(Map json) => $checkedCreate(
      'Flutter',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['assets'],
        );
        final val = Flutter(
          assets: $checkedConvert('assets',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
        );
        return val;
      },
    );

FlutterAlternateIcon _$FlutterAlternateIconFromJson(Map json) => $checkedCreate(
      'FlutterAlternateIcon',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['asset', 'output'],
        );
        final val = FlutterAlternateIcon(
          asset: $checkedConvert('asset', (v) => v as String),
          output: $checkedConvert('output', (v) => v as String),
        );
        return val;
      },
    );
