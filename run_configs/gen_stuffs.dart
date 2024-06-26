import 'dart:io';

void main() async {
  //Generate the hive adapters
  Process process = await Process.start(
      'flutter',
      [
        'packages',
        'pub',
        'run',
        'build_runner',
        'build',
        '--delete-conflicting-outputs'
      ],
      runInShell: true);
  await stdout.addStream(process.stdout);
  stdout.write('🍌🍌🍌\n');
}
