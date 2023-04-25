import 'dart:io';


import 'package:alternate_icon_gen_core/setting/config_default.dart';
import 'package:alternate_icon_gen_core/setting/pubspec.dart';
import 'package:alternate_icon_gen_core/util/map.dart';
import 'package:yaml/yaml.dart';

class Config {
  Config._({required this.pubspec, required this.pubspecFile});

  final Pubspec pubspec;
  final File pubspecFile;
}

Config? loadPubspecConfigOrNull(File pubspecFile) {
  final content = pubspecFile.readAsStringSync();
  final userMap = loadYaml(content) as Map?;
  final defaultMap = loadYaml(configDefaultYamlContent) as Map?;
  final mergedMap = mergeMap([defaultMap, userMap]);
  final pubspec = Pubspec.fromJson(mergedMap);
  return Config._(pubspec: pubspec, pubspecFile: pubspecFile);
}