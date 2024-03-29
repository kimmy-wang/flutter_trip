#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "AsrPlugin.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
    //register plugin
    [AsrPlugin registerWithRegistrar:[self registrarForPlugin:@"AsrPlugin"]];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
