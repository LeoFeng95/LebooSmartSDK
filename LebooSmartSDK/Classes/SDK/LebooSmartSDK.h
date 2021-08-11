//
//  LebooSmartSDK.h
//  LebooSDK
//
//  Created by lebong on 2021/7/12.
//

#import <Foundation/Foundation.h>

@protocol LebooConnectManager, LebooInstructManager, LebooUpgradeManager;

@interface LebooSmartSDK : NSObject

///支持的设备广播名数组（必须设置该参数）
@property (nonatomic, copy) NSArray<NSString *> *supportDevices;

///扫描，连接管理对象
@property (nonatomic, strong) id<LebooConnectManager> connectManager;

///指令交互对象
@property (nonatomic, strong) id<LebooInstructManager> instructManager;

/// 固件升级对象
@property (nonatomic, strong) id<LebooUpgradeManager> upgradeManager;


///是否打印控制台日志 default : true
@property (nonatomic, assign) BOOL enableLogging;


+ (instancetype)shareSDK;


- (void)start;

@end
