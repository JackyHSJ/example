import 'dart:convert';
import 'dart:io';
import "package:path/path.dart";
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:git/git.dart';
import 'package:path/path.dart' as path;

import 'run_const.dart';
import 'run_enum.dart';

Future buildExportAAB() async {
  //1. Generate the ipa with flutter command
  stdout.write('== Generate the aab with flutter command ==\n');
  Process process = await Process.start(
      'fvm',
      [
        'flutter',
        'build',
        'appbundle'
      ],
      runInShell: true);
  await stdout.addStream(process.stdout);
  stdout.write('🍌\n');

  //2. Export the built ipa file to desktop
  stdout.write('== Export the built aab file to desktop ==\n');
  String scriptPath = dirname(Platform.script.toFilePath(windows: Platform.isWindows));
  Directory scriptDir = Directory(scriptPath);
  String projectPath = dirname(scriptDir.path);

  //Read pubspec file.
  File pubspecFile = File('$projectPath/pubspec.yaml');
  //Copy the file to desktop.
  Pubspec pubspec = Pubspec.parse(await pubspecFile.readAsString());
  String projectBaseName = pubspec.name;

  String? home = "";
  Map<String, String> envVars = Platform.environment;
  if (Platform.isMacOS) {
    home = envVars['HOME'];
  } else if (Platform.isLinux) {
    home = envVars['HOME'];
  } else if (Platform.isWindows) {
    home = envVars['UserProfile'];
  }

  final gitDir = await GitDir.fromExisting(path.current);
  BranchReference branchReference = await gitDir.currentBranch();
  String branchName = branchReference.branchName.split('/').last;

  //Try copy aab file.
  File aabFile = File('$projectPath/build/app/outputs/bundle/release/app-release.aab');
  if (aabFile.existsSync()) {
    Version? version = pubspec.version;
    if (version != null && home != null) {
      await aabFile.copy('$home/Desktop/$projectBaseName-$branchName-${version.major}_${version.minor}_${version.patch}.aab');
      stdout.write('🍌🍌 Export ipa version [$version] to [$home/Desktop/$projectBaseName-$branchName-${version.major}_${version.minor}_${version.patch}.aab]\n');
    }
  } else {
    stdout.write('Oops! release ipa not exist! [$projectPath/build/app/outputs/bundle/release/app-release.aab]\n');
  }
}

Future buildExportAPK({required String merchant}) async {
  //1. Generate the ipa with flutter command
  stdout.write('== Generate the apk with flutter command ==\n');
  Process process = await Process.start(
      'fvm',
      [
        'flutter',
        'build',
        'apk',
        '--release',
        '--flavor',
        'frechat',
        // '--dart-define=FLUTTER_ENV=PRODUCTION'
      ],
      runInShell: true);
  await stdout.addStream(process.stdout);
  stdout.write('🍌\n');

  //2. Export the built ipa file to desktop
  stdout.write('== Export the built apk file to desktop ==\n');
  String scriptPath = dirname(Platform.script.toFilePath(windows: Platform.isWindows));
  Directory scriptDir = Directory(scriptPath);
  String projectPath = dirname(scriptDir.path);

  //Read pubspec file.
  File pubspecFile = File('$projectPath/pubspec.yaml');
  //Copy the file to desktop.
  Pubspec pubspec = Pubspec.parse(await pubspecFile.readAsString());
  String projectBaseName = pubspec.name;

  String? home = "";
  Map<String, String> envVars = Platform.environment;
  if (Platform.isMacOS) {
    home = envVars['HOME'];
  } else if (Platform.isLinux) {
    home = envVars['HOME'];
  } else if (Platform.isWindows) {
    home = envVars['UserProfile'];
  }

  final gitDir = await GitDir.fromExisting(path.current);
  BranchReference branchReference = await gitDir.currentBranch();
  String branchName = branchReference.branchName.split('/').last;

  //Try copy apk file.
  File apkFile = File('$projectPath/build/app/outputs/flutter-apk/app-$projectBaseName-release.apk');
  if (apkFile.existsSync()) {
    Version? version = pubspec.version;
    if (version != null && home != null) {
      await apkFile.copy('$home/Desktop/$projectBaseName-$branchName-${version.major}_${version.minor}_${version.patch}_merchant-$merchant.apk');
      stdout.write('🍌🍌 Export ipa version [$version] to [$home/Desktop/$projectBaseName-$branchName-${version.major}_${version.minor}_${version.patch}.apk]\n');
    }
  } else {
    stdout.write('Oops! release apk not exist! [$projectPath/build/app/outputs/flutter-apk/app-release.apk]\n');
  }
}

//iOS IPA
/// Always is realease
Future buildExportIPA({
  required AppBundleType type
}) async {
  //1. Generate the ipa with flutter command
  stdout.write('== Generate the ipa with flutter command ==\n');
  final String appBundleType = _getAppBundleType(type);
  final String scriptPath = dirname(Platform.script.toFilePath(windows: Platform.isWindows));
  final Directory scriptDir = Directory(scriptPath);
  final String projectPath = dirname(scriptDir.path);

  Process process = await Process.start(
      'fvm',
      [
        'flutter',
        'build',
        'ipa',
        '--release',
        '--flavor',
        appBundleType,
        '--obfuscate',
        '--split-debug-info=$projectPath/obfuscate'
      ],
      runInShell: true);
  await stdout.addStream(process.stdout);
  await stderr.addStream(process.stderr);

  stdout.write('🍌\n');

  //2. Export the built ipa file to desktop
  stdout.write('== Export the built ipa file to desktop ==\n');

  //Read pubspec file.
  File pubspecFile = File('$projectPath/pubspec.yaml');
  //Copy the file to desktop.
  Pubspec pubspec = Pubspec.parse(await pubspecFile.readAsString());
  String projectBaseName = pubspec.name;

  String? home = "";
  Map<String, String> envVars = Platform.environment;
  if (Platform.isMacOS) {
    home = envVars['HOME'];
  } else if (Platform.isLinux) {
    home = envVars['HOME'];
  } else if (Platform.isWindows) {
    home = envVars['UserProfile'];
  }

  final gitDir = await GitDir.fromExisting(path.current);
  BranchReference branchReference = await gitDir.currentBranch();
  String branchName = branchReference.branchName.split('/').last;

  //Try copy ipa file.
  File ipaFile = File('$projectPath/build/ios/ipa/$projectBaseName.ipa');
  if (ipaFile.existsSync()) {
    Version? version = pubspec.version;
    if (version != null && home != null) {
      await ipaFile.copy('$home/Desktop/$appBundleType-$branchName-${version.major}_${version.minor}_${version.patch}.ipa');
      stdout.write('🍌🍌 Export ipa version [$version] to [$home/Desktop/$appBundleType-$branchName-${version.major}_${version.minor}_${version.patch}.ipa]\n');
    }
  } else {
    stdout.write('Oops! release ipa not exist! [$projectPath/build/ios/ipa/$appBundleType.ipa]\n');
  }
}

Future buildExportAPKDebug({required String merchant}) async {
  //1. Generate the ipa with flutter command
  stdout.write('== Generate the apk with flutter command ==\n');
  Process process = await Process.start(
      'fvm',
      [
        'flutter',
        'build',
        'apk',
        '--debug',
        '--flavor',
        'frechat',
      ],
      runInShell: true);
  await stdout.addStream(process.stdout);
  stdout.write('🍌\n');

  //2. Export the built ipa file to desktop
  stdout.write('== Export the built apk file to desktop ==\n');
  String scriptPath = dirname(Platform.script.toFilePath(windows: Platform.isWindows));
  Directory scriptDir = Directory(scriptPath);
  String projectPath = dirname(scriptDir.path);

  //Read pubspec file.
  File pubspecFile = File('$projectPath/pubspec.yaml');
  //Copy the file to desktop.
  Pubspec pubspec = Pubspec.parse(await pubspecFile.readAsString());
  String projectBaseName = pubspec.name;

  String? home = "";
  Map<String, String> envVars = Platform.environment;
  if (Platform.isMacOS) {
    home = envVars['HOME'];
  } else if (Platform.isLinux) {
    home = envVars['HOME'];
  } else if (Platform.isWindows) {
    home = envVars['UserProfile'];
  }
  //
  final gitDir = await GitDir.fromExisting(path.current);
  BranchReference branchReference = await gitDir.currentBranch();
  String branchName = branchReference.branchName.split('/').last;

  //Try copy apk file.
  File apkFile = File('$projectPath/build/app/outputs/flutter-apk/app-debug.apk');
  if (apkFile.existsSync()) {
    Version? version = pubspec.version;
    if (version != null && home != null) {
      final merchantName = merchant == '' ? 'phoneManufacture' : merchant.toLowerCase();
      await apkFile.copy('$home/Desktop/$projectBaseName-$branchName-${version.major}_${version.minor}_${version.patch}_debug_merchant-$merchantName.apk');
      stdout.write('🍌🍌 Export ipa version [$version] to [$home/Desktop/$projectBaseName-$branchName-${version.major}_${version.minor}_${version.patch}.apk]\n');
    }
  } else {
    stdout.write('Oops! debug apk not exist! [$projectPath/build/app/outputs/flutter-apk/app-debug.apk]\n');
  }
}

Future<void> buildAllMerchantAPK({
  required ApkType apkType
}) async {
  List<String> platforms = [
    MerchantName.openinstall,
    MerchantName.baidu,
    MerchantName.tencent,
    ''
  ];

  for (var platform in platforms) {
    final Map<String, dynamic> jsonObj = await loadTxt();
    jsonObj['merchant'] = platform;
    saveTxt(jsonObj);

    stdout.write('== 開始打包 $platform 平台的 APK ==\n');
    if(apkType == ApkType.release) {
      await buildExportAPK(merchant: platform);
    }

    if(apkType == ApkType.debug) {
      await buildExportAPKDebug(merchant: platform);
    }
  }
}

Future<Map<String, dynamic>> loadTxt() async {
  final File file = File('lib/system/constant/merchant.txt');
  final String contents = await file.readAsString();
  final Map<String, dynamic> jsonData = jsonDecode(contents);
  return jsonData;
}

Future<void> saveTxt(Map<String, dynamic> jsonData) async {
  try {
    final String jsonString = jsonEncode(jsonData);
    final File file = File('lib/system/constant/merchant.txt');
    await file.writeAsString(jsonString);
  } catch (e) {
    print('An error occurred while writing to the file: $e');
  }
}

String _getAppBundleType(AppBundleType type) {
  switch(type) {
    case AppBundleType.frechat:
      return 'frechat';
    case AppBundleType.yueyuan:
      return 'yueyuan';
  }
}