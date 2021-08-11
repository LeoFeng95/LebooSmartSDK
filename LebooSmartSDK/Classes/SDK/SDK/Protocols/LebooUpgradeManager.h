//
//  LebooUpgradeManager.h
//  LebooSDK
//
//  Created by lebong on 2021/7/19.
//

#import <Foundation/Foundation.h>

@protocol LebooUpgradeDelegate <NSObject>

@optional


/// 设备固件升级
/// @param progress 升级进度
/// @param currentSpeedBytesPerSecond   每秒传输的字节数
- (void)upgradeManagerDidChangeProgress:(double)progress
             currentSpeedBytesPerSecond:(double)currentSpeedBytesPerSecond;

/// 固件升级成功
- (void)deviceUpgradeSuccessfully;

/// 固件升级失败
/// @param message 失败的原因说明
- (void)devcieUpgradeFailedWithMessage:(NSString *)message;

@end


@protocol LebooUpgradeManager <NSObject>

@optional

/// 固件升级 （升级成功或者失败设备都会断开连接，请重新连接设备 。升级失败重新连接设备的时候请将设备的mac地址最后一位+1, 如 82 -> 83,   FF -> 00。然后重新升级）
/// @param fileUrl 文件路径
/// @param delegate 升级代理
- (void)upgradeDeviceWithFile:(NSURL *)fileUrl delegate:(id<LebooUpgradeDelegate>)delegate;

@end


