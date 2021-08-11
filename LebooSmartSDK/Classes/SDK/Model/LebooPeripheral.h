//
//  LebooPeripheral.h
//  LebooSDK
//
//  Created by lebong on 2021/7/12.
//

#import <Foundation/Foundation.h>

@class CBPeripheral;

@interface LebooPeripheral : NSObject

///设备名字
@property (nonatomic, copy) NSString *name;

///设备mac地址
@property (nonatomic, copy) NSString *mac;

///信号强度
@property (nonatomic, strong) NSNumber *rssi;


@end

