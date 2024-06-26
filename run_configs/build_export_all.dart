import 'build_export.dart';
import 'run_enum.dart';

//This is a dart script that build and export iOS ipa to the Desktop.
void main() async {
  // await buildExportAPK();
  // await buildExportAPKDebug(merchant: '');
  buildAllMerchantAPK(apkType: ApkType.release);
  // await buildExportAAB();
  await buildExportIPA(type: AppBundleType.frechat);
}