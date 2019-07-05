//
//  ViewController.m
//  iOSDemo
//
//  Created by 李顺风 on 2019/6/30.
//  Copyright © 2019 李顺风. All rights reserved.
//

#import "ViewController.h"
#import <Flutter/Flutter.h>
#import "AppDelegate.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)goFlutter:(id)sender {
    FlutterViewController* flutterViewController = [[FlutterViewController alloc] initWithProject:nil nibName:nil bundle:nil];
    FlutterBasicMessageChannel* messageChannel = [FlutterBasicMessageChannel messageChannelWithName:@"channel"
                                                                                    binaryMessenger:flutterViewController
                                                                                              codec:[FlutterStandardMessageCodec sharedInstance]];//消息发送代码，本文不做解释
    __weak __typeof(self) weakSelf = self;
    [messageChannel setMessageHandler:^(id message, FlutterReply reply) {
        // Any message on this channel pops the Flutter view.
        [[weakSelf navigationController] popViewControllerAnimated:YES];
        reply(@"");
    }];
    NSAssert([self navigationController], @"Must have a NaviationController");
//    [[self navigationController]  pushViewController:flutterViewController animated:YES];
//self.window.rootViewController = flutterViewController;
     [(AppDelegate *)([UIApplication sharedApplication].delegate) window].rootViewController = flutterViewController;
//    [self presentViewController:flutterViewController animated:YES completion:nil];
    
    
}

@end
