import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    let messageManager = GNSMessageManager(apiKey: "AIzaSyAhon76ezsL_Y_eI9Ddodr5jg8x-TjfvBw")
    
    GMSServices.provideAPIKey("AIzaSyBEg5Tu1h46jO7sStSmdGwwuBMZO5PSz48")
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
