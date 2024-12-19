import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.example.app/toast", binaryMessenger: controller.binaryMessenger)

        channel.setMethodCallHandler { (call, result) in
            if call.method == "showToast" {
                if let args = call.arguments as? [String: Any],
                   let message = args["message"] as? String,
                   let length = args["length"] as? String {
                    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    controller.present(alert, animated: true)
                    
                    let duration: TimeInterval = (length == "long") ? 3.5 : 1.5
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        alert.dismiss(animated: true)
                    }
                }
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
