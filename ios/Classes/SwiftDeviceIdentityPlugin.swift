import Flutter
import UIKit
import AdSupport
import AppTrackingTransparency
import WebKit


public class SwiftDeviceIdentityPlugin: NSObject, FlutterPlugin {

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "device_identity", binaryMessenger: registrar.messenger())
    let instance = SwiftDeviceIdentityPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "register":
        result("register")
      case "getIDFA":
        getIDFA() { idfa in
            if let idfa = idfa {
                result(idfa)
            } else {
                result("")
            }
        }
      case "getUA":
        getUserAgent() { userAgent, error in
            if let userAgent = userAgent {
                result(userAgent)
            } else {
                result("")
            }
        }
      default:
          result(FlutterMethodNotImplemented)
    }
  }

  func getIDFA(completion: @escaping (String?) -> Void) {
     // 检查是否可用AdSupport框架
    if #available(iOS 14.0, *) {
        // iOS 14.0及以上版本
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                // 用户授权了跟踪
                if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                    completion(ASIdentifierManager.shared().advertisingIdentifier.uuidString)
                } else {
                    completion(nil)
                }
            case .denied:
                // 用户拒绝了跟踪
                completion(nil)
            case .notDetermined:
                // 用户尚未做出选择
                // 可以选择稍后再次请求，或者提供一个备用方案
                completion(nil)
            case .restricted:
                // 跟踪被系统限制
                completion(nil)
            @unknown default:
                completion(nil)
            }
        }
    } else {
        // iOS 13.x及以下版本
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            completion(ASIdentifierManager.shared().advertisingIdentifier.uuidString)
        } else {
            completion(nil)
        }
    }
  }

  func getUserAgent(completion: @escaping (String?, Error?) -> Void) {
    let webView = WKWebView(frame: .zero)
    webView.evaluateJavaScript("navigator.userAgent") { (result, error) in
        if let error = error {
            completion(nil, error)
        } else if let userAgent = result as? String {
            completion(userAgent, nil)
        } else {
            completion(nil, NSError(domain: "", code: 4, userInfo: [NSLocalizedDescriptionKey : "User Agent is not a string"]))
        }
    }
  }
}
