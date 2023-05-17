import 'dart:io';

import 'package:alternate_icon_gen_core/generator/enum_generator/icon_name_enum_generator.dart';
import 'package:alternate_icon_gen_core/generator/info_plist_generator/ios_info_plist_generator.dart';
import 'package:alternate_icon_gen_core/setting/config.dart';
import 'package:alternate_icon_gen_core/util/file.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart';

class FlutterGenerator {
  const FlutterGenerator(
    this.pubspecFile, {
    this.alternateIconsFileName = 'alternate_icons.gen.dart',
  });

  final File pubspecFile;
  final String alternateIconsFileName;

  String get plistFilePath => normalize(join(pubspecFile.parent.path, 'ios/Runner/Info.plist'));

  Future<void> build({Config? config, FileWriter? writer}) async {
    config ??= loadPubspecConfigOrNull(pubspecFile);
    if (config == null) return;

    final asset = config.pubspec.flutterAlternateIcon.asset;
    final output = config.pubspec.flutterAlternateIcon.output;
    final formatter = DartFormatter(pageWidth: 100, lineEnding: '\n');

    void defaultWriter(String contents, String path) {
      final file = File(path);
      if (!file.existsSync()) {
        file.createSync(recursive: true);
      }
      file.writeAsStringSync(contents);
    }

    writer ??= defaultWriter;

    final absoluteOutput =
        Directory(normalize(join(pubspecFile.parent.path, output)));
    if (!absoluteOutput.existsSync()) {
      absoluteOutput.createSync(recursive: true);
    }

    if (asset.isNotEmpty) {
      final generatedEnum = generateEnum(
        AssetsGenConfig.fromConfig(pubspecFile, config),
        formatter,
      );
      final assetsPath =
          normalize(join(pubspecFile.parent.path, output, alternateIconsFileName));
      writer(generatedEnum, assetsPath);
      stdout.writeln('Generated: $assetsPath');

      final generatedIosInfoPlist = generateIosInfoPlist(
        AssetsGenConfig.fromConfig(pubspecFile, config),
        formatter,
        plistFilePath,
      );
      writer(generatedIosInfoPlist, plistFilePath);
      stdout.writeln('Generated: $plistFilePath');
    }

    stdout.writeln('AlternateIconGen finished.');
  }
}