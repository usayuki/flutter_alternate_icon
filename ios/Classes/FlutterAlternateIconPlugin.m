#import "FlutterAlternateIconPlugin.h"
#if __has_include(<flutter_alternate_icon/flutter_alternate_icon-Swift.h>)
#import <flutter_alternate_icon/flutter_alternate_icon-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_alternate_icon-Swift.h"
#endif

@implementation FlutterAlternateIconPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterAlternateIconPlugin registerWithRegistrar:registrar];
}
@end
