import 'build_export.dart';
import 'run_enum.dart';

//This is a dart script that build and export iOS ipa to the Desktop.
void main() async {
  await buildAllMerchantAPK(apkType: ApkType.release);
}