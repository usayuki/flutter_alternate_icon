import 'dart:io';

import 'package:alternate_icon_gen_core/setting/asset_type.dart';
import 'package:alternate_icon_gen_core/setting/config.dart';
import 'package:alternate_icon_gen_core/setting/pubspec.dart';
import 'package:alternate_icon_gen_core/util/string.dart';
import 'package:collection/collection.dart';
import 'package:dart_style/dart_style.dart';
import 'package:dartx/dartx.dart';
import 'package:path/path.dart';

class AssetsGenConfig {
  AssetsGenConfig._(
    this.rootPath,
    this.flutterAlternateIcon,
  );

  factory AssetsGenConfig.fromConfig(File pubspecFile, Config config) {
    return AssetsGenConfig._(
      pubspecFile.parent.absolute.path,
      config.pubspec.flutterAlternateIcon,
    );
  }

  final String rootPath;
  final FlutterAlternateIcon flutterAlternateIcon;
}

String get header {
  return '''
/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterAlternateIcon
/// *****************************************************
''';
}

String generateAssets(
  AssetsGenConfig config,
  DartFormatter formatter,
) {
  if (config.flutterAlternateIcon.asset.isEmpty) {
    throw Exception('The value of "flutter_Alternate_Icon/asset:" is incorrect.');
  }

  final enumsBuffer = StringBuffer();
  enumsBuffer.writeln(_camelCaseStyleDefinition(config));

  final buffer = StringBuffer();
  buffer.writeln(header);
  buffer.writeln(enumsBuffer.toString());
  return formatter.format(buffer.toString());
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

String _camelCaseStyleDefinition(AssetsGenConfig config) {
  return _flatStyleDefinition(
    config,
    (e) => (e.isUniqueWithoutExtension
            ? withoutExtension(e.assetType.path)
            : e.assetType.path)
        .replaceFirst(config.flutterAlternateIcon.asset, '')
        .camelCase(),
  );
}

String _flatStyleDefinition(
  AssetsGenConfig config,
  String Function(AssetTypeIsUniqueWithoutExtension) createName,
) {
  final assetNameList = _getAssetRelativePathList(
    config.rootPath,
    config.flutterAlternateIcon.asset,
  )
      .distinct()
      .sorted()
      .map((assetPath) => AssetType(rootPath: config.rootPath, path: assetPath))
      .mapToIsUniqueWithoutExtension()
      .map((e) => createName(e))
      .toList();
  final assetsCaseNameDefinition = _assetsCaseNameDefinition(assetNameList);
  return '''
enum AlternateIcons {
  $assetsCaseNameDefinition
}
''';
}

String _assetsCaseNameDefinition(List<String> assetNameList) {
  return assetNameList.map((e) => '$e,').join('\n');
}