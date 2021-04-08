import UIKit
import Flutter
import GoogleMaps

//This class represents the iOS version of this app
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var nearbyMessageChannel: FlutterMethodChannel!
    
    var messageManager: GNSMessageManager!
    
    var publication: GNSPublication!
    
    var subscription: GNSSubscription!
    
    var notifCenter: UNUserNotificationCenter!
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    //initialize notification center
    notifCenter = UNUserNotificationCenter.current()

    //request permission to send notifications
    notifCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (result, error) in
       
    }
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    
    //initialize Flutter method channel
    nearbyMessageChannel = FlutterMethodChannel(name: "nearby-message-api", binaryMessenger: controller.binaryMessenger)
    
    //initialize message manager
    messageManager = GNSMessageManager(apiKey: "AIzaSyAhon76ezsL_Y_eI9Ddodr5jg8x-TjfvBw")
    
    GNSMessageManager.setDebugLoggingEnabled(true)
    
    //set Flutter method channel listener
    nearbyMessageChannel.setMethodCallHandler({
              (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        switch call.method {
        case "toggleContactTracing":
            if let args = call.arguments as? Dictionary<String, Any>,
               let shouldTrace = args["shouldTrace"] as? Bool {
                self.toggleContactTracing(shouldScan: shouldTrace, result: result)
            }
        case "publish":
            if let args = call.arguments as? Dictionary<String, Any>,
               let message = args["message"] as? String {
                self.publish(message: message, result: result)
            }
        case "notifyContactTracing":
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
        
            })
    
    let contactTracingPref = UserDefaults.standard.bool(forKey: "flutter.contactTracing")
    
    //if contact tracing is on, start listening to messages
    if(contactTracingPref) {
        subscribe()
    }
    
    
    GeneratedPluginRegistrant.register(with: self)
    
    //google_maps_flutter setup
    //uses google_maps_flutter library
    GMSServices.provideAPIKey("AIzaSyBEg5Tu1h46jO7sStSmdGwwuBMZO5PSz48")
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
    //when the toggle contact tracing button is pressed
    private func toggleContactTracing(shouldScan: Bool, result: FlutterResult) {
        if(shouldScan) {
            subscribe()
        }
        else{
            unsubscribe()
        }
        result(nil)
        }
    
    //broadcast a message
    //uses NearbyMessagesLibrary
    private func publish(message:String, result: FlutterResult) {
        publication =
            messageManager!.publication(with: GNSMessage(content: message.data(using: .utf8)), paramsBlock: { (params: GNSPublicationParams?) in
                                        guard let params = params else { return }
                                        params.strategy = GNSStrategy(paramsBlock: { (params: GNSStrategyParams?) in
                                          guard let params = params else { return }
                                          params.discoveryMediums = .BLE
                                          params.discoveryMode = .default
                                          params.allowInBackground = false
                                        })
                                      })
        result(nil)
    }
    
    //listen to signals
    //uses NearbyMessages library
    private func subscribe() {
        subscription = (messageManager!.subscription(messageFoundHandler: { [unowned self] (message: GNSMessage?) in
            let messageString = String(data: (message?.content)!, encoding: .utf8)
            
            self.nearbyMessageChannel.invokeMethod("receivedMessage", arguments: ["message": messageString])
            
            let data = messageString!.data(using: .utf8)!
        
            
            do {
                if let messageJson = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:AnyObject] {
                    if let sick = messageJson["sick"] as? Bool {
                        if(sick) {
                        var notifBody: String!
                        if(messageJson["reason"] as! String == "SickReason.SYMPTOMS") {
                            notifBody = "Somebody near you has symptoms of Coronavirus"
                        }
                        else{
                            notifBody = "Somebody near you has tested positive for Coronavirus"
                        }
                        
                        let content = UNMutableNotificationContent()
                        content.title = "COVID Proximity Alert"
                        content.body = notifBody
                        
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:2.0, repeats: false)
                        
                        let request = UNNotificationRequest(identifier: "ContentIdentifier", content: content, trigger: trigger)
                        
                        //dispatch notificaiton if the user is sick
                        notifCenter.add(request) { (error) in
                            if error != nil {
                                print("error \(String(describing: error))")
                            }
                        }
                    }
                    }
                }
            } catch let error as NSError {
                print(error)
            }
        },
        messageLostHandler: { (message: GNSMessage?) in
            
        },
        paramsBlock:{ (params: GNSSubscriptionParams?) in
                  guard let params = params else { return }
                  params.strategy = GNSStrategy(paramsBlock: { (params: GNSStrategyParams?) in
                    guard let params = params else { return }
                    params.discoveryMediums = .default
                    params.discoveryMode = .default
                    params.allowInBackground = false
                  })
                }))
    }
    
    //stop listening to messsages
    private func unsubscribe(){
        subscription = nil
    }
}
