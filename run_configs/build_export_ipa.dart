import 'build_export.dart';
import 'run_enum.dart';

//This is a dart script that build and export iOS ipa to the Desktop.
//[For MacOS only]
void main() async {
  await buildExportIPA(type: AppBundleType.yueyuan);
}