//
//  LebooSearchManager.h
//  LebooSDK
//
//  Created by lebong on 2021/7/12.
//

#import <Foundation/Foundation.h>
#import "LebooConnectManager.h"





@interface LebooBLEManager : NSObject<LebooConnectManager>


///当前的设备管理者
@property (nonatomic, strong, readonly) CBCentralManager *deviceManager;

///当前连接的设备
@property (nonatomic, strong, readonly) CBPeripheral *connectDevice;


///写入数据
- (void)writeData:(NSData *)data;


@end

