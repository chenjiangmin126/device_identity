import Flutter
import UIKit
import AdSupport
import AppTrackingTransparency


public class SwiftDeviceIdentityPlugin: NSObject, FlutterPlugin {
    
    // 注册插件
    // 1. 注册方法通道
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "device_identity", binaryMessenger: registrar.messenger())
        let instance = SwiftDeviceIdentityPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    // 处理Flutter调用
    // 1. register: 注册
    // 2. getIDFA: 获取IDFA
    // 3. getUA: 获取User Agent
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "register":
            result("")
        case "getIDFA":
            getIDFA() { idfa in
                if let idfa = idfa {
                    result(idfa)
                } else {
                    result("")
                }
            }
        case "getUA":
            result("")
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // 获取IDFA
    // 1. 检查是否可用AdSupport框架
    // 2. 如果可用，检查用户是否授权跟踪
    // 3. 如果用户授权了跟踪，获取IDFA
    // 4. 如果用户拒绝了跟踪，返回nil
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
    
   
}
