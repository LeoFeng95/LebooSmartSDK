//
//  LebooConnectManager.h
//  LebooSDK
//
//  Created by lebong on 2021/7/14.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CBManager.h>

@class LebooPeripheral;

///连接回调
typedef void (^LebooConnectionBlock)(NSError *error);

///断开连接回调
typedef void (^LebooDisconnectBlock)(NSError *error);

///搜索回调
typedef void (^LebooSearchBlock)(LebooPeripheral *model, NSError *error);


@protocol LebooBLEDelegate <NSObject>

@optional

/// 设备断开连接
/// @param device 设备信息
/// @param error 错误
- (void)onDisconnect:(LebooPeripheral *)device error:(NSError *)error;

/// 蓝牙状态发生改变
/// @param state 蓝牙状态
- (void)onChangeState:(CBManagerState)state;

@end



@protocol LebooConnectManager <NSObject>

@optional


///当前连接的设备信息
@property (readonly) LebooPeripheral *peripheralInfo;

///蓝牙状态
@property (readonly) CBManagerState state;

/// 扫描设备，每扫描到一个对应的设备block会调用一次(到达扫描时间之后会回调block，error会提示扫描完成)
/// @param timeInterval 扫描时间
/// @param completion 扫描完成
- (void)startSearchDevice:(NSTimeInterval)timeInterval
               completion:(LebooSearchBlock)completion;


/// 停止扫描
- (void)stopScan;



/// 通过设备mac地址连接
/// @param mac 地址
/// @param time 超时时间
/// @param completion 连接完成 error为nil代表成功
- (void)connectPeriphralWithMac:(NSString *)mac
                        timeout:(NSTimeInterval)time
                     completion:(LebooConnectionBlock)completion;



/// 断开当前设备的连接
/// @param completion error为空表示断开成功
- (void)disConnectCompletion:(LebooDisconnectBlock)completion;


/// 添加代理(内部是弱引用对象不会造成内存泄漏所以不需要移除对象)
/// @param delegate 代理对象
- (void)addDelegate:(id<LebooBLEDelegate>)delegate;



@end




