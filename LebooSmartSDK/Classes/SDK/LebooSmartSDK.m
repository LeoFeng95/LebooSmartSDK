//
//  LebooSmartSDK.m
//  LebooSDK
//
//  Created by lebong on 2021/7/12.
//

#import "LebooSmartSDK.h"

#import "LebooConnectManager.h"
#import "LebooInstructManager.h"
#import "LebooUpgradeManager.h"

#import "LebooBLEManager.h"
#import "LebooInteractiveManager.h"
#import "LebooUpdateManager.h"
static LebooSmartSDK *_instance = nil;

@implementation LebooSmartSDK

+ (instancetype)shareSDK {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return  _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupInit];
    }
    return self;
}

- (void)setupInit {
    
    self.enableLogging = true;
//    NSDictionary *dic = @{@"key_diameter" : @2.4,
//                          @"dfu_number_of_packets" : @12,
//                          @"dfu_force_dfu" : @false};
////    [defaults registerDefaults:dic];
//    [[NSUserDefaults standardUserDefaults] registerDefaults:dic];
    //连接、扫描管理者
    self.connectManager = [[LebooBLEManager alloc] init];
    self.instructManager = [[LebooInteractiveManager alloc] init];
    self.upgradeManager = [[LebooUpdateManager alloc] init];
}



- (void)start {
//    self.enableLogging = true;
}





@end
