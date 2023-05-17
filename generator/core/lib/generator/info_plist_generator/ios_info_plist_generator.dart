import 'dart:io';

import 'package:alternate_icon_gen_core/generator/enum_generator/icon_name_enum_generator.dart';
import 'package:alternate_icon_gen_core/generator/info_plist_generator/map_to_xml.dart';
import 'package:alternate_icon_gen_core/generator/info_plist_generator/plist_to_map.dart';
import 'package:alternate_icon_gen_core/setting/asset_type.dart';
import 'package:alternate_icon_gen_core/util/string.dart';
import 'package:collection/collection.dart';
import 'package:dart_style/dart_style.dart';
import 'package:dartx/dartx.dart';
import 'package:path/path.dart';

class PlistValue {
  PlistValue({
    required this.fileName,
    required this.assetName,
  });

  String fileName;
  String assetName;
}

String get plistFilePath => 'ios/Runner/Info.plist';

String generateIosInfoPlist(
  AssetsGenConfig config,
  DartFormatter formatter,
) {
  if (config.flutterAlternateIcon.asset.isEmpty) {
    throw Exception('The value of "flutter_Alternate_Icon/asset:" is incorrect.');
  }

  final alternateIconPlistMap = _createCFBundleAlternateIconsMap(
    config,
    (e) => (e.isUniqueWithoutExtension
        ? withoutExtension(e.assetType.path)
        : e.assetType.path)
      .replaceFirst(config.flutterAlternateIcon.asset, ''),
  );

  final map = _parseBasePlistToMap();
  final newMap = _replaceValue(map, alternateIconPlistMap);
  final newXml = _mapToXml(newMap);
  return newXml;
}

List<String> _getAssetRelativePathList(
  String rootPath,
  String assetName,
) {
  final assetRelativePathList = <String>[];
  final assetAbsolutePath = join(rootPath, assetName);
  if (FileSystemEntity.isDirectorySync(assetAbsolutePath)) {
    assetRelativePathList.addAll(Directory(assetAbsolutePath)
        .listSync()
        .whereType<File>()
        .map((e) => relative(e.path, from: rootPath))
        .toList());
  } else if (FileSystemEntity.isFileSync(assetAbsolutePath)) {
    assetRelativePathList.add(relative(assetAbsolutePath, from: rootPath));
  }

  return assetRelativePathList;
}

Map _createCFBundleAlternateIconsMap(
  AssetsGenConfig config,
  String Function(AssetTypeIsUniqueWithoutExtension) createName,
) {
  final assetPlistValues = _getAssetRelativePathList(
    config.rootPath,
    config.flutterAlternateIcon.asset,
  )
      .distinct()
      .sorted()
      .map((assetPath) => AssetType(rootPath: config.rootPath, path: assetPath))
      .mapToIsUniqueWithoutExtension()
      .map((e) => PlistValue(fileName: createName(e), assetName: createName(e).camelCase()))
      .toList();
  final assetsPlistKeyDefinition = _assetsPlistKeyDefinition(assetPlistValues);
  return assetsPlistKeyDefinition;
}

Map _assetsPlistKeyDefinition(List<PlistValue> plistValues) {
  final map = {};
  plistValues.forEach((e) => map[e.assetName] = {'CFBundleIconFiles': [e.fileName]});
  return map;
}

Map _parseBasePlistToMap() {
  final plistToMap = PlistToMap();
  final file = File(plistFilePath);
  final map = plistToMap.parse(file.readAsStringSync());
  return map;
}

bool _includeCFBundleIcons(Map map) => map.containsKey('CFBundleIcons');

Map _replaceValue(Map map, Map newMap) {
  if (_includeCFBundleIcons(map)) {
    final cfBundleIcons = map['CFBundleIcons'];
    cfBundleIcons['CFBundleAlternateIcons'] = newMap;
    return map;
  } else {
    final cfBundleIcons = {
      'CFBundlePrimaryIcon': {
        'CFBundleIconFiles': ['Icon-Default']
      },
      'CFBundleAlternateIcons': {}
    };
    cfBundleIcons['CFBundleAlternateIcons'] = newMap;
    map['CFBundleIcons'] = cfBundleIcons;
    return map;
  }
}

String _mapToXml(Map map) {
  final mapToXml = MapToXml();
  final newXml = mapToXml.convert(map);
  return newXml;
}