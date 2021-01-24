import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var messageFoundHandler = {(message: GNSMessage?) in
        //do something
    }
    
    var messageLostHandler = {(message: GNSMessage?) in
        //do something
    }
    
    var messageMgr: GNSMessageManager?
    
    var messageManager: GNSMessageManager?
    
    var subscription: GNSSubscription?
    
    var publication: GNSPublication?
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let nearbyChannel = FlutterMethodChannel(name: "nearby-message-api", binaryMessenger: controller.binaryMessenger)
    
    nearbyChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        switch call.method {
        case "toggleSubscribe":
            let args = call.arguments as! [String: Any]
            let shouldScan = args["shouldScan"] as! Bool
            self.toggleSubscribe(shouldScan: shouldScan, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    })
    
    GNSMessageManager.setDebugLoggingEnabled(true)
    
    messageManager = GNSMessageManager(
        apiKey: "AIzaSyAhon76ezsL_Y_eI9Ddodr5jg8x-TjfvBw",
        paramsBlock: {(params: GNSMessageManagerParams?) -> Void in
            guard let params = params else { return }
            
            params.bluetoothPermissionErrorHandler = { hasError in
                if (hasError) {
                    print("please allow Bluetooth")
                }
            }
            
            params.bluetoothPowerErrorHandler = { hasError in
                if (hasError) {
                    print("please turn on Bluetooth")
                }
            }
    })
    
    let nearbyPermission = GNSPermission { (granted: Bool) in
        //TODO implement ui handling with Flutter
    }
    
    GeneratedPluginRegistrant.register(with: self)

    GMSServices.provideAPIKey("AIzaSyBEg5Tu1h46jO7sStSmdGwwuBMZO5PSz48")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func toggleSubscribe(shouldScan: Bool, result: FlutterResult) {
        if(shouldScan){
            subscribe()
        }
        else{
            unsubscribe()
        }
        return result(nil)
    }
    
    private func subscribe(){
        subscription = messageManager?.subscription(messageFoundHandler: messageFoundHandler, messageLostHandler: messageLostHandler, paramsBlock: { (params: GNSSubscriptionParams!) in
            params.deviceTypesToDiscover = .bleBeacon
            params.beaconStrategy =
                GNSBeaconStrategy(paramsBlock: { (params: GNSBeaconStrategyParams!) in
                    params.allowInBackground = true
                })
        })
    }
    
    private func unsubscribe(){
        subscription = nil
    }
    
    private func publish(){
        let message: GNSMessage = GNSMessage(content: "hello".data(using: .utf8, allowLossyConversion: true))
        publication = messageManager?.publication(with: message)
    }
    
    private func unpublish(){
        publication = nil
    }
}
