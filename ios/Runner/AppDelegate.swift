import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    
        let nearbyMessageChannel = FlutterMethodChannel(name: "nearby-message-api", binaryMessenger: controller.binaryMessenger)
    
    nearbyMessageChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        })
    
    GeneratedPluginRegistrant.register(with: self)
    
    let messageManager = GNSMessageManager(apiKey: "AIzaSyAhon76ezsL_Y_eI9Ddodr5jg8x-TjfvBw")
    
    GMSServices.provideAPIKey("AIzaSyBEg5Tu1h46jO7sStSmdGwwuBMZO5PSz48")
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
