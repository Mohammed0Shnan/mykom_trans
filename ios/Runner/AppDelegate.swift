import UIKit
import Flutter
import Firebase
import FirebaseMessaging
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyD2mHkT8_abpMD9LJl307Qhk7GHWuKqMJw")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
}
