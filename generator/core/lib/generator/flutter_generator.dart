import 'dart:io';

import 'package:alternate_icon_gen_core/generator/icon_name_enum_generator.dart';
import 'package:alternate_icon_gen_core/setting/config.dart';
import 'package:alternate_icon_gen_core/util/file.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart';

class FlutterGenerator {
  const FlutterGenerator(
    this.pubspecFile, {
    this.alternateIconsName = 'alternate_icons.gen.dart',
  });

  final File pubspecFile;
  final String alternateIconsName;

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
      final generated = generateAssets(
        AssetsGenConfig.fromConfig(pubspecFile, config),
        formatter,
      );
      final assetsPath =
          normalize(join(pubspecFile.parent.path, output, alternateIconsName));
      writer(generated, assetsPath);
      stdout.writeln('Generated: $assetsPath');
    }

    stdout.writeln('AlternateIconGen finished.');
  }
}