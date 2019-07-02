//
//  AppDelegate.m
//  FiOS
//
//  Created by 李顺风 on 2019/7/2.
//  Copyright © 2019 李顺风. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    FlutterViewController* flutterViewController = [[FlutterViewController alloc] initWithProject:nil nibName:nil bundle:nil];
    self.window.rootViewController = flutterViewController;
    return YES;
}


@end
