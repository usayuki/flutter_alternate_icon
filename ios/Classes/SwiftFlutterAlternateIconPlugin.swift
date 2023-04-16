import Flutter

public class SwiftFlutterAlternateIconPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_alternate_icon", binaryMessenger: registrar.messenger())

        let instance = SwiftFlutterAlternateIconPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "supportsAlternateIcons":
            result(UIApplication.shared.supportsAlternateIcons)

        case "getAlternateIconName":
            result(UIApplication.shared.alternateIconName)
            
        case "setAlternateIconName":
            var iconName: String? = nil
            if let arguments = call.arguments as? [String: String] {
                iconName = arguments["iconName"]
            }
            UIApplication.shared.setAlternateIconName(iconName, completionHandler: { error in 
                if let e = error {
                    result(FlutterError(code: "\(e)", message: e.localizedDescription, details: nil))
                } else {
                    result(nil)
                }
            })

        case "getAlternateIconNames":
            guard
                let icons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
                let alternateIcons = icons["CFBundleAlternateIcons"] as? [String: Any]
            else {
                result(nil)
                return
            }
            let iconNames = alternateIcons.keys.map({ key in
                return key
            }) as? [String]
            result(iconNames)
            
        default:
            break
        }
    }
}
