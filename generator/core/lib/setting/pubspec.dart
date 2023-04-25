import 'package:json_annotation/json_annotation.dart';

part 'pubspec.g.dart';

@JsonSerializable()
class Pubspec {
  Pubspec({
    required this.flutterAlternateIcon,
    required this.flutter,
  });

  @JsonKey(name: 'flutter_alternate_icon', required: true)
  final FlutterAlternateIcon flutterAlternateIcon;

  @JsonKey(name: 'flutter', required: true)
  final Flutter flutter;

  factory Pubspec.fromJson(Map json) => _$PubspecFromJson(json);
}

@JsonSerializable()
class Flutter {
  Flutter({
    required this.assets,
  });

  @JsonKey(name: 'assets', required: true)
  final List<String> assets;

  factory Flutter.fromJson(Map json) => _$FlutterFromJson(json);
}

@JsonSerializable()
class FlutterAlternateIcon {
  FlutterAlternateIcon({
    required this.asset,
    required this.output,
  });

  @JsonKey(name: 'asset', required: true)
  final String asset;

  @JsonKey(name: 'output', required: true)
  final String output;

  factory FlutterAlternateIcon.fromJson(Map json) => _$FlutterAlternateIconFromJson(json);
}