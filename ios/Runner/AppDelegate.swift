import UIKit
import Flutter
import openinstall_flutter_plugin

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
    // Add this code. zego beauty use
    ZegoBeautyPlugin.register(with: registrar(forPlugin: "ZegoBeautyPlugin")!)

      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
  override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool{
  //处理通过openinstall一键唤起App时传递的数据
  OpeninstallFlutterPlugin.continue(userActivity)
  //其他第三方回调:
  return true
  }
    
  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    OpeninstallFlutterPlugin.handLinkURL(url)
    return true
  }
}
