import 'dart:io';

import 'package:alternate_icon_gen_core/generator/flutter_generator.dart';
import 'package:alternate_icon_gen_core/generator/info_plist_generator/ios_info_plist_generator.dart';
import 'package:alternate_icon_gen_core/setting/config.dart';
import 'package:build/build.dart';
import 'package:crypto/crypto.dart';

import 'package:glob/glob.dart';
import 'package:path/path.dart';

Builder build(BuilderOptions options) => AlternateIconGenBuilder();

class AlternateIconGenBuilder extends Builder {
  static AssetId _output(BuildStep buildStep, String path) {
    return AssetId(
      buildStep.inputId.package,
      path,
    );
  }

  final generator = FlutterGenerator(File('pubspec.yaml'));
  late final _config = loadPubspecConfigOrNull(generator.pubspecFile);
  _AlternateIconGenBuilderState? _currentState;

  @override
  Future<void> build(BuildStep buildStep) async {
    if (_config == null) return;
    final state = await _createState(_config!, buildStep);
    if (state.shouldSkipGenerate(_currentState)) return;
    _currentState = state;

    await generator.build(
      config: _config,
      writer: (contents, path) {
        buildStep.writeAsString(_output(buildStep, path), contents);
      },
    );
  }

  @override
  Map<String, List<String>> get buildExtensions {
    if (_config == null) return {};
    final output = _config!.pubspec.flutterAlternateIcon.output;
    return {
      r'$package$': [
        for (final name in [
          generator.alternateIconsFileName,
        ])
          join(output, name),
          generator.plistFilePath,
      ],
    };
  }

  Future<_AlternateIconGenBuilderState> _createState(Config config, BuildStep buildStep) async {
    final pubspecAsset = await buildStep.findAssets(Glob(config.pubspecFile.path)).single;
    final pubspecDigest = await buildStep.digest(pubspecAsset);
    return _AlternateIconGenBuilderState(pubspecDigest: pubspecDigest);
  }
}

class _AlternateIconGenBuilderState {
  _AlternateIconGenBuilderState({
    required this.pubspecDigest,
  });

  final Digest pubspecDigest;

  bool shouldSkipGenerate(_AlternateIconGenBuilderState? previous) {
    if (previous == null) return false;
    return pubspecDigest == previous.pubspecDigest;
  }
}